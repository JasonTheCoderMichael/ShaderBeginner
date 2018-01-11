Shader "MJ/ScrollUV"
{
	Properties
	{
		_MainTint("Main Color", Color) = (1,1,1,1)
		_MainTex("Main Texture", 2D) = ""
		_MainTex2("Main Texture", 2D) = ""		
		_ScrollXSpeed("Scroll Speed X", float) = 1
		_ScrollYSpeed("Scroll Speed Y", float) = 1		
	}

	SubShader
	{
		Tags{"RenderType" = "Opaque"}
		LOD 200

		CGPROGRAM

		float4 _MainTint;
		sampler2D _MainTex;
		sampler2D _MainTex2;		
        float _ScrollXSpeed;
        float _ScrollYSpeed;
		float scroll_x;
		float scroll_y;
		
		struct Input
		{
			float2 uv_MainTex;
			float2 uv_MainTex2;			
		};

		#pragma surface surf Lambert	

		void surf(Input IN, in out SurfaceOutput o)
		{
			scroll_x += _ScrollXSpeed * _Time.x;
			scroll_y += _ScrollYSpeed * _Time.x;					
			float3 color = tex2D(_MainTex, IN.uv_MainTex + float2(scroll_x, scroll_y)).rgb;
			float3 color2 = tex2D(_MainTex2, IN.uv_MainTex2 + float2(scroll_x, scroll_y)).rgb;			
			o.Albedo = color * color2;
			o.Alpha = 1;
		}
		ENDCG
	}

	Fallback "Diffuse"
}