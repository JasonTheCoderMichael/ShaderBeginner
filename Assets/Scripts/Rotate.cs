using UnityEngine;
using System.Collections;

public class Rotate : MonoBehaviour
{
    public float rotate_speed;

    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        transform.Rotate(Vector3.up, Time.deltaTime * rotate_speed);
    }
}
