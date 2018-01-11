#ifndef MyInclude
#define MyInclude


float4 _MyColor;

inline float4 LightingSimpleDiff(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
{
    float4 color = float4(1, 1, 0, s.Alpha);   
     
    #ifdef LIGHTCOLOR_RED
    color = float4(1, 0, 0, s.Alpha);
    #endif

    #ifdef LIGHTCOLOR_BLUE
    color = float4(0, 0, 1, s.Alpha);
    #endif

    return color;
}

#endif