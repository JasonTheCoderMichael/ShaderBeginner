Shader "MJ/PostEffect/Mosaic"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}		
		_MosaicSize("Mosaic Size", Range(1, 200)) = 1        // 马赛克块的大小,单位是像素 //
		_Raduis("Mosaic _Raduis", Range(1, 200)) = 1
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
			int _MosaicSize;
			float _Raduis;

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
				// 马赛克效果 //
				// 用在屏幕后处理时, _MainTex_TexelSize.x == 1/_MainTex_TexelSize.z //
				// 但是 _MainTex_TexelSize.y != 1/_MainTex_TexelSize.w //
				float2 screenPos = i.uv * _MainTex_TexelSize.zw;      // 从UV坐标变到像素 //				

				// 方块状马赛克 //
				// screenPos = floor(screenPos/_MosaicSize) * _MosaicSize;
				// i.uv = screenPos * _MainTex_TexelSize.xy;         // 再变回到uv坐标 //

				// 圆形马赛克 //
				float diameter = 2*_Raduis;
				float2 center = floor(screenPos/diameter)*diameter + float2(_Raduis, _Raduis);    // 圆心位置 //
				float2 centerUV = center * _MainTex_TexelSize.xy;
				float len = length (screenPos - center);     // 到圆心的距离 //
				float4 finalColor;
				if(len < _Raduis)      // 在圆形区域内, 使用原点的颜色 //
				{
					finalColor = tex2D(_MainTex, centerUV);
				}
				else                   // 在圆形区域外, 使用黑色 //
				{
					finalColor = float4(0,0,0,1);
				}
				
				// 图片移动效果 //
				// i.uv.x += _Time.x;
				// i.uv.x = clamp(i.uv.x, 0, 1);
				// i.uv.y += abs(_SinTime.w);
				// float4 finalColor = tex2D(_MainTex, i.uv);

				return finalColor;
			}
			ENDCG
		}
	}
}
