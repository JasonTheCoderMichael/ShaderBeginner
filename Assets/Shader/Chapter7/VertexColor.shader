Shader "MJ/VertexColor"
 {
	Properties 
	{
		_MainTint("Global Color Tint", Color) = (1,1,1,1)
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
 
		float4 _MainTint;		
		#pragma surface surf Lambert vertex:vert

		struct Input
		{
			float4 vertColor;
		};
		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = IN.vertColor.rgb * _MainTint.rgb;
		}

		void vert(inout appdata_full v, out Input o)
		{
			o.vertColor = v.color;
		}
		
		ENDCG
	}
	FallBack "Diffuse"
}
