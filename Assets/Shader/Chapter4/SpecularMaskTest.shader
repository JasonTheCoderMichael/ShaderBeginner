Shader "MJ/SpecularMaskTest"
{
    Properties
    {
        _MainTint("Main Tint", Color) = (1,1,1,1)
        _MainTex("Main Texture", 2D) = "white"{}
        _SpecTex("Specular Texture", 2D) = "white"{}        
        _SpecularColor("Specular Color", Color) = (1,1,1,1)
        _SpecPower("Specular Power", float) = 1
        _RimColor("Rim Color", Color) = (1,1,1,1)        
    }

    SubShader
    {
        Tags{"RenderType" = "Opaque"}
        LOD 200

        CGPROGRAM
        #pragma surface surf FresnelReflection
        float4 _MainTint;
        sampler2D _MainTex;
        sampler2D _SpecTex;        
        float4 _SpecularColor;
        float _SpecPower;
        float4 _RimColor;

        struct Input
        {
            float2 uv_MainTex;     
            float2 uv_SpecTex;                               
        };

        float4 LightingFresnelReflection(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            float diff = dot(lightDir, s.Normal);
            float halfVector = normalize(normalize(lightDir) + normalize(viewDir));
            float NDotH = max(0, dot(s.Normal, halfVector));
            float spec = pow(NDotH, _SpecPower) * s.Specular;
            float4 c;
            c.rgb = s.Albedo * diff *_LightColor0.rgb + (_SpecularColor.rgb * _LightColor0.rgb * spec) * (atten);
            c.a = s.Alpha;

            return c;
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            float4 mainColor = tex2D(_MainTex, IN.uv_MainTex) * _MainTint;
            float4 specColor = tex2D(_SpecTex, IN.uv_SpecTex);
            
            o.Albedo = mainColor.rgb;
            o.Alpha = mainColor.a;
            o.Specular = specColor.r;        
        }

        ENDCG
    }

    Fallback "Diffuse"
}