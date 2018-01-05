Shader "MJ/NormalMap" 
{
	Properties
	{
		_MainTint("Main Color", Color) = (1,1,1,1)
		_BumpTex("Bump Texture", 2D) = "bump"{}		
		_NormalIntensity("Normal Intensity", Range(0, 4)) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"}
		LOD 200
        
		CGPROGRAM        
		#pragma surface surf Lambert
		#include "UnityCG.cginc"

		float4 _MainTint;
        sampler2D _BumpTex; 
		float _NormalIntensity;

		struct Input
		{
			float2 uv_BumpTex;
		};		      
        
		void surf(Input asd, inout SurfaceOutput o)
		{
			float4 color = tex2D(_BumpTex, asd.uv_BumpTex);
			o.Albedo = _MainTint.rgb;
			o.Alpha = _MainTint.a;
			float3 normalMap = UnpackNormal(color).rgb;
			normalMap = float3(normalMap.x * _NormalIntensity, normalMap.y * _NormalIntensity, normalMap.z);
			o.Normal = normalMap;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
