Shader "MJ/FresnelReflection"
{
    Properties
    {
        _MainTint("Main Tint", Color) = (1,1,1,1)
        _Cubemap("Cubemap", CUBE) = ""{}
        _MainTex("Main Texture", 2D) = "white"{}      
        _SpecColor("Specular Color", Color) = (1,1,1,1)
        _SpecPower("Specular Power", float) = 1
        _RimPower("Rim Power", float) = 1
        _ReflectionAmount("Reflection Amount", float) = 1      
        _Gloss("Specular Intensity", Range(0, 1)) = 1
    }

    SubShader
    {
        Tags{"RenderType" = "Opaque"}
        LOD 200

        CGPROGRAM
        #pragma surface surf BlinnPhong
        #pragma target 3.0

        samplerCUBE _Cubemap;
        float4 _MainTint;
        sampler2D _MainTex;       
        float4 _SpecularColor;
        float _SpecPower;
        float _RimPower;
        float _ReflectionAmount;
        float _Gloss;

        struct Input
        {
            float2 uv_MainTex;    
            float3 worldRefl;
            float3 viewDir;                                      
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            float4 mainColor = tex2D(_MainTex, IN.uv_MainTex) * _MainTint;
            float reflection = max(0, dot(IN.viewDir, o.Normal));
            float fresnel = 1 - reflection;
            float rim = pow(fresnel, _RimPower);

            float3 cubeColor = texCUBE(_Cubemap, IN.worldRefl).rgb * _ReflectionAmount;

            o.Albedo = mainColor.rgb;
            o.Alpha = mainColor.a;
            o.Emission = cubeColor * rim;
            o.Gloss = _Gloss;
        }

        ENDCG
    }

    Fallback "Diffuse"
}