Shader "MJ/Fog"
{
	Properties
	{
		_MainTex("Main Texture(RGB)", 2D) = "white"{}         // 下面还声明了其他变量时，需要用 {}，下面没有其他变量时可以不用{} //
		_MainColor("Main Color", Color) = (1,1,1,1)		
	}

	SubShader
	{
		Tags{"Queue"="Geometry" "IgnoreProjector"="True" "RenderType"="Opaque"}

		Pass
		{
			Tags{"LightMode"="ForwardBase"}
			
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase			
			#pragma multi_compile_fog			
			
			// #pragma enable_d3d11_debug_symbols
			
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _MainColor;

			#include "UnityCG.cginc"       // 结尾不能带分号，只能在函数中使用分号 //

			struct a2v
			{
				float4 vertexPos : POSITION;
				float2 texcoord : TEXCOORD0;				
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)               // 结尾不用带分号，宏定义里已经带了 //
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertexPos);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				UNITY_TRANSFER_FOG(o, o.pos);
				return o;
			}

			float4 frag(v2f i) : SV_TARGET
			{
				float4 finalColor;
				float texColor = tex2D(_MainTex, i.uv);
				finalColor = texColor * _MainColor;
				UNITY_APPLY_FOG(i.fogCoord,finalColor);
				return finalColor;
			}

			ENDCG
		}
	}

	FallBack "Diffuse"
}