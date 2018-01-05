Shader "MJ/VertFrag/DiffuseLight_Vert"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white"{}
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
            float4 _MainTex_ST;

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
                float3 vertexColor : TEXCOORD1;                        
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.position = mul(UNITY_MATRIX_MVP, v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                float4 worldPos = mul(_Object2World, v.vertex);
                float3 worldLightDir = normalize(UnityWorldSpaceLightDir(worldPos));
                float3 worldNormal = normalize(mul(v.normal, _World2Object));

                // 正常点乘方式 //
                // float3 diffuseColor = max(0, dot(worldLightDir, worldNormal)) * _LightColor0.xyz;

                // 使用 half lambert 方式 //
                float3 diff = dot(worldLightDir, worldNormal) * 0.5 + 0.5;
                float3 diffuseColor = diff * _LightColor0.xyz;
                
                o.vertexColor = diffuseColor;
                return o;
            }

            float4 frag(v2f i) : COLOR
            {
                // UNITY_LIGHTMODEL_AMBIENT 环境光 //
                // _LightColor0 方向光 //
                float4 texColor =  tex2D(_MainTex, i.uv);
                float4 finalColor = float4(texColor.xyz * i.vertexColor, 1);
                return finalColor;
            }

            ENDCG
        }
    }
}