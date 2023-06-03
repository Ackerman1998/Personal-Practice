using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.SceneManagement;

public class ExportNavMesh
{

    [MenuItem("Tool/Export NavMesh")]
    public static void Export()
    {
        var navMeshTriangulation = NavMesh.CalculateTriangulation();

        //新建文件
        var scene = SceneManager.GetActiveScene();
        var sceneFolder = Path.GetDirectoryName(scene.path);
        var modelFileFolder = Path.Combine(sceneFolder, scene.name);
        if (!AssetDatabase.IsValidFolder(modelFileFolder))
        {
            var guid = AssetDatabase.CreateFolder(sceneFolder, scene.name);
            if (string.IsNullOrEmpty(guid))
            {
                Debug.LogError($"{modelFileFolder} create fail");
                return;
            }
        }

        var modelFilePath = Path.Combine(modelFileFolder, "NavMeshModel.obj");
        Debug.Log($"NavMeshModel path: {modelFilePath}");

        using (var sw = new StreamWriter(modelFilePath))
        {
            //顶点
            for (var i = 0; i < navMeshTriangulation.vertices.Length; i++)
            {
                var vert = navMeshTriangulation.vertices[i];
                sw.WriteLine($"v  {-vert.x} {vert.y} {vert.z}"); //这边注意, x要变为负号, 否则导入的模型在x方向是翻转的, 貌似是左手坐标系右手坐标系的问题
            }

            sw.WriteLine("Plane1");

            //索引
            for (var i = 0; i < navMeshTriangulation.indices.Length; i += 3)
            {
                var indices = navMeshTriangulation.indices;
                sw.WriteLine($"f {(indices[i] + 1)} {(indices[i + 1] + 1)} {(indices[i + 2] + 1)}");
            }
        }

        AssetDatabase.Refresh();
        Debug.Log("导出NavMesh成功");
    }

}