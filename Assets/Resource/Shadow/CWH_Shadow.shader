Shader "CWH/Shadow"
{
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			Tags{"LightMode"="ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "AutoLight.cginc"
			#include "UnityCG.cginc"
			#pragma multi_compile_fwdbase

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 N : TEXCOORD1;
				// LIGHTING_COORDS(3,4)
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.N = mul(float4(v.normal,0),_World2Object);
				// TRANSFER_VERTEX_TO_FRAGMENT(o);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float3	L = normalize(_WorldSpaceLightPos0);
				float3 N = normalize(i.N);
				return float4(1,0,0,1)*max(0,dot(L,N)); // *LIGHT_ATTENUATION(i);
			}
			ENDCG
		}
	}
	// FallBack "Diffuse"
}