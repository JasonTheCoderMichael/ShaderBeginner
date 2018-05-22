﻿Shader "MJ/VF/Diffuse"
{
	Properties
	{
		_MainTex("Main Texrure", 2D) = "white"{}
	}

	SubShader
	{
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
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;			
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);				
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);				
				return o;
			}

			float4 frag(v2f i) : SV_TARGET
			{
				float4 finalColor = tex2D(_MainTex, i.uv);
				return finalColor;
			}
			ENDCG
		}		
	}
}