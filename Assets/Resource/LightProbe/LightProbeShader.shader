﻿Shader "MJ/Test/LightProbe"
{
	Properties
	{
		_MainTex("Main Texrure", 2D) = "white"{}
	}

	SubShader
	{
		// 一定要加上 "LightMode"="ForwardBase"  //
		Tags{"LightMode"="ForwardBase"}
		
		pass
		{
			CGPROGRAM			
			#pragma vertex vert
			#pragma fragment frag		
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct a2v
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;				
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 probeColor : COLOR;				
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

				float3 worldNormal = mul((float3x3)_Object2World, v.normal);
				// float3 worldNormal = mul(UNITY_MATRIX_IT_MV, v.normal);				
				o.probeColor = ShadeSH9(float4(worldNormal, 1));
				return o;
			}

			float4 frag(v2f i) : SV_TARGET
			{
				float4 finalColor = float4(1,1,1,1); // tex2D(_MainTex, i.uv);
				finalColor.rgb *= i.probeColor;
				return finalColor;
			}
			ENDCG
		}		
	}
}