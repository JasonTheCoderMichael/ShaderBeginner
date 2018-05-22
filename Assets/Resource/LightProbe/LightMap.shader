Shader "MJ/Test/LightMap"
{
	Properties
	{
		_MainTex("Main Texrure", 2D) = "white"{}
	}

	SubShader
	{
		pass
		{
			CGPROGRAM			
			#pragma vertex vert
			#pragma fragment frag
			// #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct a2v
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				#ifndef LIGHTMAP_OFF
				float2 texcoordLM : TEXCOORD1;
				#endif
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				// 可以参与烘焙 //
				#ifndef LIGHTMAP_OFF
				float2 lightmapUV : TEXCOORD1;
				#endif
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);				
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				#ifndef LIGHTMAP_OFF
				o.lightmapUV = v.texcoordLM * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif
				return o;
			}

			float4 frag(v2f i) : SV_TARGET
			{
				float4 finalColor = tex2D(_MainTex, i.uv);
				#ifndef LIGHTMAP_OFF
				finalColor.rgb *= DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lightmapUV));
				#endif

				return finalColor;
			}
			ENDCG
		}		
	}
}