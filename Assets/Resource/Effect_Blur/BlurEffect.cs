using UnityEngine;
using System.Collections;

public class BlurEffect : MonoBehaviour
{
    public Material blurMat;

    public void Start()
    {
        if (!SystemInfo.supportsImageEffects || blurMat == null || !blurMat.shader.isSupported)
        {
            enabled = false;
            return;
        }
    }

    void OnRenderImage(RenderTexture srcTex, RenderTexture dstTex)
    {
        if (blurMat == null)
        {
            Graphics.Blit(srcTex, dstTex);
        }
        else
        {
            Graphics.Blit(srcTex, dstTex, blurMat);
        }
    }
}
