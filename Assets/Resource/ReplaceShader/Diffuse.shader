Shader "MJ/ReplaceShader_Diffuse"
{
    Properties
    {        
    }

    SubShader
    {
        Tags{ "RenderType"="333" "MyTag"="MJISAWEsome"}

        pass
        {
            CGPROGRAM
            #pragma vertex vert         
            #pragma fragment frag
            
            struct a2v
            {
                float4 vertex : POSITION;                
            };

            struct v2f
            {
                float4 position : SV_POSITION;                  
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.position = mul(UNITY_MATRIX_MVP, v.vertex);                
                return o;
            }

            float4 frag(v2f i) : COLOR
            {
                return float4(1,1,1,1);
            }

            ENDCG
        }
    }    
}