Shader "MJ/SpecularMask"
{
	Properties
	{
		_MainTint("Main Color", Color) = (1,1,1,1)				
		_MainTex("Main Texture", 2D) = ""{}
		_SpecularColor("Specular Color", Color) = (1,1,1,1)
		_SpecularMask("Specular Mask", 2D) = ""{}	
		_SpecPower("Specular Power", float) = 1
	}

	SubShader
	{
		Tags{"RenderType" = "Opaque"}
		LOD 200

		CGPROGRAM

		sampler2D _MainTex;
		float4 _MainTint;		
		float4 _SpecularColor;
		sampler2D _SpecularMask;		
		float _SpecPower;

		struct Input
		{
			float2 uv_MainTex;
			float2 uv_SpecularMask;			
		};

		struct CustomSurfaceOutput
		{
			float3 Albedo;
			float Alpha;
			float Gloss;
			float Emission;
			float3 SpecularColor;						
			float Specular;
			float3 Normal;
		};

		#pragma surface surf CustomPhong

		float4 LightingCustomPhong(CustomSurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
		{
			// 方式1 : 半角向量方式  //
			float diff = max(0, dot(s.Normal, lightDir));
			float2 halfVector = normalize(viewDir + lightDir);
			float nh = max(0, dot(s.Normal, halfVector));
			float spec = pow(nh, _SpecPower) * s.Specular;

			float4 c;
			c.rgb = s.Albedo * diff * _LightColor0.rgb + s.SpecularColor.rgb * spec * _LightColor0.rgb * atten * 2;

			return c;

			// // 方式2 : 扭曲法线方式 //
			// float diff = dot(s.Normal, lightDir);			
			// float3 reflectVector = normalize(2 * diff * s.Normal - lightDir);
			// float nr = max(0, dot(reflectVector, viewDir));
			// float spec = pow(nr, _SpecPower) * s.Specular;

			// float4 c;
			// c.rgb = s.Albedo * diff * _LightColor0.rgb + s.SpecularColor.rgb * spec * _LightColor0.rgb * atten * 2;

			// return c;
		}

		void surf(Input IN, in out CustomSurfaceOutput o)
		{
			float4 diffColor = tex2D(_MainTex, IN.uv_MainTex);
			float4 specColor = tex2D(_SpecularMask, IN.uv_SpecularMask);

			o.Albedo = diffColor.rgb * _MainTint.rgb;
			o.SpecularColor = specColor.rgb * _SpecularColor.rgb;
			o.Specular = specColor.r;
			o.Alpha = diffColor.a * _MainTint.a;
		}
		ENDCG
	}

	Fallback "Diffuse"
}