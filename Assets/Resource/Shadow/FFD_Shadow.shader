Shader "FFD/Shadow"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode"="ForwardBase"}
        LOD 100
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            //要想有正确的衰减内置变量等，必须要有这句
            #pragma multi_compile_fwdbase

            #include "UnityCG.cginc"
            #include "autolight.cginc"
            #include "lighting.cginc"

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
                // SHADOW_COORDS(1)    //宏表示为定义一个float4的采样坐标，放到编号为1的寄存器中
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                // TRANSFER_SHADOW(o)  //根据变换求解上面结构体中的float4坐标，unity5中采用的是屏幕空间阴影贴图
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // fixed shadow = SHADOW_ATTENUATION(i); //根据贴图与纹理坐标对纹理采样得到shadow值。
                // col = col*shadow; //最终影响光照
                return float4(1,1,1,1);
            }
            ENDCG
        }
    }
    // FallBack "Specular"
}