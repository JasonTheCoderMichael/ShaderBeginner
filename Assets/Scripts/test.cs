using UnityEngine;
using System.Collections;

public class test : MonoBehaviour 
{
    void Start()
    {
       Debug.Log("LOD = " + Shader.globalMaximumLOD);
    }
}
