Shader "MJ/MyTransparent" 
{
	Properties
	{
		_MainTex("Main Texture", 2D) = "white"{}
		_Alpha("Alpha Value", Range(0, 1)) = 1
	}

	SubShader
	{
		CGPROGRAM        
		#pragma surface surf Lambert alpha

        sampler2D _MainTex; 
		float _Alpha;

		struct Input
		{
			float2 uv_MainTex;
		};		      
        
		void surf(Input asd, inout SurfaceOutput o)
		{
			float3 color = tex2D(_MainTex, asd.uv_MainTex).rgb;
			o.Albedo = color;
			o.Alpha = color.r * _Alpha;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
