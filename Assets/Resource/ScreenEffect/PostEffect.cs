using UnityEngine;
using System.Collections;

public class PostEffect : MonoBehaviour
{
    public Texture2D blendTex;
    public Material material;    
    public float opacity;

    void Start()
    {
        if (blendTex == null)
        {
            enabled = false;
            return;
        }

        if (material != null)
        {
            material.SetTexture("_BlendTex", blendTex);
        }
    }

    void OnRenderImage(RenderTexture srcTex, RenderTexture dstTex)
    {
        if (material == null)
        {
            Graphics.Blit(srcTex, dstTex);
        }
        else
        {
            opacity = Mathf.Clamp01(opacity);
            material.SetFloat("_Opacity", opacity);
            Graphics.Blit(srcTex, dstTex, material);   
        }        
    }
}
