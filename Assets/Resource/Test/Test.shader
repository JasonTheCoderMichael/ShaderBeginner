Shader "MJ/Medium/Test"
{
	Properties
	{		
		_MainTex("Main Texture", 2D) = " white"{}
		_GridSize("Grid Size", float) = 4
	}

	SubShader
	{
		Tags{"Queue"="Geometry" "IgnoreRaycaster"="True" "RenderType"="Opaque"}

		pass
		{			
			CGPROGRAM			

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"			

			sampler2D _MainTex;			
			float _GridSize;

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

			// 获取一个随机数 //
			fixed2 Rand22(fixed2 co)
			{
				fixed x = frac(sin(dot(co.xy ,fixed2(122.9898,783.233))) * 43758.5453);
				fixed y = frac(sin(dot(co.xy ,fixed2(457.6537,537.2793))) * 37573.5913);
				return fixed2(x,y);
			}

			float3 GetColor(float2 uv)
			{				 
				// int row = floor(uv.y);        // 行 //
				// int column = floor(uv.x);     // 列 //
				// float3 color = float3(Rand22(float2(column, row)),0);      // 以行列为单位，去随机数，以达到为每个小方块分配一个随机数 //

				// 和上面三行代码意义一样 //
				float3 color = float3(Rand22(floor(uv)),0);

				return color;
			}

			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.texcoord;
				return o;
			}

			float4 frag(v2f i) :SV_TARGET
			{			
				float4 finalColor = float4(0,0,0,1);				
				i.uv *= _GridSize;

				// 每个小块都是不同颜色 //				
				float3 col = GetColor(i.uv);
				finalColor = float4(col, 1);


				// // 每个小块都绕圈旋转 //
				// int row = floor(i.uv.y);
				// int column = floor(i.uv.x);
				// float factorRow = (row - 1.5);
				// float factorCol = (column - 1.5);

				// float2 offset = float2(sin(_Time.y) * factorRow, cos(_Time.y) * factorCol);
				// i.uv += offset;
				// i.uv = frac(i.uv);
				// finalColor = tex2D(_MainTex, i.uv);


				// // 每行移动方向不一样 //
				// int row = floor(i.uv.y);				
				// int factorX = step(0.5, row) * 2 - 1;
				// int factorY = step(1.5, row) * 2 - 1;
				// int mod = fmod(row, 2);
				// i.uv.x += abs(mod - 1) * _Time.y * factorX;
				// i.uv.y += mod * _Time.y * factorY;
				// i.uv = frac(i.uv);				
				// finalColor = tex2D(_MainTex, i.uv);

				// // 每个小块不同颜色 //
				// float2 row = floor(i.uv.y);
				// float2 column = floor(i.uv.x);
				// i.uv = frac(i.uv);     // 这样即使图片不是Repeat模式也可以实现分隔 //

				// float val = (row * gridSize + column) * 1 / (gridSize * gridSize);
				// finalColor = tex2D(_MainTex, i.uv);
				// finalColor = float4(val,val,val,1);

				return finalColor;
			}
			
			ENDCG
		}
	}
}