Shader "MJ/BasicDiffuse"
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
        #pragma surface surf BasicDiffuse
        float4 LightingBasicDiffuse(SurfaceOutput s, float3 lightDir, float atten)
        {
            float diff = max(0, dot(lightDir, s.Normal));
            float4 color;
            color.rgb = s.Albedo *_LightColor0.rgb * diff * atten * 2;
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