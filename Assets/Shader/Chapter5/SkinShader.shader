Shader "MJ/SkinShader" 
{
	Properties 
	{
		_MainTint("Global Tint", Color) = (1,1,1,1)
		_MainTex("Base (RGB)", 2D) = "white"{}
		_BumpMap("Normal Map", 2D) = "bump"{}
		_CurveScale("Curvature Scale", Range(0.001, 0.09)) = 0.01
		_CurveAmount("Curvature Amount", Range(0, 1)) = 0.5
		_BumpBias("Normal Map Blur", Range(0, 5)) = 2
		_BRDF("BRDF Ramp", 2D) = "white"{}
		_FresnelVal("Fresnel Amount", Range(0.01, 0.3)) = 0.05
		_RimPower("Rim Falloff", Range(0, 5)) = 2
		_RimColor("Rim Color", Color) = (1,1,1,1)
		_SpecIntensity("Specular Intensity", Range(0, 1)) = 0.4
		_SpecWidth("Specular Width", Range(0, 1)) = 0.2
	}

	SubShader
	{
		Tags{"RenderType" = "Opaque"}
		LOD 200

		CGPROGRAM
		#pragma surface surf SkinShader
		#pragma target 3.0
		// #pragma only_renderers d3d9

		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _BRDF;
		float4 _MainTint;
		float4 _RimColor;
		float _CurveScale;
		float _CurveAmount;
		float _BumpBias;
		float _FresnelVal;
		float _RimPower;
		float _SpecIntensity;
		float _SpecWidth;

		struct Input
		{
			float2 uv_MainTex;
			float3 worldPos;
			INTERNAL_DATA
		};

		struct SurfaceOutputSkin
		{
			float3 Albedo;
			float3 Emission;
			float3 Normal;
			float3 BlurredNormals;
			float Specular;			
			float Gloss;
			float Alpha;
			float Curvature;						
		};

		inline float4 LightingSkinShader(SurfaceOutputSkin s, float3 lightDir, float3 viewDir, float atten)
		{
			viewDir = normalize(viewDir);
			lightDir = normalize(lightDir);
			s.Normal = normalize(s.Normal);
			float halfVec = normalize(viewDir + lightDir);
			float NdotL = dot(s.BlurredNormals, lightDir);
			
			// brdf //
			float3 brdf = tex2D(_BRDF, float2((NdotL * 0.5 + 0.5) * atten, s.Curvature)).rgb;

			// 菲涅尔效果 //
			float fresnel = saturate(pow(1 - dot(viewDir, halfVec), 5));
			fresnel += _FresnelVal * (1 - fresnel);
			float rim = saturate(pow(1 - dot(viewDir, s.BlurredNormals), _RimPower)) * fresnel;

			// 高光 // 
			float specBase = max(0, dot(s.Normal, halfVec));
			float spec = pow(specBase, s.Specular * 128) * s.Gloss;


			float4 c;
			c.rgb = s.Albedo * brdf * _LightColor0.rgb * atten + spec + rim * _RimColor.rgb;
			return c;
		}

		void surf(Input IN, inout SurfaceOutputSkin o)
		{
			float4 c = tex2D(_MainTex, IN.uv_MainTex);
			float3 normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
			float3 normalBlur = UnpackNormal(tex2Dbias(_BumpMap, float4(IN.uv_MainTex, 0, _BumpBias)));

			o.Normal = normal;			
			
			float curvature = length(fwidth(WorldNormalVector(IN, normalBlur))) 
			                  / length(fwidth(IN.worldPos)) * _CurveScale;			

			o.Albedo = c.rgb * _MainTint.rgb;
			o.Alpha = c.a;
			o.Specular = _SpecWidth;
			o.Gloss = _SpecIntensity;
			o.Curvature = curvature;
			
			o.BlurredNormals = normalBlur;
		}

		ENDCG
	}

	Fallback "Diffuse"
}
