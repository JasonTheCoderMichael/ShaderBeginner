Shader "MJ/HalfLambert"
{
    Properties
    {
        _MainColor("Main color", Color) = (1,1,1,1)
    }

    Subshader
    {
        Tags{"RenderType" = "Opaque"}
        LOD 200

        CGPROGRAM
        #pragma surface surf HalfLambert
        float4 LightingHalfLambert(SurfaceOutput s, float3 lightDir, float atten)
        {
            float diff = dot(lightDir, s.Normal);
            float halfLambert = diff * 0.5 + 0.5;
            float4 color;
            color.rgb = s.Albedo *_LightColor0.rgb * halfLambert * atten * 2;
            color.a = 1;
            return color;
        }

        struct Input
        {
            float2 uv;
        };
        float4 _MainColor;        

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _MainColor;
        }
        ENDCG
    }
}