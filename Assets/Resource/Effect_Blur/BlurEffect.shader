Shader "MJ/PostEffect/Blur"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}		
		_BlurCenterX("Blur Center X", float) = 1
		_BlurCenterY("Blur Center Y", float) = 1
		_Scale("Blur Scale", Range(0, 1)) = 0
		_IteraNum("Iteration Times", Range(1, 20)) = 3		
	}
	SubShader
	{
		pass
		{
			CGPROGRAM

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;		
			float4 _MainTex_TexelSize;	
			float _Scale;
			int _IteraNum;
			float _BlurCenterX;
			float _BlurCenterY;			

			#pragma vertex vert
			#pragma fragment frag

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

			float4 frag(v2f i): COLOR
			{		
				// 模糊效果 //		
				float2 center = float2(_BlurCenterX, _BlurCenterY);
				float2 dir = i.uv - center;			
				float dirLen = length(dir);

				float4 color = float4(0,0,0,0);
				for(int j = 0; j < _IteraNum; j++)
				{
					// 方式1, 沿着当前uv和中心点的方向，连续取若干个像素的颜色值相加，然后求平均值 //
					float2 uv = i.uv + dirLen * _Scale * j * dir;
					color += tex2D(_MainTex, uv);										
				}				
				
				color /= _IteraNum;
				return color;
			}
			ENDCG
		}
	}
}
