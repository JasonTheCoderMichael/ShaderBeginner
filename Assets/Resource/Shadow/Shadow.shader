Shader "MJ/Shadow"
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
			
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _MainColor;

			#include "UnityCG.cginc"       // 结尾不能带分号，只能在函数中使用分号 //
			#include "AutoLight.cginc"

			struct a2v
			{
				float4 vertexPos : POSITION;
				float2 texcoord : TEXCOORD0;				
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;				
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);				
				return o;
			}

			float4 frag(v2f i) : SV_TARGET
			{
				float4 finalColor;
				float texColor = tex2D(_MainTex, i.uv);
				finalColor = texColor * _MainColor;				
				finalColor = finalColor;
				return finalColor;
			}
			ENDCG
		}

		pass
		{
			Tags{"LightMode"="ShadowCaster"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcaster
			#include "UnityCG.cginc"

			struct v2f
			{
				V2F_SHADOW_CASTER;
				// float4 pos : SV_POSITION;
				// float3 normal : NORMAL;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				// o.normal = v.normal;
				// o.pos = mul(UNITY_MATRIX_MVP, v.vertex + float4(-2,1,-2,1));
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				return o;
			}

			float4 frag(v2f i) : SV_TARGET
			{
				SHADOW_CASTER_FRAGMENT(i)				
			}

			ENDCG
		}
	}
}