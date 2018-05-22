Shader "MJ/LOD"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
	}

	CGINCLUDE

	float4 _Color;

	struct a2v
	{
		float4 vertex : POSITION;
	};

	struct v2f
	{
		float4 pos : SV_POSITION;
	};

	v2f vert(a2v v)
	{
		v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		return o;
	}

	float4 frag_red(v2f i) : SV_TARGET
	{
		_Color = float4(1,0,0,1);
		return _Color;
	}

	float4 frag_green(v2f i) : SV_TARGET
	{
		_Color = float4(0,1,0,1);
		return _Color;
	}

	float4 frag_blue(v2f i) : SV_TARGET
	{
		_Color = float4(0,0,1,1);
		return _Color;
	}
	ENDCG

	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 300
		
		pass
		{
			CGPROGRAM	
			#pragma vertex vert
			#pragma fragment frag_red
			ENDCG
		}
	}

	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		pass
		{
			CGPROGRAM	
			#pragma vertex vert
			#pragma fragment frag_green
			ENDCG
		}
	}	


	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		
		pass
		{			
			CGPROGRAM	
			#pragma vertex vert
			#pragma fragment frag_blue
			ENDCG
		}
	}	
}
