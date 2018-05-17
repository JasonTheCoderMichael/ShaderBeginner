using UnityEngine;

public class MultiCompile : MonoBehaviour
{
    public MeshRenderer render;    

    void OnGUI()
    {
        if (GUI.Button(new Rect(0, 0, 100, 50), "RED"))
        {
            SetKeyword("RED");
        }

        if (GUI.Button(new Rect(100, 0, 100, 50), "GREEN"))
        {
            SetKeyword("GREEN");
        }

        if (GUI.Button(new Rect(200, 0, 100, 50), "BLUE"))
        {
            SetKeyword("BLUE");
        }
    }

    void SetKeyword(string keyword)
    {
        if (render == null || render.material == null)
        {
            return;
        }

        render.material.EnableKeyword(keyword);
    }
}
