Shader "MJ/VertFrag/Specular_Frag"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white"{}
        _DiffuseColor("Diffuse Color", Color) = (1,1,1,1)
        _SpecularColor("Specular Color", Color) = (1,1,1,1)
        _Gloss("Gloss", float) = 1
    }

    SubShader
    {
        Tags{"LightMode"="ForwardBase"}

        pass
        {
            CGPROGRAM
            #pragma vertex vert           // 不带分号 //
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            sampler2D _MainTex;
            float4 _DiffuseColor;
            float4 _MainTex_ST;
            float4 _SpecularColor;
            float _Gloss;

            struct a2v
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;   
                float3 normal : NORMAL;                        
            };

            struct v2f
            {
                float4 position : SV_POSITION;  
                float2 uv : TEXCOORD0;      
                float3 worldNormal : TEXCOORD1;
                float3 worldPosition : TEXCOORD2;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.position = mul(UNITY_MATRIX_MVP, v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                               
                float3 worldNormal = mul(v.normal, _World2Object);
                o.worldNormal = worldNormal;
                o.worldPosition = mul(_Object2World, v.vertex);
                return o;
            }

            float4 frag(v2f i) : COLOR
            {
                // UNITY_LIGHTMODEL_AMBIENT 环境光 //
                // _LightColor0 方向光 //
                float4 texColor =  tex2D(_MainTex, i.uv);                

                // 正常点乘方式 //
                // float3 diffuseColor = max(0, dot(worldLightDir, worldNormal)) * _LightColor0.xyz;

                // 使用 half lambert 方式 //
                float3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 worldNormal = normalize(i.worldNormal);
                float3 NdotL = dot(worldLightDir, worldNormal) * 0.5 + 0.5;
                float3 diffuseColor = (NdotL * _LightColor0.xyz) * texColor.xyz * _DiffuseColor.xyz;

                float3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPosition));
                float3 halfDir = normalize(worldLightDir + worldViewDir);
                float3 spec = pow(max(0, dot(halfDir, worldNormal)), _Gloss) * _SpecularColor;

                float3 finalColor = diffuseColor + UNITY_LIGHTMODEL_AMBIENT.xyz + spec;
                return float4(finalColor, 1);
            }

            ENDCG
        }
    }
}