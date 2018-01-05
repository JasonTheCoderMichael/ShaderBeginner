Shader "MJ/VertexAnimation" 
{
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,1)
		_Speed("Speed", float) = 1
		_MaxSize("Max Size", float) = 3
	}

	SubShader
	{
		pass
		{
			Tags{"Queue"="Geometry" "RenderType"="Opaque"}

			CGPROGRAM

			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag
			
			float4 _Color;
			float _Speed;
			float _MaxSize;

			struct v2f
			{
				float4 pos: SV_POSITION;				
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				float4 vertPos = v.vertex;				
				vertPos.x += vertPos.x * (abs(_SinTime.w) * _Speed + 1);
				// vertPos.y += vertPos.y * (_SinTime.w * _Speed + 1);
				o.pos = mul(UNITY_MATRIX_MVP, vertPos);				
				return o;
			}

			float4 frag(v2f i) : COLOR
			{				
				return _Color;
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
