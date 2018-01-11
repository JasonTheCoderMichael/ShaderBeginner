Shader "MJ/MainTex_ST"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "red"{}   // red, black, white, {} 可写可不写 //
    }

    SubShader
    {
        Tags{"Queue"="Geometry"}

        Pass
        {
            CGPROGRAM
            #include "UnityCG.cginc"
            #pragma vertex vert 
            #pragma fragment frag            
            
            sampler2D  _MainTex;            // sampler2D 不是 Sampler2D, s 小写 //
            float4 _MainTex_ST;             // 存储纹理的缩放和偏移信息 //

            struct a2v
            {
                float4 vertex : POSITION;
                float4 textoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.position = mul(UNITY_MATRIX_MVP, v.vertex);
                // o.uv = TRANSFORM_TEX(v.textoord, _MainTex);
                // o.uv = v.textoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.uv = v.textoord.xy * _MainTex_ST.x;                
                return o;
            }

            float4 frag(v2f i) : SV_TARGET // COLOR
            {
                float4 color = tex2D(_MainTex, i.uv);
                return color;
            }

            ENDCG
        }
    }

    Fallback "Diffuse"
}