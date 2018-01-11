using UnityEngine;

public class OldFilmEffect : MonoBehaviour
{
    public Shader oldFilmShader;

    public float OldFilmEffectAmount = 1;

    public Color sepiaColor = Color.white;
    public float vignetteAmount = 1;
    public Texture2D vignetteTexture;

    public Texture2D scratchTexture;
    public float scratchesYSpeed;
    public float scratchesXSpeed;

    public Texture2D dustTexture;
    public float dustYSpeed;
    public float dustXSpeed;

    private Material curMaterial;
    private float randomValue;

    void Start()
    {
        if (!SystemInfo.supportsImageEffects || !SystemInfo.supportsRenderTextures)
        {
            enabled = false;
            return;
        }

        if (!oldFilmShader || !oldFilmShader.isSupported)
        {
            enabled = false;
            return;
        }        
    }

    Material material
    {
        get
        {
            if (curMaterial == null)
            {
                curMaterial = new Material(oldFilmShader);
                curMaterial.hideFlags = HideFlags.HideAndDontSave;
            }
            return curMaterial;
        }
    }

    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
    {
        if (oldFilmShader != null)
        {
            material.SetColor("_SepiaColor", sepiaColor);
            material.SetFloat("_VignetteAmount", vignetteAmount);
            material.SetFloat("_EffectAmount", OldFilmEffectAmount);

            if (vignetteTexture)
            {
                material.SetTexture("_VignetteTex", vignetteTexture);
            }

            if (scratchTexture)
            {
                material.SetTexture("_ScratchesTex", scratchTexture);
                material.SetFloat("_ScratchedYSpeed", scratchesYSpeed);
                material.SetFloat("_ScratchedXSpeed", scratchesXSpeed);
            }

            if (dustTexture)
            {
                material.SetTexture("_DustTex", dustTexture);
                material.SetFloat("_dustYSpeed", dustYSpeed);
                material.SetFloat("_dustXSpeed", dustXSpeed);
                material.SetFloat("_RandomValue", randomValue);
            }

            Graphics.Blit(sourceTexture, destTexture, curMaterial);
        }
        else
        {
            Graphics.Blit(sourceTexture, destTexture);            
        }
    }

    void Update()
    {
        vignetteAmount = Mathf.Clamp01(vignetteAmount);
        OldFilmEffectAmount = Mathf.Clamp(OldFilmEffectAmount, 0, 1.5f);
        randomValue = Random.Range(-1, 1);
    }
}
