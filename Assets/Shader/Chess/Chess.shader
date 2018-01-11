shader "MJ/Chess"
{
    Subshader
    {
        pass
        {
            Tags{"Queue"="Geometry"}
            Cull Off

            CGPROGRAM            
            #pragma vertex vert
            #pragma fragment frag

            struct vertex
            {
                float4 vertPos : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(vertex v)
            {
                v2f o;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertPos);
                o.uv = v.uv;
                return o;
            }

            float4 frag(v2f i) : COLOR
            {
                float4 col;
                float mod_x = fmod(i.uv.x * 10, 2);
                float mod_y = fmod(i.uv.y * 10, 2);                
                if(mod_x <= 1)
                {
                    if(mod_y <= 1)
                    {
                        col = float4(0, 0, 1, 1);                        
                    }
                    else
                    {
                        col = float4(0, 1, 0, 1);
                    }                    
                }
                else
                {
                    if(mod_y <= 1)
                    {
                        col = float4(0, 1, 0, 1);                        
                    }
                    else
                    {
                        col = float4(0, 0, 1, 1);
                    }
                }
                
                return col;
            }
            ENDCG            
        }
    }
}