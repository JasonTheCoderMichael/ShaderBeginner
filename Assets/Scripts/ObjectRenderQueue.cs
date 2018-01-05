using UnityEngine;

[ExecuteInEditMode]
public class ObjectRenderQueue : MonoBehaviour
{
    public int queueValue = 2000;
    private Material m_mat = null;

    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        Renderer render = transform.GetComponent<Renderer>();
        if (render != null)
        {
            m_mat = render.material;

            if (m_mat != null)
            {
                m_mat.renderQueue = queueValue;
            }
        }
    }
}
