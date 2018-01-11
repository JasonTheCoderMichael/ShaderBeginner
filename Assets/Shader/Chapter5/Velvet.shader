Shader "MJ/Velvet" 
{
	Properties 
	{
		_MainTint("Global Tint", Color) = (1,1,1,1)
		_BumpMap("Normal Map", 2D) = "bump"{}
		_DetailBump("Detail Normal Map", 2D) = "bump"{}
		_DetailTex("Fabric Weave", 2D) = "white"{}
		_FresnelColor("Fresnel Color", Color) = (1,1,1,1)
		_FresnelPower("Fresnel Power", Range(0, 12)) = 3
		_RimPower("Rim Falloff", Range(0, 5)) = 2
		_SpecIntensity("Specular Intensity", Range(0, 1)) = 0.4
		_SpecWidth("Specular Width", Range(0, 1)) = 0.2
	}

	SubShader
	{
		Tags{"RenderType" = "Opaque"}
		LOD 200

		CGPROGRAM
		#pragma surface surf Velvet
		#pragma target 3.0
		
		sampler2D _BumpMap;
		sampler2D _DetailBump;
		sampler2D _DetailTex;
		float4 _FresnelColor;
		float4 _MainTint;
		float _FresnelPower;
		float _RimPower;
		float _SpecIntensity;
		float _SpecWidth;

		struct Input
		{
			float2 uv_BumpMap;
			float2 uv_DetailBump;
			float2 uv_DetailTex;			
		};

		inline float4 LightingVelvet(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
		{
			viewDir = normalize(viewDir);
			lightDir = normalize(lightDir);
			// s.Normal = normalize(s.Normal);
			float3 halfVec = normalize(lightDir + viewDir);
			float NdotL = max(0, dot(s.Normal, lightDir));
			
			// 高光 //
			float NdotH = max(0, dot(s.Normal, halfVec));  
			float spec = pow(NdotH, s.Specular * 128) * s.Gloss; 

			// 菲涅尔效果 //
			float HdotV = pow(1 - max(0, dot(halfVec, viewDir)), _FresnelPower);
			float NdotE = pow(1 - max(0, dot(s.Normal, viewDir)), _RimPower);
			float finalSpecMask = NdotE * HdotV;

			float4 c;
			c.rgb = s.Albedo * NdotL * _LightColor0.rgb + finalSpecMask * _FresnelColor.rgb * spec * atten * 2;
			c.a = 1;
			return c;
		}

		void surf(Input IN, inout SurfaceOutput o)
		{
			float4 c = tex2D(_DetailTex, IN.uv_DetailTex);
			float3 normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap)).rgb;
			float3 detail_normal = UnpackNormal(tex2D(_DetailBump, IN.uv_DetailBump)).rgb;
			float3 finalNormal = float3(normal.x + detail_normal.x,
			normal.y + detail_normal.y,
			normal.z + detail_normal.z);

			o.Albedo = _MainTint.rgb * c.rgb;
			o.Alpha = c.a;
			o.Normal = normalize(normal + detail_normal);
			o.Gloss = _SpecIntensity;
			o.Specular = _SpecWidth;
		}

		ENDCG
	}

	Fallback "Diffuse"
}
