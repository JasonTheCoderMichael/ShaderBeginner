Shader "SS/Effect/SpriteSheet"
{
	Properties
	{
		_MainTint("Main Tint(RGB)", Color) = (1,1,1,1)
		_SpriteSheet("Sprite Sheet", 2D) = ""				
	}

	SubShader
	{
		Tags{"Queue"="Transparent" "IgnoreProjector"="True" "RenderType" = "Transparent"}
		LOD 200

		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

		CGPROGRAM
		fixed4 _MainTint;
		sampler2D _SpriteSheet;		
		uniform float _percentage_x;
		uniform float _percentage_y;
		uniform fixed _ColumnIndex;                // 列索引 //
		uniform fixed _RowIndex;		           // 行索引 //

		struct Input
		{
			float2 uv_SpriteSheet;
		};

		#pragma surface surf Lambert alpha:fade

		void surf(Input IN, in out SurfaceOutput o)
		{
			float2 spriteUV = IN.uv_SpriteSheet;			
			spriteUV.x *= _percentage_x;
			spriteUV.x += _ColumnIndex * _percentage_x;

			spriteUV.y *= _percentage_y;
			spriteUV.y += _RowIndex * _percentage_y;				

			float4 color = tex2D(_SpriteSheet, spriteUV);
			o.Albedo = color.rgb * _MainTint.rgb;
			o.Alpha = color.a;
		}
		ENDCG
	}

	Fallback "Diffuse"
}