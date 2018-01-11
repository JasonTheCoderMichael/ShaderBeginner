using UnityEngine;

public class SpriteSheet : MonoBehaviour
{
    public int SpriteCountX;
    public int SpriteCountY;
    public float Speed;        

    private float m_percentageX;
    private float m_percentageY;
    private float m_timeElapsed;
    private MeshRenderer m_render;
    private int m_columnId;
    private int m_rowId;    

    public void Start()
    {
        m_render = gameObject.GetComponent<MeshRenderer>();
        if (m_render == null)
        {
            enabled = false;
            return;
        }

        // 不写到 Properties 块中的uniform属性， 也可以被找到ID //
        m_columnId = Shader.PropertyToID("_ColumnIndex");
        m_rowId = Shader.PropertyToID("_RowIndex");

        if (m_render.sharedMaterial != null)
        {
            Texture tex = m_render.sharedMaterial.GetTexture("_SpriteSheet");
            if (tex != null)
            {
                m_percentageX = 1.0f / SpriteCountX;
                m_percentageY = 1.0f / SpriteCountY;

                // 不写到 Properties 块中的uniform属性， 也可以被设置值 //
                m_render.material.SetFloat("_percentage_x", m_percentageX);
                m_render.material.SetFloat("_percentage_y", m_percentageY);        
            }
        }
    }

    private int index_x;
    private int index_y;    

    public void Update()
    {
        if (m_render == null)
        {
            return;
        }

        m_timeElapsed += Speed * Time.deltaTime;

        // 从左到右 //
        index_x = (int)(m_timeElapsed % SpriteCountX);       

        index_y = SpriteCountY - 1 - (int)(m_timeElapsed / SpriteCountX);      // 从上到下 //
        if (index_y < 0)
        {            
            m_timeElapsed = 0;
        }
        
        m_render.material.SetInt(m_columnId, index_x);
        m_render.material.SetInt(m_rowId, index_y);
    }
}