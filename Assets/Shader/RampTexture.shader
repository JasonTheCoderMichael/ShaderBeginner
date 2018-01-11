Shader "MJ/RampTexture"
{
	Properties
	{
		_MainColor("Main Color", Color) = (1,1,1,1)
		_RampTexture("Ramp Texture", 2D) = ""
	}

	SubShader
	{
		Tags{"RenderType" = "Opaque"}
		LOD 200

		CGPROGRAM

		float4 _MainColor;
		sampler2D _RampTexture;

		struct Input
		{
			float2 uv_RampTexture;
		};

		#pragma surface surf RampTexture
		float4 LightingRampTexture(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
		{
			float diff = dot(s.Normal, lightDir);
			float halfLambert = diff * 0.5 + 0.5;
			float rim = dot(s.Normal, viewDir);
			float3 rampColor = tex2D(_RampTexture, float2(halfLambert, rim)).rgb;			
			float4 color;
			color.rgb = s.Albedo * _LightColor0.rgb * rampColor;
			color.a = s.Alpha;
			return color;
		}

		void surf(Input IN, in out SurfaceOutput o)
		{
			o.Albedo = _MainColor;
		}
		ENDCG
	}

	Fallback "Diffuse"
}