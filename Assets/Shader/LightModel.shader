Shader "MJ/LightModel" 
{
	Properties
	{
		_Emissive("Emissive Color", color) = (1,1,1,1)
        _Ambient("Ambient Color", color) = (1,1,1,1)
        _PowValue("This is a slider", Range(0, 10)) = 2.5
	}

	SubShader
	{
		Tags{"RenderType" = "Opaque"}
		LOD 200

		CGPROGRAM
		float4 _Emissive;
		float4 _Ambient;		
		float _PowValue;		
				
		struct Input
		{	
			float2 uv;
		};

		#pragma surface surf BasicDiffuse

		float4 LightingBasicDiffuse(SurfaceOutput s, float3 lightDir, float atten)
		{
			float diff = max(0, dot(s.Normal, lightDir));
			float4 col;
			col.rgb = s.Albedo * diff * atten;
			col.a = s.Alpha;
			return col;
		}

		void surf(Input IN, inout SurfaceOutput o)
		{			
			float4 color = pow(_Ambient + _Emissive, _PowValue);
			o.Albedo = color.rgb;			
			o.Alpha = color.a;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
