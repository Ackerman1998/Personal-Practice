using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NpcRayTrigger : MonoBehaviour
{
    public float detectionDistance = 10f;
    public float detectionAngle = 20f;
    public float detectionAngleMax = 60f;
    RaycastHit raycastHitCenter;
    Ray rayCenter;
    public bool isShowDetectionRange = false;
    private void Awake()
    {
        Application.targetFrameRate = 120;
    }
    private void Update()
    {
        //float xx = Mathf.Sqrt(2) / 2f;
        //Vector3 right = ((transform.position + Vector3.Normalize(Vector3.Lerp(transform.forward, transform.right, 0.6f)) * detectionDistance));
        //Vector3 left = (transform.position + Vector3.Normalize(Vector3.Lerp(transform.forward, -transform.right, 0.6f)) * detectionDistance);
        Vector3 endCenter = (transform.position + (transform.forward) * detectionDistance);
        //Debug.DrawLine(transform.position, endCenter);

        //Ray rayRight = new Ray(transform.position, right);
        //Ray rayLeft = new Ray(transform.position, left);
        rayCenter = new Ray(transform.position, endCenter);

        
        if (Physics.Raycast(rayCenter,out raycastHitCenter,100f)) {
            if (raycastHitCenter.collider.tag=="Buildings") {
                Debug.DrawLine(transform.position, raycastHitCenter.point,Color.red);
                return;
            }
            else {
                Debug.LogError("collider player");
                Debug.DrawLine(transform.position, endCenter, Color.gray);
                return;
            }
        }
        Debug.DrawLine(transform.position, endCenter, Color.green);
        if (isShowDetectionRange) {
            ShowDetectionRangeMesh();
        }
        
    }
    //绘制一个攻击范围的mesh，并渲染成半透明蓝色。
    private void ShowDetectionRangeMesh() { 
    
    }
    private void OnDrawGizmos()
    {
        //float xx = Mathf.Sqrt(2)/2f;
        //Vector3 right = ((transform.position + Vector3.Normalize(Vector3.Lerp(transform.forward, transform.right, 0.6f)) * detectionDistance)) ;
        //Vector3 left = (transform.position + Vector3.Normalize(Vector3.Lerp(transform.forward, -transform.right, 0.6f)) * detectionDistance) ;
        //Vector3 endCenter = (transform.position + Vector3.Normalize((transform.forward)) * detectionDistance) ;
        //Gizmos.DrawLine(transform.position, endCenter);
        //Gizmos.DrawLine(transform.position, left);
        //Gizmos.DrawLine(transform.position, right);
        
    }
}
