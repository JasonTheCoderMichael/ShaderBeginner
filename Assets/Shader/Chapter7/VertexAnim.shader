Shader "MJ/VertexAnim" 
{
	Properties
	{
		_MainTex("Base (RGB)", 2D) = "white"{}
		_TintAmount("Tint Amount", Range(0, 1)) = 0.5
		_ColorA("ColorA", Color) = (1,1,1,1)
		_ColorB("ColorB", Color) = (1,1,1,1)
		_Speed("Wave Speed", Range(0.1, 80)) = 5
		_Frequency("Wave Frequency", Range(0, 5)) = 2
		_Amplitude("Wave Amplitude", Range(-1, 1)) = 1 
	}

	SubShader
	{
		Tags{"RenderType" = "Opaque"}
		LOD 200

		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		sampler2D _MainTex;
		float4 _ColorA;
		float4 _ColorB;		
		float _TintAmount;
		float _Speed;
		float _Frequency;
		float _Amplitude;
		float _OffsetVal;

		struct Input
		{
			float2 uv_MainTex;
			float3 vertColor;
		};

		void vert(inout appdata_full v, out Input o)
		{
			float time = _Time * _Speed;
			float waveValue = sin(time + v.vertex.x * _Frequency) * _Amplitude;
			v.vertex.xyz = float3(v.vertex.x, v.vertex.y + waveValue, v.vertex.z);
			v.normal = normalize(float3(v.normal.x + waveValue, v.normal.y, v.normal.z));

			UNITY_INITIALIZE_OUTPUT(Input, o);
			o.vertColor = float3(waveValue, waveValue, waveValue);
		}

		void surf(Input IN, inout SurfaceOutput o)
		{
			float4 c = tex2D(_MainTex, IN.uv_MainTex);
			float3 tintColor = lerp(_ColorA, _ColorB, IN.vertColor).rgb;
			 
			o.Albedo = c.rgb * tintColor * _TintAmount;
			o.Alpha = c.a;
		}

		ENDCG
	}
	FallBack "Diffuse"
}