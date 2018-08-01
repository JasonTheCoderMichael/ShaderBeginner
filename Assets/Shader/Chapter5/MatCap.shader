Shader "MJ/MatCap" 
{
	Properties 
	{
		_MainTex("Main Texture", 2D) = "white"{}
		_MainTint("Main Tint", Color) = (1,1,1,1)
		_NormalMap("Normal Map", 2D) = "bump"{}
	}

	SubShader
	{
		Tags{"RenderType" = "Opaque"}
		LOD 200

		CGPROGRAM
		#pragma surface surf Unlit vertex:vert
		#pragma target 3.0
		
		sampler2D _MainTex;
		sampler2D _NormalMap;
		float4 _MainTint;
		
		struct Input
		{
			fixed2 uv_MainTex;
			fixed2 uv_NormalMap;
			float3 tan1;
			float3 tan2;						
		};
		
		struct V2F
		{
			float2 ss;
		};

		void vert(inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input, o);
			TANGENT_SPACE_ROTATION;

			o.tan1 = mul(rotation, UNITY_MATRIX_IT_MV[0]);
			o.tan2 = mul(rotation, UNITY_MATRIX_IT_MV[1]);			
		}

		fixed4 LightingUnlit(SurfaceOutput s, fixed3 lightDir, fixed3 viewDir, half atten)
		{
			fixed4 c = fixed4(1,1,1,1);
			c.rgb = s.Albedo * c.rgb;
			c.a = s.Alpha;
			return c;
		}

		void surf(Input IN, inout SurfaceOutput o)
		{
			float3 normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap)).rgb;
			o.Normal = normal;
			
			float2 lightSphereUV;
			lightSphereUV.x = dot(IN.tan1, o.Normal);
			lightSphereUV.y = dot(IN.tan2, o.Normal);

			float4 color = tex2D(_MainTex, lightSphereUV * 0.5 + 0.5);
			float3 mainColor = color * _MainTint.rgb;
			o.Albedo = mainColor;
			o.Alpha = color.a;
		}
		ENDCG
	}

	Fallback "Diffuse"
}
