using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class BFS : MonoBehaviour
{
    private Vector2Int[] offsets;
    public GameObject prefabTile;
    public List<List<Transform>> map;
    public Vector2Int start;
    public Vector2Int end;
    public Dictionary<string, BFSTile> bfsTile = new Dictionary<string, BFSTile>();
    BFSTile startTile=null;
    BFSTile endTile = null;
    private int _type = 1;
    private void Awake()
    {
        InitMap();
        offsets = new Vector2Int[] { new Vector2Int(1, 0), new Vector2Int(0, -1), new Vector2Int(-1, 0), new Vector2Int(0, 1) };
    }
    /// <summary>
    /// 初始化地图
    /// </summary>
    private void InitMap() {
        map = new List<List<Transform>>();
        for (int x = 1;x<=100;x++) {
            List<Transform> MapLine = new List<Transform>();
            for (int y = 1; y <= 100; y++)
            {
                GameObject tile = Instantiate(prefabTile, transform);
                tile.transform.position = new Vector3(x - 0.5f, 0,y-0.5f);
                tile.gameObject.SetActive(true);
                MapLine.Add(tile.transform);
                bfsTile.Add((x).ToString()+"_"+ (y).ToString(), tile.GetComponent<BFSTile>());
            }
            map.Add(MapLine);
        }
    }
  
    public void StartXunlu_BFS() {
        if (start==new Vector2Int(-1,-1)|| end == new Vector2Int(-1, -1)) {
            Debug.Log("没设置起点/终点");
            return;
        }
        StartCoroutine(Cor_BFS());
    }
    public void StartXunlu_Dijkstra() {
        StartCoroutine(Cor_Dijkstra());
    }
    public void StartXunlu_AStar() {
        StartCoroutine(Cor_Astar());
    }
    #region Coroutine
    public IEnumerator Cor_BFS() {
        yield return new WaitForSeconds(0.1f);
        Queue<Vector2Int> queue = new Queue<Vector2Int>();
        Dictionary<Vector2Int, Vector2Int> recordDict = new Dictionary<Vector2Int, Vector2Int>();
        queue.Enqueue(start);
        recordDict.Add(start,new Vector2Int(-1,-1));
        bool hasRoute = false;
        while (queue.Count>0) {
            Vector2Int currentNode = queue.Dequeue();
            yield return new WaitForSeconds(0.1f);
            bfsTile[(currentNode.x).ToString() + "_" + (currentNode.y).ToString()].RenderTile();
            if (currentNode == end)
            {
                hasRoute = true;
                break;
            }
            Debug.Log((currentNode.x).ToString() + "_" + (currentNode.y ).ToString());
            foreach (Vector2Int offset in offsets) {
                Vector2Int newPos = currentNode + offset;
                // 超出边界
                if (newPos.x <= 0 || newPos.y <= 0 || newPos.x >= map.Count || newPos.y >= map[0].Count)
                {
                    continue;
                }
                // 已经在队列中
                if (recordDict.ContainsKey(newPos))
                {
                    continue;
                }
                // 障碍物
                if (bfsTile[(newPos.x).ToString() + "_" + (newPos.y ).ToString()].isBlock())
                {
                    continue;
                }
                queue.Enqueue(newPos);
                recordDict[newPos] = currentNode;
            }
        }
        if (hasRoute)
        {
            Stack<Vector2Int> trace = new Stack<Vector2Int>();
            Vector2Int pos = end;
            while (recordDict.ContainsKey(pos)) {
                trace.Push(pos);
                pos = recordDict[pos];
            }
            while (trace.Count>0)
            {
                Vector2Int p = trace.Pop();
                yield return new WaitForSeconds(0.1f);
                bfsTile[(p.x).ToString() + "_" + (p.y).ToString()].RenderPath();
            }
        }
    }
    public int manhattan(Vector2Int a, Vector2Int b)
    {
        return Mathf.Abs(a.x - b.x) + Mathf.Abs(a.y - b.y);
    }
    public IEnumerator Cor_Dijkstra()
    {
        yield return new WaitForSeconds(0.02f);
        List<Vector2Int> sortList = new List<Vector2Int>();
        Dictionary<Vector2Int, Vector2Int> recordDict = new Dictionary<Vector2Int, Vector2Int>();
        recordDict.Add(start, new Vector2Int(-1, -1));
        sortList.Add(start);
        bool hasRoute = false;
        while (sortList.Count > 0)
        {
            sortList.Sort((Vector2Int a, Vector2Int b) =>
            {
                return manhattan(start, a) - manhattan(start, b);
            });
            Vector2Int currentNode = sortList[0];
            sortList.RemoveAt(0);
            yield return new WaitForSeconds(0.02f);
            bfsTile[(currentNode.x).ToString() + "_" + (currentNode.y).ToString()].RenderTile();
            if (currentNode == end)
            {
                hasRoute = true;
                break;
            }
            Debug.Log((currentNode.x).ToString() + "_" + (currentNode.y).ToString());
            foreach (Vector2Int offset in offsets)
            {
                Vector2Int newPos = currentNode + offset;
                // 超出边界
                if (newPos.x <= 0 || newPos.y <= 0 || newPos.x >= map.Count || newPos.y >= map[0].Count)
                {
                    continue;
                }
                // 已经在队列中
                if (recordDict.ContainsKey(newPos))
                {
                    continue;
                }
                // 障碍物
                if (bfsTile[(newPos.x).ToString() + "_" + (newPos.y).ToString()].isBlock())
                {
                    continue;
                }
                sortList.Add(newPos);
                recordDict[newPos] = currentNode;
            }
        }
        if (hasRoute)
        {
            Stack<Vector2Int> trace = new Stack<Vector2Int>();
            Vector2Int pos = end;
            while (recordDict.ContainsKey(pos))
            {
                trace.Push(pos);
                pos = recordDict[pos];
            }
            while (trace.Count > 0)
            {
                Vector2Int p = trace.Pop();
                yield return new WaitForSeconds(0.1f);
                bfsTile[(p.x).ToString() + "_" + (p.y).ToString()].RenderPath();
            }
        }
    }

    public IEnumerator Cor_Astar()
    {
        yield return new WaitForSeconds(0.02f);
        List<Vector2Int> sortList = new List<Vector2Int>();
        Dictionary<Vector2Int, Vector2Int> recordDict = new Dictionary<Vector2Int, Vector2Int>();
        recordDict.Add(start, new Vector2Int(-1, -1));
        sortList.Add(start);
        bool hasRoute = false;
        while (sortList.Count > 0)
        {
            sortList.Sort((Vector2Int a, Vector2Int b) =>
            {
                //1.比较(目标节点到起点的曼哈顿距离+目标节点到终点的曼哈顿距离)
                //return (manhattan(start, a)+ manhattan(end, a)) - (manhattan(start, b) + manhattan(end, b));
                //2.优化后的A*，当两点的到起点的曼哈顿距离不等时，直接取离终点最近的的；当相等时
                //if (manhattan(start, a)!= manhattan(start, b))
                //{
                    return ( manhattan(end, a)) - (manhattan(end, b));
                //}
                //else {
                //    return manhattan(start, a)  - manhattan(start, b);
                //}
            });
            Vector2Int currentNode = sortList[0];
            sortList.RemoveAt(0);
            yield return new WaitForSeconds(0.02f);
            bfsTile[(currentNode.x).ToString() + "_" + (currentNode.y).ToString()].RenderTile();
            if (currentNode == end)
            {
                hasRoute = true;
                break;
            }
            Debug.Log((currentNode.x).ToString() + "_" + (currentNode.y).ToString());
            foreach (Vector2Int offset in offsets)
            {
                Vector2Int newPos = currentNode + offset;
                // 超出边界
                if (newPos.x <= 0 || newPos.y <= 0 || newPos.x >= map.Count || newPos.y >= map[0].Count)
                {
                    continue;
                }
                // 已经在队列中
                if (recordDict.ContainsKey(newPos))
                {
                    continue;
                }
                // 障碍物
                if (bfsTile[(newPos.x).ToString() + "_" + (newPos.y).ToString()].isBlock())
                {
                    continue;
                }
                sortList.Add(newPos);
                recordDict[newPos] = currentNode;
            }
        }
        if (hasRoute)
        {
            Stack<Vector2Int> trace = new Stack<Vector2Int>();
            Vector2Int pos = end;
            while (recordDict.ContainsKey(pos))
            {
                trace.Push(pos);
                pos = recordDict[pos];
            }
            while (trace.Count > 0)
            {
                Vector2Int p = trace.Pop();
                yield return new WaitForSeconds(0.1f);
                bfsTile[(p.x).ToString() + "_" + (p.y).ToString()].RenderPath();
            }
        }
    }
    #endregion
    public void SetStart(Transform tt) {
        start = new Vector2Int((int)(tt.position.x + 0.5f), (int)(tt.position.z + 0.5f));
    } 
    public void SetEnd(Transform tt) {
        end = new Vector2Int((int)(tt.position.x + 0.5f), (int)(tt.position.z + 0.5f));
    }
    private void Update()
    {
        if (Input.GetMouseButtonDown(1)) {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit raycastHit;
            if (Physics.Raycast(ray,out raycastHit)) {
                if (_type==1) {
                    if (raycastHit.collider.name.Contains("Tile"))
                    {
                        raycastHit.collider.gameObject.GetComponent<BFSTile>().SetBlock();
                        
                    }
                }
                else if (_type == 2)
                {
                    if (raycastHit.collider.name.Contains("Tile"))
                    {
                        startTile?.SetStartHide();
                        raycastHit.collider.gameObject.GetComponent<BFSTile>().SetStart();
                        startTile = raycastHit.collider.gameObject.GetComponent<BFSTile>();
                    }
                }
                else if (_type == 3)
                {
                    if (raycastHit.collider.name.Contains("Tile"))
                    {
                        endTile?.SetStartHide();
                        raycastHit.collider.gameObject.GetComponent<BFSTile>().SetEnd();
                        endTile = raycastHit.collider.gameObject.GetComponent<BFSTile>();
                    }
                }
            }
        }
        if (Input.GetAxis("Horizontal")!=0) {
            Vector3 vector3 = Camera.main.transform.localPosition;
            Camera.main.transform.localPosition = new Vector3(vector3.x+Time.deltaTime* Input.GetAxis("Horizontal")*4, vector3.y, vector3.z);
        }
        if (Input.GetAxis("Vertical") != 0)
        {
            Vector3 vector3 = Camera.main.transform.localPosition;
            Camera.main.transform.localPosition = new Vector3(vector3.x , vector3.y, vector3.z + Time.deltaTime * Input.GetAxis("Vertical") * 4);
        }
    }
    public void ClearAll() {
        foreach (string key in bfsTile.Keys) {
            bfsTile[key].Clear();
        }
        start = new Vector2Int(-1,-1);
        end = new Vector2Int(-1,-1);
    }
    public void ClearPathAndRender() { 
    
    }

    public void SetClickType(int type) {
        _type = type;
    }
}
#if UNITY_EDITOR
[CustomEditor(typeof(BFS))]
public class BFSEditor : Editor{
    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();
        BFS bFS = target as BFS;
        if (GUILayout.Button("开始寻路 bfs")) {
            bFS.StartXunlu_BFS();
        } 
        if (GUILayout.Button("开始寻路 迪杰斯特拉")) {
            bFS.StartXunlu_Dijkstra();
        } 
        if (GUILayout.Button("开始寻路 A*")) {
            bFS.StartXunlu_AStar();
        }
    }
}
#endif