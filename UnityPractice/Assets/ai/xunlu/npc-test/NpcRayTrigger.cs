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
    Ray rayRight;
    Ray rayLeft;
    public bool isShowDetectionRange = false;
    private void Awake()
    {
        Application.targetFrameRate = 120;
    }
    private void Update()
    {
        //float xx = Mathf.Sqrt(2) / 2f;
        Vector3 rightXX = Vector3.Lerp(transform.forward, transform.right, 0.6f);
        Vector3 leftXX = Vector3.Lerp(transform.forward, -transform.right, 0.6f);
        Debug.Log("rightXX="+ rightXX);
        Debug.Log("leftXX=" + leftXX);
        Vector3 right = (transform.position + Vector3.Normalize( new Vector3(rightXX.x,0, rightXX.z) * detectionDistance));
        Vector3 left = (transform.position + Vector3.Normalize(new Vector3(leftXX.x,0, leftXX.z) * detectionDistance));
        Vector3 endCenter = (transform.position + (transform.forward) * detectionDistance);
        //Debug.DrawLine(transform.position, endCenter);

        rayRight = new Ray(transform.position, right- transform.position);
        rayLeft = new Ray(transform.position, left- transform.position);
        rayCenter = new Ray(transform.position, endCenter);
        RayCastCom(rayCenter, endCenter);
        RayCastCom(rayRight, right);
        RayCastCom(rayLeft, left);
        Debug.DrawLine(transform.position, right, Color.green);


        //Debug.DrawLine(transform.position, endCenter, Color.green);
        if (isShowDetectionRange) {
            ShowDetectionRangeMesh();
        }
        
    }
    private void RayCastCom(Ray ray,Vector3 end) {
        if (Physics.Raycast(ray, out raycastHitCenter, detectionDistance))
        {
            if (raycastHitCenter.collider.tag == "Buildings")
            {
                Debug.DrawLine(transform.position, raycastHitCenter.point, Color.red);
                return;
            }
            else
            {
                Debug.LogError("collider player");
                Debug.DrawLine(transform.position, end, Color.gray);
                return;
            }
        }
        Debug.DrawLine(transform.position,  end, Color.green);
    }
    //����һ��������Χ��mesh������Ⱦ�ɰ�͸����ɫ��
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
