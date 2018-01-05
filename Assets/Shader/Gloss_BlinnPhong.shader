Shader "MJ/Gloss_BlinnPhong"
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

		#pragma surface surf CustomBlinnPhong

		float4 LightingCustomBlinnPhong(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
		{
			float diff = max(0, dot(s.Normal, lightDir));
			float3 halfVector = normalize(viewDir + lightDir);
			float nh = max(0, dot(s.Normal, halfVector));
			float spec = pow(nh, _SpecPower);

			float4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * diff + _SpecularColor.rgb * _LightColor0.rgb * spec * atten * 2;
			c.a = s.Alpha;

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