using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class TestRenderImage : MonoBehaviour
{
    public Shader curShader;
    [Range(0, 1)]
    public float grayScaleAmount;
    private Material curMaterial;

    Material material
    {
        get
        {
            if (curMaterial == null)
            {
                curMaterial = new Material(curShader);
                curMaterial.hideFlags = HideFlags.HideAndDontSave;
            }
            return curMaterial;
        }
    }

    public void Start()
    {
        if (!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }

        if (!curShader || !curShader.isSupported)
        {
            enabled = false;
        }
    }

    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
    {
        if (material != null)
        {
            curMaterial.SetFloat("_LuminosityAmount", grayScaleAmount);
            Graphics.Blit(sourceTexture, destTexture, curMaterial);
        }
        else
        {
            Graphics.Blit(sourceTexture, destTexture);           
        }
    }

    void Update()
    {
        grayScaleAmount = Mathf.Clamp01(grayScaleAmount);
    }

    void OnDisable()
    {
        DestroyImmediate(curMaterial);
    }
}
