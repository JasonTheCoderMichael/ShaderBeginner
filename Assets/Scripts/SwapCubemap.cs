using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class SwapCubemap : MonoBehaviour
{
    public Cubemap cubeA;
    public Cubemap cubeB;

    public Transform posA;
    public Transform posB;

    public Material curMat;
    private Renderer render = null;

    void Start()
    {
        render = transform.GetComponent<Renderer>();
        curMat = render.sharedMaterial;
    }

    public void OnDrawGizmos()
    {
        Gizmos.color = Color.green;

        if (posA)
        {
            Gizmos.DrawWireSphere(posA.position, 0.5f);
        }
        if (posB)
        {
            Gizmos.DrawWireSphere(posB.position, 0.5f);
        }
    }

    public Cubemap CheckProbeDistance()
    {
        float distA = Vector3.Distance(transform.position, posA.position);
        float distB = Vector3.Distance(transform.position, posB.position);

        if (distA < distB)
        {
            return cubeA;
        }
        else if (distA > distB)
        {
            return cubeB;
        }
        else
        {
            return cubeA;
        }
    }

    void Update()
    {
        if (render == null || curMat == null)
        {
            return;
        }

        Cubemap map = CheckProbeDistance();
        curMat.SetTexture("_Cubemap", map);
    }
}
