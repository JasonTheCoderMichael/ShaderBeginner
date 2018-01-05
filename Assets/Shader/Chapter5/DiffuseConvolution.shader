Shader "MJ/DiffuseConvolution" 
{
	Properties 
	{
		_MainTint("Global Tint", Color) = (1,1,1,1)
		_BumpMap("Normal Map", 2D) = "bump"{}
		_AOMap("Ambient Occlusion Map", 2D) = "white"{}
		_CubeMap("Diffuse Convolution Cubemap", Cube) = ""{}
		_SpecIntensity("Specular Intensity", Range(0, 1)) = 0.4
		_SpecWidth("Specular Width", Range(0, 1)) = 0.2
	}

	SubShader
	{
		Tags{"RenderType" = "Opaque"}
		LOD 200

		CGPROGRAM 

		#pragma surface surf DiffuseConvolution
		// #pragma target 3.0

		float4 _MainTint;
		sampler2D _BumpMap;
		sampler2D _AOMap;
		samplerCUBE _CubeMap;
		float _SpecIntensity;
		float _SpecWidth;

		struct Input
		{
			float2 uv_AOMap;
			float3 worldNormal;
			float3 worldRefl;
			INTERNAL_DATA
		};

		inline float4 LightingDiffuseConvolution(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
		{
			// 获得所有向量 //
			viewDir = normalize(viewDir);
			lightDir = normalize(lightDir);
			s.Normal = normalize(s.Normal);
			float NdotL = dot(s.Normal, lightDir);
			float halfVec = normalize(viewDir + lightDir);

			// 开始计算高光部分 //
			float spec = pow(max(0, dot(s.Normal, halfVec)), s.Specular * 128) * s.Gloss;

			float4 c;
			c.rgb = (s.Albedo * atten) + spec;
			c.a = 1;
			return c;
		}
 
		void surf(Input IN, inout SurfaceOutput o)
		{
			float4 c = tex2D(_AOMap, IN.uv_AOMap);
			float3 normals = UnpackNormal(tex2D(_BumpMap, IN.uv_AOMap)).rgb;
			o.Normal = normals;

			float3 diffuseVal = texCUBE(_CubeMap, WorldNormalVector(IN, o.Normal)).rgb;
			// float3 diffuseVal = texCUBE(_CubeMap, WorldReflectionVector(IN, o.Normal)).rgb;
			o.Albedo = (c.rgb * diffuseVal) * _MainTint;
			o.Specular = _SpecWidth;
			o.Gloss = _SpecIntensity * c.rgb;
			o.Alpha = c.a;
		}

		ENDCG
	}

	Fallback "Diffuse"
}
