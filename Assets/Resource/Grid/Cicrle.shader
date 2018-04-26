Shader "MJ/Medium/Circle"
{
	Properties
	{		
		_Color("Color", Color) = (1,1,1,1)		
	}

	SubShader
	{
		Tags{"Queue"="Geometry" "IgnoreRaycaster"="True" "RenderType"="Opaque"}

		pass
		{			
			CGPROGRAM					

			float4 _Color;		

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
				return step(len,radius)*_Color;
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
				// return DrawCircle(i.uv, float2(0.3, 0.3), 0.2);				
				return DrawFlower(i.uv, float2(0.5, 0.5), 0.3);
			}
			
			ENDCG
		}
	}
}