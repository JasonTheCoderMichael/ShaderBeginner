Shader "MJ/Gloss_Phong"
{
	Properties
	{
		_MainTex("Main Texture", 2D) = ""{}
		_MainTint("Main Color", Color) = (1,1,1,1)		
		_SpecularColor("Specular Color", Color) = (1,1,1,1)
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
		float _SpecPower;

		struct Input
		{
			float2 uv_MainTex;
		};

		#pragma surface surf Phong

		float4 LightingPhong(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
		{
			float diff = dot(s.Normal, lightDir);
			float3 reflectionVector = normalize(2 * s.Normal * diff - lightDir);
			float spec = pow(max(0,dot(viewDir, reflectionVector)), _SpecPower);

			float3 finalSpec = _SpecularColor.rgb * spec;
			float4 c;
			c.xyz = s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * finalSpec;
			c.w = 1;

			return c;
		}

		void surf(Input IN, in out SurfaceOutput o)
		{
			float4 color = tex2D(_MainTex, IN.uv_MainTex);

			o.Specular = _SpecPower;
			o.Gloss = 1;
			o.Albedo = color.rgb;
			o.Alpha = color.a;
		}
		ENDCG
	}

	Fallback "Diffuse"
}