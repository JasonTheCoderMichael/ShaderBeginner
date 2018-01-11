shader "MJ/Animate Vertex"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white"{}
        _Speed("Speed", Range(0, 10)) = 1
        _Frequency("Frequency", float) = 1
        _Amplitude("Amplitude", float) = 1
    }

    Subshader
    {
        pass
        {
            Tags{"Queue"="Geometry"}
            ZWrite On
            ZTest LEqual
            Cull Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float _Speed;
            float _Frequency;
            float _Amplitude;
            float4 _MainTex_ST;

            struct a2v
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
                float3 color : COLOR;
            };            

            struct v2f
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
                float3 color : COLOR;                
            };

            v2f vert(a2v i)
            {
                v2f o;                
                float offset = sin(_Time.y * _Speed + i.pos.x * _Frequency) * _Amplitude;                               
                i.pos.y += offset;

                o.pos = mul(UNITY_MATRIX_MVP, i.pos);
                o.uv = TRANSFORM_TEX(i.uv, _MainTex);
                o.color = float3(i.pos.x, i.pos.y, i.pos.z);
                return o;
            }

            float4 frag(v2f v) : COLOR
            {
                float4 col;
                // col = tex2D(_MainTex, v.uv);
                col = float4(v.color, 1);
                return col;
            }

            ENDCG
        }
    } 
}