using UnityEngine;
using System.Collections;

public class ReplaceShader : MonoBehaviour
{
    public string replaceTag;

    private Shader m_replaceShader;
    private Camera m_cam;

    void Start()
    {
        m_cam = GetComponent<Camera>();
        if (m_cam == null)
        {
            enabled = false;
            return;
        }

        m_replaceShader = Shader.Find("MJ/ReplaceShader");
        if (m_replaceShader == null)
        {
            enabled = false;
            return;
        }

        // 假设 replaceTag = "ASD", 那么在摄像机照射到的所有物体中 // 
        // 只要其使用的shader里有 Tags{ "ASD" = "ASD_Value"}，就去 m_replaceShader 中去寻找 含有 Tags{ "ASD" = "ASD_Value"} 字段的 SubShader //
        // 如果找到则替换成 m_replaceShader 中对应的SubShader，如果没找到则不显示 //
        // 大小写都可以，比如 Tags{ "ASD" = "ASD_VALUE"} 和 Tags{ "ASD" = "asd_value"}  是一样的，都可以被找到 //
        m_cam.SetReplacementShader(m_replaceShader, replaceTag);
        //m_cam.RenderWithShader(m_replaceShader, replaceTag);
    }   

    void OnGUI()
    {
        if (GUI.Button(new Rect(0, 0, 100, 50), "开启或停止Shader替换"))
        {
            m_cam.ResetReplacementShader();
        }
    }
}
