Shader "MJ/Depth002"
 {
	Properties 
	{
		_MainTex("Main Texture",  2D) = "white"{}
	}
	SubShader 
	{ 
		Tags{"Queue" = "Geometry-200"}
		ZWrite Off

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;

		struct Input
		{
			float2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			float4 c = tex2D(_MainTex, IN.uv_MainTex);			
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		 
		ENDCG
	}
	FallBack "Diffuse"
}