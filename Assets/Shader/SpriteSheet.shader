<<<<<<< HEAD
﻿Shader "MJ/SpriteSheet"
{
	Properties
	{
		_SpriteSheet("Sprite Sheet", 2D) = ""
		_SpriteSheetWidth("Sprite Sheet Width", float) = 1
		_SpriteCount("Sprite Count", float) = 1
		_Speed("Speed", float) = 1
=======
﻿Shader "SS/Effect/SpriteSheet"
{
	Properties
	{
		_MainTint("Main Tint(RGB)", Color) = (1,1,1,1)
		_SpriteSheet("Sprite Sheet", 2D) = ""				
>>>>>>> aecb5c33f74ccc95611b97ddb285685946659ca7
	}

	SubShader
	{
<<<<<<< HEAD
		Tags{"RenderType" = "Opaque"}
		LOD 200

		CGPROGRAM
		sampler2D _SpriteSheet;
		float _SpriteSheetWidth;		
		float _SpriteCount;
		float _Speed;
=======
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
>>>>>>> aecb5c33f74ccc95611b97ddb285685946659ca7

		struct Input
		{
			float2 uv_SpriteSheet;
		};

<<<<<<< HEAD
		#pragma surface surf Lambert	

		void surf(Input IN, in out SurfaceOutput o)
		{
			// 每个sprite的宽度 //
			float spriteWidth = _SpriteSheetWidth / _SpriteCount;

			// 每个 sprite 占 spritesheet 的比例 //
			float percentage = spriteWidth / _SpriteSheetWidth;

			float timeVal = fmod(_Speed * _Time.w, _SpriteCount);
			timeVal = ceil(timeVal);

			float2 spriteUV = IN.uv_SpriteSheet;			
			spriteUV.x += timeVal;
			spriteUV.x *= percentage;
						
			float3 color = tex2D(_SpriteSheet, spriteUV).rgb;
			o.Albedo = color;
			o.Alpha = 1;
=======
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
>>>>>>> aecb5c33f74ccc95611b97ddb285685946659ca7
		}
		ENDCG
	}

	Fallback "Diffuse"
}