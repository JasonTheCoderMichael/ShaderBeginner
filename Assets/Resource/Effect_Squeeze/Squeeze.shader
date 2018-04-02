Shader "MJ/PostEffect/Squeeze"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_CenterX("Center X", float) = 0.5
		_CenterY("Center Y", float) = 0.5
		_Speed("Speed", float) = 1		
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
			float _Speed;
			float _CenterX;
			float _CenterY;

			float asd;

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
				float2 center = float2(_CenterX, _CenterY);				
				float radius = _MainTex_TexelSize.w/2 - _Time.y * _Speed;   // 多个 _Time.y 相乘就是加速效果 //
				float2 centerScreenPos = center * _MainTex_TexelSize.zw;
				float2 curPixelScreenPos = i.uv * _MainTex_TexelSize.zw;
				float distance = length(curPixelScreenPos - centerScreenPos);
				float4 finalColor;
				if(distance > radius)
				{
					finalColor = float4(0,0,0,1);
				}
				else
				{
					finalColor = tex2D(_MainTex, i.uv);
				}				

				return finalColor;
			}
			ENDCG
		}
	}
}
