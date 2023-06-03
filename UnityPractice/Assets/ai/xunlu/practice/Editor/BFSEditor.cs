using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class BFSEditor : Editor
{
    [MenuItem("GameObject/�������")]
    public static void SetStart() {
        GameObject target = Selection.activeGameObject;
        target.GetComponent<BFSTile>().SetStart();
    }
    [MenuItem("GameObject/�����յ�")]
    public static void SetEnd()
    {
        GameObject target = Selection.activeGameObject;
        target.GetComponent<BFSTile>().SetEnd();
    }
    [MenuItem("GameObject/��ʼѰ·BFS")]
    public static void StartBFS()
    {
        GameObject.Find("MapGen").GetComponent<BFS>().StartXunlu_BFS();
    }
    [MenuItem("GameObject/��ʼѰ·Dijkstra")]
    public static void StartDijkstra()
    {
        GameObject.Find("MapGen").GetComponent<BFS>().StartXunlu_Dijkstra();
    }

    [MenuItem("GameObject/��ʼѰ·Astar")]
    public static void StartAstar()
    {
        GameObject.Find("MapGen").GetComponent<BFS>().StartXunlu_AStar();
    }

    [MenuItem("GameObject/Ѱ·ClearAll")]
    public static void ClearAll()
    {
        GameObject.Find("MapGen").GetComponent<BFS>().ClearAll();
    }
}
