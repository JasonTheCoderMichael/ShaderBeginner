Shader "MJ/PostEffect/Overlay" 
{
	Properties
	{
		_MainTex("Main Texture(RGB)", 2D) = "white"{}
		_BlendTex("Blend Texture(RGB)", 2D) = "white"{}
		_Opacity("Blend Opacity", Range(0, 1)) = 1
	}

	SubShader
	{
		Tags{"Queue"="Geometry" "IgnoreRaycaster"="True" "RenderType"="Opaque"}

		pass
		{			
			CGPROGRAM
			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag

			sampler2D _MainTex;			
			sampler2D _BlendTex;
			fixed _Opacity;

			struct a2v
			{
				float4 pos : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.pos);				
				o.uv = v.texcoord;
				return o;
			}		

			float4 frag(v2f i) : SV_TARGET
			{
				float4 mainColor = tex2D(_MainTex, i.uv);
				float4 blendColor = tex2D(_BlendTex, i.uv);
				// 方式1, Multiply //
				// float4 multiplyColor = mainColor * blendColor;
				// float4 finalColor = lerp(mainColor, multiplyColor, _Opacity);

				// 方式2, Screen //
				// float4 screenColor = 1 - (1 - blendColor) * (1 - mainColor);
				// float4 finalColor = lerp(mainColor, screenColor, _Opacity);

				// 方式3, Overlay //				
				float4 multiplyColor = mainColor * blendColor;
				float4 screenColor = 1 - (1 - blendColor) * (1 - mainColor);
				fixed compareResult = step(0.5, blendColor.r);      // blendColor >= 0.5 时，结果为1，否则结果为0 //
				float4 overlayColor = compareResult * screenColor + (1 - compareResult) * multiplyColor;
				float4 finalColor = lerp(mainColor, overlayColor, _Opacity);
				
				return finalColor;
			}

			ENDCG	
		}
	}

	Fallback off
}
