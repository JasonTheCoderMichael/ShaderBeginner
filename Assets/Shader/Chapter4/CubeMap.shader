Shader "MJ/Cubemap"
{
    Properties
    {
        _MainTint("Main Tint", Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white"{}
        _Cubemap("Cube Map", CUBE) = ""{}
        _ReflectAmount("Reflect Amount", Range(0.01, 1)) = 0.5
    }

    SubShader
    {
        Tags{"RenderType" = "Opaque"}
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert
        float4 _MainTint;
        sampler2D _MainTex;
        samplerCUBE _Cubemap;
        float _ReflectAmount;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldRefl;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            float4 mainColor = tex2D(_MainTex, IN.uv_MainTex) * _MainTint;
            float3 cubeColor = texCUBE(_Cubemap, IN.worldRefl).rgb * _ReflectAmount;

            o.Albedo = mainColor.rgb;
            o.Alpha = mainColor.a;
            o.Emission = cubeColor;
        }

        ENDCG
    }

    Fallback "Diffuse"
}