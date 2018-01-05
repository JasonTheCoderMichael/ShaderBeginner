Shader "MJ/GUI"
 {
	Properties 
	{
		_GUITint("GUI Tint", Color) = (1,1,1,1)
		_GUITex("Base (RGB)", 2D) = "white"{}
		_FadeValue("Fade Value", Range(0, 1)) = 1
	}

	SubShader 
	{ 
		Tags{ "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		ZWrite Off
		Cull Back
		LOD 200

		CGPROGRAM
		#pragma surface surf UnlitGUI alpha novertexlights

		sampler2D _GUITex;
		float4 _GUITint;
		float _FadeValue;

		struct Input
		{
			float2 uv_GUITex;
		};

		inline fixed4 LightingUnlitGUI(SurfaceOutput s, fixed3 lightDir, fixed3 viewDir, fixed atten)
		{
			fixed4 c;
			c.rgb = s.Albedo;
			c.a = s.Alpha;
			return c;
		}

		void surf(Input IN, inout SurfaceOutput o)
		{
			half4 texColor = tex2D(_GUITex, IN.uv_GUITex);
			o.Albedo = texColor.rgb * _GUITint.rgb;
			o.Alpha = texColor.a * _FadeValue;
		}
		ENDCG
	}
	FallBack "Diffuse"
}