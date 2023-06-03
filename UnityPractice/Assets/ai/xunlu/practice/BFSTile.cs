using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BFSTile : MonoBehaviour
{
    public BFS bFS;
    public GameObject path;
    public GameObject tile;
    public GameObject block;
    public GameObject startTile;
    public GameObject endTile;
    public bool _isBlock = false;
    // Start is called before the first frame update
    public void SetStart()
    {
        bFS.SetStart(transform);
        startTile.SetActive(true);
    }  
    public void SetStartHide()
    {
        startTile.SetActive(false);
    } 
    public void SetEndHide()
    {
        endTile.SetActive(false);
    }
    public void SetBlock() {
        _isBlock = !_isBlock;
        block.SetActive(_isBlock);
    } 
    public void Clear() {
        //_isBlock = false;
        //block.SetActive(_isBlock);
        startTile.SetActive(false);
        endTile.SetActive(false);
        tile.SetActive(false);
        path.SetActive(false);
    }
    public void SetEnd()
    {
        bFS.SetEnd(transform);
        endTile.SetActive(true);
    }
    public void RenderTile() {
        tile.SetActive(true);
    }
    public void RenderPath()
    {
        path.SetActive(true);
    }
    public bool isBlock() {
        return _isBlock;
    }
}
