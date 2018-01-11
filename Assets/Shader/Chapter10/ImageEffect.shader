Shader "MJ/ImageEffect" 
{
	Properties 
	{
		_MainTex("Base(RGB)", 2D) = "white"{}
		_LuminosityAmount("Grayscale Amount", Range(0, 1)) = 1
		// asdluminosity("Grayscale Amount", Range(0, 1)) = 1		   // 变量名称可以不以下划线开始，也可以第一个字母不大写 //
	}
	SubShader 
	{ 
		Pass
		{
			CGPROGRAM

			#pragma vertex vert_img
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest 
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			fixed _LuminosityAmount;

			fixed4 frag(v2f_img i) : COLOR
			{
				fixed4 renderTex = tex2D(_MainTex, i.uv);				
				float luminosity = 0.299 * renderTex.r + 0.587 * renderTex.g + 0.114 * renderTex.b;
				fixed4 finalColor = lerp(renderTex, luminosity, _LuminosityAmount);
				return finalColor;
			}

			ENDCG
		}
		
	}
	FallBack "Diffuse"
}
