Shader "MJ/AlphaCutoff"
 {
	Properties 
	{
		_MainTex("Base (RGB)", 2D) = "white"{}
		_Cutoff("Transparency Value", Range(0, 1)) = 0.5
	}
	SubShader 
	{ 
		Tags{"RenderType" = "Opaque" "Queue" = "Transparent"}
 
		CGPROGRAM
		#pragma surface surf Lambert alphatest:_Cutoff

		sampler2D _MainTex;

		struct Input
		{
			float2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			float4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.r;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
