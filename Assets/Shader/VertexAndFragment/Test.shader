Shader "VertAndFrag/Test" 
{
	Properties
	{
		_MainTex("Main Texture", 2D) = ""{}      // “” 中输入的是默认值，当 _MainTex 图片没有被赋值时才会用到 //
	}
	SubShader 
	{
		Tags{"RenderType" = "Opaque"}
		LOD 200

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			sampler2D _MainTex;
			float4 _MainTex_ST;

			#include "UnityCG.cginc"

			struct appdata_my
			{
				float4 pos : POSITION;       // 一定要是 float4 类型 //
				float2 uv : TEXCOORD0;
			};
 
			struct v2f
			{
				float4 pos : SV_POSITION;     // 一定要是 float4 类型 //
				float4 color : COLOR;
				float2 uv : TEXCOORD0;
			};

			v2f vert(appdata_my v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.pos);
				o.color = float4(1,0,0,1);
				o.uv = v.uv;
				// o.uv = TRANSFORM_TEX(v.uv, _MainTex);				
				return o;
			}

			float4 frag(v2f i) : SV_TARGET
			{
				// float4 c = float4(0,1,0,1);
				// return c;

				// return i.color;

				float4 c = tex2D(_MainTex, i.uv);
				return c;
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
