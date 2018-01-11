Shader "MJ/Gloss"
{
	Properties
	{
		_MainTex("Main Texture", 2D) = ""{}
		_MainTint("Main Color", Color) = (1,1,1,1)		
		_SpecColor("Specular Color", Color) = (1,1,1,1)
		_SpecPower("Specular Power", float) = 1
	}

	SubShader
	{
		Tags{"RenderType" = "Opaque"}
		LOD 200

		CGPROGRAM

		sampler2D _MainTex;
		float4 _MainTint;		
		// float4 _SpecColor;
		float _SpecPower;

		struct Input
		{
			float2 uv_MainTex;
		};

		struct SurfaceOutput22
		{
			float3 Albedo;
			float3 Normal;			
			float Emission;		
			float Alpha;
			float Specular;
		};

		#pragma surface surf Custommode //Lambert	

		float4 LightingCustommode(SurfaceOutput22 s, float lightDir, float atten)
		{
			return float4(s.Albedo, s.Alpha);
		}

		void surf(Input IN, in out SurfaceOutput22 o)
		{
			float4 color = tex2D(_MainTex, IN.uv_MainTex);

			o.Specular = _SpecPower;
			// o.Gloss = 1;
			o.Emission = 0.3;
			o.Albedo = color.rgb;
			o.Alpha = color.a;
		}
		ENDCG
	}

	Fallback "Diffuse"
}