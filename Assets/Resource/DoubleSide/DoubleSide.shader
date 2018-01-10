Shader "MJ/DoubleSide"
{
	Properties
	{
		_FrontTex("Front Texture", 2D) = "white"{}
		_BackTex("Back Texture", 2D) = "white"{}
	}

	SubShader
	{
		Tags{"Queue"="Geometry" "IgnoreRaycast"="True" "RenderType"="Opaque"}
		
		CGINCLUDE
		#include "UnityCG.cginc"

		sampler2D _FrontTex;
		sampler2D _BackTex;
		float4 _FrontTex_ST;
		float4 _BackTex_ST;

		struct a2v
		{
			float4 vertex : POSITION;               // 必须是 float4 //
			float4 texcoord : TEXCOORD0;
		};

		struct v2f
		{
			float4 pos : SV_POSITION;
			float2 uv : TEXCOORD0;
		};

		v2f vertFront(a2v v)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.uv = TRANSFORM_TEX(v.texcoord, _FrontTex);
			return o;
		}

		float4 fragFront(v2f i) : SV_TARGET
		{
			float4 col;
			col = tex2D(_FrontTex, i.uv);
			return col;			
		}

		v2f vertBack(a2v v)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.uv = TRANSFORM_TEX(v.texcoord, _BackTex);
			return o;
		}

		float4 fragBack(v2f i) : SV_TARGET
		{
			float4 col;
			col = tex2D(_BackTex, i.uv);
			return col;
		}
		ENDCG

		pass
		{
			cull back
			
			CGPROGRAM		
			#include "UnityCG.cginc"

			#pragma vertex vertFront
			#pragma fragment fragFront
			ENDCG
		}

		pass
		{
			cull front

			CGPROGRAM			
			#pragma vertex vertBack
			#pragma fragment fragBack
			ENDCG
		}
	}
}