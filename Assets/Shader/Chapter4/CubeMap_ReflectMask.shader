Shader "MJ/Cubemap_ReflectMask"
{
    Properties
    {
        _MainTint("Main Tint", Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white"{}
<<<<<<< HEAD
        _Cubemap("Cube Map", CUBE) = ""{}
=======
        _Cubemap("Cube Map", CUBE) = "white"{}
>>>>>>> aecb5c33f74ccc95611b97ddb285685946659ca7
        _ReflectAmount("Reflect Amount", Range(0.01, 1)) = 0.5
        _ReflectMask("Reflect Mask", 2D) = "white"{}
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
        sampler2D _ReflectMask;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_ReflectMask;            
            float3 worldRefl;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            float4 mainColor = tex2D(_MainTex, IN.uv_MainTex) * _MainTint;
            float3 cubeColor = texCUBE(_Cubemap, IN.worldRefl).rgb;
            float4 reflectMaskColor = tex2D(_ReflectMask, IN.uv_ReflectMask);
            o.Albedo = mainColor.rgb;
            o.Alpha = mainColor.a;
            o.Emission = cubeColor * reflectMaskColor.b * _ReflectAmount;
        }

        ENDCG
    }

    Fallback "Diffuse"
}