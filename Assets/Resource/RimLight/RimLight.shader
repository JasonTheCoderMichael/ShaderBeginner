Shader "MJ/RimLight"
{
	Properties
	{

	}

	SubShader
	{
		Tags {"Queue"="Geometry" "IgnoreRaycast"="True" "RenderType"="Opaque"}

		pass
		{
			CGPROGRAM			
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct a2v
			{
				float4 vertex : POSITION;				
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;				
				float3 normal : NORMAL;
				float3 viewDir : TEXCOORD0;
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos =mul(UNITY_MATRIX_MVP, v.vertex);
				o.normal = v.normal;
				float4 worldPos = mul(_Object2World, v.vertex);
				o.viewDir = UnityWorldSpaceViewDir(worldPos);
				return o;
			}

			float4 frag(v2f i) : SV_TARGET
			{
				i.viewDir = normalize(i.viewDir);
				i.normal = normalize(i.normal);

				// // 方式1 //
				// if(saturate(dot(i.viewDir, i.normal) < 0.2)) 
				// {
				// 	return float4(1,1,0,1);
				// }				
				// else
				// {
				// 	return float4(1,0,0,1);
				// }

				// 方式2 //
				float rim = 1 - saturate(dot(i.viewDir, i.normal));
				return float4(1,0,0,1) + float4(1,1,0,1) * pow(rim, 2);
			}

			ENDCG
		}
	}
}