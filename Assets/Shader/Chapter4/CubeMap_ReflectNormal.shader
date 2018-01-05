Shader "MJ/Cubemap_ReflectNormal"
{
    Properties
    {
        _MainTint("Main Tint", Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white"{}
        _Cubemap("Cube Map", CUBE) = ""{}
        _ReflectAmount("Reflect Amount", Range(0.01, 1)) = 0.5
        _BumpTex("Normal Texture", 2D) = "bump"{}
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
        sampler2D _BumpTex;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpTex;            
            float3 worldRefl;
            INTERNAL_DATA
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            float4 mainColor = tex2D(_MainTex, IN.uv_MainTex) * _MainTint;
            float3 normal = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex)).rgb;
            o.Normal = normal;
            float4 cubeColor = texCUBE(_Cubemap, WorldReflectionVector(IN, o.Normal));

            o.Albedo = mainColor.rgb;
            o.Alpha = mainColor.a;
            o.Emission = cubeColor.rgb * _ReflectAmount;
        }

        ENDCG
    }

    Fallback "Diffuse"
}