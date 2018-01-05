Shader "MJ/Uniform"
{
	Properties
	{
		_MainTex("Main Texture", 2D) = "white"{}
	}

	SubShader
	{
		Tags{"RenderType" = "Opaque"}
		LOD 200

		CGPROGRAM
		sampler2D _MainTex;
		uniform float4 _Color;

		#pragma surface surf Lambert

		struct Input
		{
			float2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutput o)
		{
			// return float4(1,0,0,1);
			float4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = float4(1,1,1,1) * _Color;			
		}
		ENDCG
	}

	Fallback "Diffuse"
}