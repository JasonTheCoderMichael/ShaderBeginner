Shader "MJ/Test/MultiCompile" 
{	
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		pass
		{
			CGPROGRAM

			#pragma multi_compile RED GREEN BLUE

			#pragma vertex vert_img
			#pragma fragment frag			
			#include "UnityCG.cginc"

			float4 frag(v2f_img i) : COLOR
			{
				float4 finalColor = float4(0,0,0,0);
				#ifdef RED
				finalColor = float4(1,0,0,1);
				#endif

				#ifdef GREEN
				finalColor = float4(0,1,0,1);
				#endif

				#ifdef BLUE
				finalColor = float4(0,0,1,1);
				#endif

				return finalColor;
			}
			ENDCG
		}
	}	
}
