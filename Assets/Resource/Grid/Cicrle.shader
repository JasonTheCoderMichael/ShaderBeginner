Shader "MJ/Medium/FundamentalMath"
{
	Properties
	{	
		_CloudColor("Cloud Color", Color) = (1,1,1,1)	
		_Color("Color", Color) = (1,1,1,1)		
	}

	SubShader
	{
		Tags{"Queue"="Geometry" "IgnoreRaycaster"="True" "RenderType"="Opaque"}

		pass
		{			
			CGPROGRAM					

			float4 _Color;		
			float4 _CloudColor;

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
			
			float4 Circle(float2 uv, float2 center, float radius)
			{
				center = clamp(center, float2(0,0), float2(1,1));
				radius = clamp(radius, 0, 0.7);

				float len = length(uv - center);
				float4 color = float4(0,0,0,0);
				if(len <= radius)
				{
					color = _Color;
				}			
				return color;
			}

			float4 AngleCircle(float2 uv, float2 center, float size)
			{
				// 转换到极坐标 //
				uv = uv - center;
				float deg = atan2(uv.y, uv.x);
				float len = length(uv);
				float offset = sin(deg);
				float val = smoothstep(size-offset, size+offset, len);
				return float4(val,val,val,1);
			}

			float4 DrawFlower(float2 uv, float2 center, float size)
			{
				uv -= center;
				float deg = atan2(uv.y,uv.x) + _Time.y;
				float len = length(uv);
				float offs = abs(sin(deg*3))*0.2*size;
				float val = smoothstep(size+offs-0.05, size+offs,len);
				return float4(val, val, val, 1);
			}

			float4 DrawCircle(float2 uv, float2 center, float radius)
			{
				uv -= center;
				float len = length(uv);
				return step(len,radius);
			}

			// float4 DrawCircle(float2 uv, float2 center, float radius)
			// {
			// 	uv -= center;
			// 	uv /= radius;
			// 	float len = length(uv);
			// 	return step(len, 1)*_Color;
			// }

			float4 DrawBouncingCircle(float2 uv, float2 center, float radius)
			{
				uv -= center + float2(0, abs(sin(_Time.y))*0.5);
				float len = length(uv);
				return step(len,radius)*_Color;
			}

			float4 DrawCloud(float2 uv, float2 center)
			{				
				float4 col = float4(0,0,0,0);
				float circleSize = 0.02;	
				col += DrawCircle(uv, center + float2(0, 0), circleSize);
				col += DrawCircle(uv, center + float2(0.01, 0.01), circleSize);
				col += DrawCircle(uv, center + float2(0.03, 0.015), circleSize);
				col += DrawCircle(uv, center + float2(0.05, 0.005), circleSize);
				col += DrawCircle(uv, center + float2(0.04, 0), circleSize);
				col += DrawCircle(uv, center + float2(0.035, -0.01), circleSize);
				col += DrawCircle(uv, center + float2(0.015, -0.01), circleSize);
				
				col = step(_CloudColor, col) * _CloudColor;			
				return col;
			}

			float4 DrawClouds(float2 uv)
			{
				float4 col = float4(0,0,0,0);
				col += DrawCloud(uv, float2(0.1, 0.7));
				col += DrawCloud(uv, float2(0.3, 0.8));
				col += DrawCloud(uv, float2(0.5, 0.7));								
				col += DrawCloud(uv, float2(0.7, 0.8));
				
				return col;
			}

			float4 AngleCircle2(float2 uv, float2 center, float size)
			{
				uv -= center;
				float deg = atan2(uv.y, uv.x) + _Time.y;
				float len = length(uv);
				float offset = abs(sin(deg*4))*0.2*size;
				float4 col = smoothstep(size+offset+0.05, size+offset, len);
				return col;
			}

			float4 DrawSun(float2 uv, float2 center, float2 size)
			{
				float4 haloColor = AngleCircle2(uv, center, size) * float4(1,1,0,1);
				float4 sunColor = DrawCircle(uv, center, 0.9*size) * float4(1,0,0,1);
				float4 finalColor = lerp(haloColor, sunColor, sunColor.r);
				return finalColor;
			}

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.texcoord;
				return o;
			}

			float4 frag(v2f i) :SV_TARGET
			{				
				// return DrawCircle(i.uv, float2(0.5, 0.5), 0.1);
				// return DrawFlower(i.uv, float2(0.5, 0.5), 0.3);
				// return DrawBouncingCircle(i.uv, float2(0.5, 0), 0.2);
				
				float4 col = float4(0,0,0,0);
				col += DrawClouds(frac(i.uv+float2(_Time.x, 0)));

				col += DrawSun(i.uv, float2(0.85, 0.85), 0.05);
				return col;
			}
			
			ENDCG
		}
	}
}