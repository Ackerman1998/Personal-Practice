using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.AI;

public class xunluRole : MonoBehaviour
{
    public List<Transform> listTrans;
    public UnityEngine.AI.NavMeshPath meshData;
    NavMeshAgent navMeshAgent;
    public int randomVal = -1;
    // Start is called before the first frame update
    void Start()
    {
        
        Time.timeScale = 5f;
        navMeshAgent = GetComponent<NavMeshAgent>();
        NavMove();
    }
    public void NavMove() {
        int cc = listTrans.Count;
        randomVal = Random.Range(0,cc);
        
    }
    // Update is called once per frame
    void Update()
    {
        if (randomVal==-1) {
            return;
        }
        bool end = navMeshAgent.SetDestination(listTrans[randomVal].position);
        //Debug.Log(Vector2.Distance(new Vector2(transform.position.x, transform.position.z), new Vector2(listTrans[randomVal].position.x, listTrans[randomVal].position.z)));
        if (Vector2.Distance(new Vector2(transform.position.x, transform.position.z),new Vector2(listTrans[randomVal].position.x, listTrans[randomVal].position.z))<=0.1f) {
            randomVal = Random.Range(0, listTrans.Count);
        }
         
    }
    
    private void OnDrawGizmos()
    {
        foreach (Transform tt in listTrans) {
            Gizmos.DrawCube(tt.position,new Vector3(3,3,3));
        }
        if (randomVal == -1)
        {
            return;
        }
        Gizmos.DrawLine(transform.position, listTrans[randomVal].position);
    }
}
#if UNITY_EDITOR
[CustomEditor(typeof(xunluRole))]
public class xunluRoleEditor :Editor {
    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();
        if (GUILayout.Button("gen")) {
            xunluRole xunlu = target as xunluRole;
        }
    }
}
#endif