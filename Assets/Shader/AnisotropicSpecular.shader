Shader "MJ/AnisotropicSpecular"
{
	Properties
	{
		_MainTint("Diffuse Tint", Color) = (1,1,1,1)
		_MainTex("Base(RGB)", 2D) = "white"{}
		_SpecularColor("Specular Color", Color) = (1,1,1,1)		
		_Specular("Specular Amount", Range(0, 1)) = 0.5
		_SpecPower("Specular Power", Range(0, 1)) = 0.5
		_AnisofDir("Anisotropic Direction", 2D) = ""{}
		_AnisoOffset("Anisotropic Offset", Range(-1, 1)) = -0.2
	}

	SubShader
	{
		Tags{"RenderType" = "Opaque"}
		LOD 200

		CGPROGRAM		

		float4 _MainTint;
		sampler2D _MainTex;
		float4 _SpecularColor;
		float _Specular;
		float _SpecPower;
		sampler2D _AnisofDir;
		float _AnisoOffset;

		#pragma surface surf Anisotropic
		#pragma target 3.0
		#pragma debug
		
		struct SurfaceAnisoOutput
		{
			float3 Albedo;
			float3 Normal;
			float Alpha;
			float Gloss;
			float Specular; 
			float Emission; 			
			float3 AnisoDirection;
		};

		float4 LightingAnisotropic(SurfaceAnisoOutput s, float3 lightDir, float3 viewDir, float atten)
		{
			float3 halfVector = normalize(normalize(lightDir) + normalize(s.Normal));
			float NdotL = dot(s.Normal, normalize(lightDir)) * 0.5 + 0.5;   // saturate(dot(s.Normal, normalize(lightDir)));

			float HdotA = dot(s.Normal + s.AnisoDirection, halfVector);
			float aniso = max(0, sin(radians((HdotA + _AnisoOffset) * 180)));

			float spec = saturate(pow(aniso, s.Gloss * 128) * s.Specular);

			float4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * NdotL) + (_LightColor0.rgb * _SpecularColor.rgb * spec) * (atten);
			c.a = 1;
			return c;
		}

		struct Input
		{
			float2 uv_MainTex;	
			float2 uv_AnisofDir;				
		};		

		void surf(Input IN, inout SurfaceAnisoOutput o)
		{
			float4 c = tex2D(_MainTex, IN.uv_MainTex) * _MainTint;
			float3 anisoTex = UnpackNormal(tex2D(_AnisofDir, IN.uv_AnisofDir));
			
			o.AnisoDirection = anisoTex;
			o.Specular = _Specular;
			o.Gloss = _SpecPower;
			o.Albedo = c.rgb;
			o.Alpha = c.a;			
		}
		ENDCG
	}

	Fallback "Diffuse"
}