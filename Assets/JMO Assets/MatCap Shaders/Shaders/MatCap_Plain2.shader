// MatCap Shader, (c) 2015-2017 Jean Moreno

Shader "MatCap/Vertex/Plain2"
{
	Properties
	{
		_Color ("Main Color", Color) = (0.5,0.5,0.5,1)
		_MatCap ("MatCap (RGB)", 2D) = "white" {}
	}
	
	Subshader
	{
		Tags { "RenderType"="Opaque" }
		
		Pass
		{
			Tags { "LightMode" = "Always" }
			
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest
				#pragma multi_compile_fog
				#include "UnityCG.cginc"
				
				struct v2f
				{
					float4 pos	: SV_POSITION;
					float2 cap	: TEXCOORD0;
					UNITY_FOG_COORDS(1)
				};
				
				// 方法定义要在第一次使用该方法的位置之前 //
				// 或者先写一个该方法的声明，然后可以在第一次使用该方法的位置之后定义方法具体内容 //
				float3 TransformToWorldSpace(float3 objectNormal);								

				v2f vert (appdata_base v)
				{
					v2f o;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);

					float3 worldNorm = float3(0,0,0);

					// 把法线变换到视空间 //																				
					// float3 worldNorm = COMPUTE_VIEW_NORMAL;

					// 把法线变换到世界空间 //										
					worldNorm = TransformToWorldSpace(v.normal);


					// 使用世界空间法线的xy分量 //
					// o.cap.xy = worldNorm.xy * 0.5 + 0.5;

					// 使用视空间法线的xy分量 //					
					// 转换到 视空间 //
					float3 viewNormal = mul((float3x3)UNITY_MATRIX_V, worldNorm);
					o.cap.xy = viewNormal.xy * 0.5 + 0.5;
					
					
					UNITY_TRANSFER_FOG(o, o.pos);

					return o;
				}
				
				uniform float4 _Color;
				uniform sampler2D _MatCap;
				
				float4 frag (v2f i) : COLOR
				{
					float4 mc = tex2D(_MatCap, i.cap);
					mc = _Color * mc * 2.0;
					UNITY_APPLY_FOG(i.fogCoord, mc);

					return mc;
				}	

				// 把模型空间的法线转换到世界空间 //				
				float3 TransformToWorldSpace(float3 objectNormal)
				{
					// 当 worldNormal 是一个 float3 类型变量时, UNITY_MATRIX_V 自动转换为 float3x3 //
					// float3x3 和 float3×3, 是字符x,不是乘号 //

					float3 worldNormal = float3(0,0,0);

					// 方式1 原代码自带的方法 //
					// worldNormal = normalize(_World2Object[0].xyz * objectNormal.x + _World2Object[1].xyz * objectNormal.y + _World2Object[2].xyz * objectNormal.z);
															
					// 方式2, 完全按照矩阵乘法的定义，每个元素乘起来 //
					// _World2Object[0] 是 _World2Object 矩阵的第1行 //
					// worldNormal = normalize(float3(
					// _World2Object[0].x * objectNormal.x + _World2Object[1].x * objectNormal.y + _World2Object[2].x * objectNormal.z,
					// _World2Object[0].y * objectNormal.x + _World2Object[1].y * objectNormal.y + _World2Object[2].y * objectNormal.z, 
					// _World2Object[0].z * objectNormal.x + _World2Object[1].z * objectNormal.y + _World2Object[2].z * objectNormal.z));					

					// 方式3, 先求出转置矩阵，然后乘以法线向量 //
					// float4x4 world2ObjectTransMatrix = transpose(_World2Object);
					// worldNormal = mul(world2ObjectTransMatrix, objectNormal);

					// 方式4, 交换在 mul 方法中的矩阵和法线向量的位置，来实现乘以一个矩阵的转置矩阵 //
					// worldNormal = mul(objectNormal, _World2Object);

					// 方式4 直接调用 UnityCG.cginc 中的方法 //					
					worldNormal = UnityObjectToWorldNormal(objectNormal);

					return worldNormal;
				}			
			ENDCG
		}
	}
	
	Fallback "VertexLit"
}
