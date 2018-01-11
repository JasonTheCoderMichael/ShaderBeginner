Shader "MJ/SpriteSheet"
{
	Properties
	{
		_SpriteSheet("Sprite Sheet", 2D) = ""
		_SpriteSheetWidth("Sprite Sheet Width", float) = 1
		_SpriteCount("Sprite Count", float) = 1
		_Speed("Speed", float) = 1
	}

	SubShader
	{
		Tags{"RenderType" = "Opaque"}
		LOD 200

		CGPROGRAM
		sampler2D _SpriteSheet;
		float _SpriteSheetWidth;		
		float _SpriteCount;
		float _Speed;

		struct Input
		{
			float2 uv_SpriteSheet;
		};

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
		}
		ENDCG
	}

	Fallback "Diffuse"
}