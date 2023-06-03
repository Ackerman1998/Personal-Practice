using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class BFSEditor : Editor
{
    [MenuItem("GameObject/设置起点")]
    public static void SetStart() {
        GameObject target = Selection.activeGameObject;
        target.GetComponent<BFSTile>().SetStart();
    }
    [MenuItem("GameObject/设置终点")]
    public static void SetEnd()
    {
        GameObject target = Selection.activeGameObject;
        target.GetComponent<BFSTile>().SetEnd();
    }
    [MenuItem("GameObject/开始寻路BFS")]
    public static void StartBFS()
    {
        GameObject.Find("MapGen").GetComponent<BFS>().StartXunlu_BFS();
    }
    [MenuItem("GameObject/开始寻路Dijkstra")]
    public static void StartDijkstra()
    {
        GameObject.Find("MapGen").GetComponent<BFS>().StartXunlu_Dijkstra();
    }

    [MenuItem("GameObject/开始寻路Astar")]
    public static void StartAstar()
    {
        GameObject.Find("MapGen").GetComponent<BFS>().StartXunlu_AStar();
    }

    [MenuItem("GameObject/寻路ClearAll")]
    public static void ClearAll()
    {
        GameObject.Find("MapGen").GetComponent<BFS>().ClearAll();
    }
}
