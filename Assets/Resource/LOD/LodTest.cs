using UnityEngine;
using System.Collections;

public class LodTest : MonoBehaviour
{
    public Renderer render;

    void Start()
    {
        if (render == null)
        {
            enabled = false;
            return;
        }
    }

    void OnGUI()
    {
        if (GUI.Button(new Rect(0, 0, 100, 50), "LOD 100"))
        {
            render.material.shader.maximumLOD = 100;
        }

        if (GUI.Button(new Rect(100, 0, 100, 50), "LOD 200"))
        {
            render.material.shader.maximumLOD = 200;
        }

        if (GUI.Button(new Rect(200, 0, 100, 50), "LOD 300"))
        {
            render.material.shader.maximumLOD = 300;
        }

        if (GUI.Button(new Rect(0, 100, 100, 50), "Global LOD 100"))
        {
            Shader.globalMaximumLOD = 100;
        }

        if (GUI.Button(new Rect(100, 100, 100, 50), "Global LOD 200"))
        {
            Shader.globalMaximumLOD = 200;
        }

        if (GUI.Button(new Rect(200, 100, 100, 50), "Global LOD 300"))
        {
            Shader.globalMaximumLOD = 300;
        }

        GUI.Label(new Rect(0, 200, 500, 200), "当前LOD : " + render.material.shader.maximumLOD +
                                            " , 当前 Global LOD值 : " + Shader.globalMaximumLOD);
    }
}
