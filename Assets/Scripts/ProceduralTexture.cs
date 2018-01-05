using UnityEngine;
using System.Collections;
using System.IO;

public class ProceduralTexture : MonoBehaviour
{
    public int widthHeight = 512;
    public Texture2D generatedTexture = null;

    private Material currentMaterial;
    private Vector2 centerPos;
    
	void Start () 
    {

        Debug.Log("============ " + Mathf.Sin(30));
        currentMaterial = transform.GetComponent<Renderer>().material;
        if(currentMaterial == null)
        {
            currentMaterial = transform.GetComponent<Renderer>().sharedMaterial;            
        }

        if (currentMaterial != null)
        {
            centerPos = new Vector2(0.5f, 0.5f);
            generatedTexture = GenerateParabola();
            currentMaterial.SetTexture("_MainTex", generatedTexture);
        }

        SaveTextureFile(generatedTexture);
	}

    Texture2D GenerateParabola()
    {
        centerPos *= widthHeight;
        Texture2D tex = new Texture2D(widthHeight, widthHeight);
        for (int i = 0; i < widthHeight; i++)
        {
            for (int j = 0; j < widthHeight; j++)
            {
                Vector2 currentPos = new Vector2(i, j);

                //// 半径是 widthHeight 一半的一个圆形 //
                //float distance = Vector2.Distance(centerPos, currentPos) / (widthHeight * 0.5f);
                //distance = Mathf.Clamp01(1 - distance);               
                //Color color = new Color(rgb, rgb, rgb, 1);

                //// 圆环 //
                //// Mathf.Sin 参数含义是 弧度，不是角度 //
                //float distance = Vector2.Distance(centerPos, currentPos) / (widthHeight * 0.5f);
                //float distance_reverse = Mathf.Clamp01(1 - distance);
                //float rgb = Mathf.Sin(distance_reverse *  ) * distance_reverse;
                //Color color = new Color(rgb, rgb, rgb, 1);

                // 像素方向点积运算 //
                Vector2 curDir = centerPos - currentPos;
                Vector2 curDir_Normalized = curDir.normalized;

                float right = Vector2.Dot(curDir_Normalized, Vector3.right);
                float left = Vector2.Dot(curDir_Normalized, Vector3.left);
                float up = Vector2.Dot(curDir_Normalized, Vector3.up);
                Color color = new Color(right, left, up);

                //// 像素方向角度运算 //
                //Vector2 curDir = centerPos - currentPos;
                //Vector2 curDir_Normalized = curDir.normalized;

                //float right = Vector2.Angle(curDir_Normalized, Vector3.right) / 360;
                //float left = Vector2.Angle(curDir_Normalized, Vector3.left) / 360;
                //float up = Vector2.Angle(curDir_Normalized, Vector3.up) / 360;

                //Color color = new Color(right, left, up);

                tex.SetPixel(i, j, color);
            }
        }
        tex.Apply();
        return tex;
    }

    void SaveTextureFile(Texture2D tex)
    {
        string FilePath = Application.dataPath + "/Texture/GeneratedTex/Tex.png";

        byte[] byteArr = tex.EncodeToPNG();
        File.WriteAllBytes(FilePath, byteArr);        
    }

	void Update () 
    {

	}
}
