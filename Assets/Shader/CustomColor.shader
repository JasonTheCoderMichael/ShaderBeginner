Shader "MJ/CustomColor"
{
    Properties
    {
        _Emissive("Emissive Color", color) = (1,1,1,1)
        _Ambient("Ambient Color", color) = (1,1,1,1)
        _PowValue("This is a slider", Range(0, 10)) = 2.5
    }

    SubShader
    {
        Tags{"RenderType" = "Opaque"}
        LOD 200

        CGPROGRAM

        #pragma surface surf Lambert

        float4 _Emissive;
        float4 _Ambient;        
        float _PowValue;                        

        struct Input
        {
            float2 uv;
        };

        void surf(Input InValue, inout SurfaceOutput o)
        {
            float4 color = pow((_Emissive + _Ambient), _PowValue);            
            o.Albedo = color.rgb;
            o.Alpha = color.a;
        }
        ENDCG
    }

    Fallback "Diffuse"
}