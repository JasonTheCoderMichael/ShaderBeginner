using UnityEngine;

public class ScreenPostEffect : MonoBehaviour
{
    public Material effectMaterial;

    void Awake()
    {
        if (effectMaterial == null || effectMaterial.shader == null || 
            !effectMaterial.shader.isSupported || !SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }
    }

    void OnRenderImage(RenderTexture srcTex, RenderTexture dstTex)
    {        
        Graphics.Blit(srcTex, dstTex, effectMaterial);
    }
}
