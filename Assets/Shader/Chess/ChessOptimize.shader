shader "MJ/ChessOptimize"
{
    Subshader
    {
        pass
        {
            Tags{"Queue"="Geometry"}
            Cull Off

            CGPROGRAM            
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            // struct v2f
            // {
            //     float4 pos : POSITION;
            //     float2 uv : TEXCOORD0;
            // };

            float4 frag(v2f_img i) : COLOR
            {
                float4 col;
                bool p = fmod(i.uv.x * 10, 2) <= 1;
                bool q = fmod(i.uv.y * 10, 2) <= 1;                                

                if(p&&q || !p&&!q)   
                {
                    col = float4(1, 0, 0, 1);
                }             
                else
                {
                    col = float4(0, 0, 1, 1);                    
                }
                
                return col;
            }
            ENDCG            
        }
    }
}