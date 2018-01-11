Shader "MJ/Module" 
{
	Properties 
	{
		_MainTex ("Albedo (RGB)", 2D) = "white" {}		
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		 
		CGPROGRAM	
		// 宏的定义必须在 引用 .cginc 文件之前 //
		#define LIGHTCOLOR_BLUE	 		
		#include "CustomLightFunction.cginc"				
		

		#pragma surface surf SimpleDiff

		sampler2D _MainTex;

		struct Input 
		{
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o)
		 {			
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _MyColor;
			o.Albedo = c.rgb;									
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
