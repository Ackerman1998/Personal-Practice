using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NpcRayTrigger : MonoBehaviour
{
    public float detectionDistance = 10f;
    public float detectionAngle = 20f;
    private void Update()
    {
        
    }
    private void OnDrawGizmos()
    {
        float xx = Mathf.Sqrt(2)/2f;
        Vector3 endCenter = transform.position + transform.forward * detectionDistance;
        Vector3 endLeft = transform.position + new Vector3(-xx, 0, xx) * detectionDistance;
        Vector3 endRight = transform.position + new Vector3(xx, 0, xx) * detectionDistance;
        Gizmos.DrawLine(transform.position, endCenter);
        Gizmos.DrawLine(transform.position, endLeft);
        Gizmos.DrawLine(transform.position, endRight);
    }
}
