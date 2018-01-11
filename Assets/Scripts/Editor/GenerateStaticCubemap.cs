using UnityEngine;
using System.Collections;
using UnityEditor;

public class GenerateStaticCubemap : ScriptableWizard
{
    public Transform renderPosition;
    public Cubemap cubemap;
    
    public void OnWizardUpdate()
    {
        helpString = "Select Tranasform to render from and cubemap to render into";
        if (renderPosition != null && cubemap != null)
        {
            isValid = true;
        }
        else
        {
            isValid = false;
        }
    }

    public void OnWizardCreate()
    {
        GameObject go = new GameObject("CubeCam", typeof(Camera));
        go.transform.position = renderPosition.position;
        go.transform.rotation = Quaternion.identity;
        Camera camera = go.GetComponent<Camera>();
        camera.RenderToCubemap(cubemap);
        DestroyImmediate(go);
    }

    [MenuItem("CookBook/Render/Render Cubemap")]
    static void RenderCubemap()
    {
        //ScriptableWizard.DisplayWizard("Render Cubemap", typeof (GenerateStaticCubemap), "Render!");

        ScriptableWizard.DisplayWizard<GenerateStaticCubemap>("Render Cubemap", "Render!");
    }
}
