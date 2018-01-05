using UnityEngine;
using System.Collections;

public class Uniform : MonoBehaviour
{
    public Renderer m_render;
    private Color m_color;
    private int m_counter = 0;
    private bool m_increasing = true;
    void Start()
    {
        if (m_render != null && m_render.material != null)
        {
            // m_render.material.HasProperty("_Color") 显示为 false, 因为 _Color 没有在 Properties 块里 //
            m_render.material.SetColor("_Color", new Color(1, 1, 0, 1));
        }
    }

    void Update2()
    {
        if (m_render != null && m_render.material != null)
        {
            if (m_increasing)
            {
                m_counter++;
                if (m_counter > 255)
                {
                    m_counter = 255;
                    m_increasing = false;
                }
            }
            else
            {
                m_counter--;
                if (m_counter < 0)
                {
                    m_counter = 0;
                    m_increasing = true;
                }
            }
            
            float r = m_counter / 255.0f;
            float g = m_counter / 255.0f;
            float b = m_counter / 255.0f;

            m_color = new Color(r,g,b,1);
            m_render.material.SetColor("_Color", m_color);
        }
    }
}
