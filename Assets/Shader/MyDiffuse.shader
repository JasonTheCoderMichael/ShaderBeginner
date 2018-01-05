Shader "MJ/MyDiffuse" 
{
	Properties
	{
		_MainTex("Main -", 2D) = "white"{}		
	}

	SubShader
	{
		//Tags{ "RenderType" = "Opaque" "Queue" = "Transparent"}

		CGPROGRAM        
		#pragma surface surf Lambert

        sampler2D _MainTex; 

		struct Input
		{
			float2 uv_MainTex;
		};		      
        
		void surf(Input asd, inout SurfaceOutput o)
		{
			float3 color = tex2D(_MainTex, asd.uv_MainTex).rgb;
			o.Albedo = color;			
		}

		ENDCG
	}
	FallBack "Diffuse"
}
