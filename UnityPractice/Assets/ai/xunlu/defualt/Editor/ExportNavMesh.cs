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

        //�½��ļ�
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
            //����
            for (var i = 0; i < navMeshTriangulation.vertices.Length; i++)
            {
                var vert = navMeshTriangulation.vertices[i];
                sw.WriteLine($"v  {-vert.x} {vert.y} {vert.z}"); //���ע��, xҪ��Ϊ����, �������ģ����x�����Ƿ�ת��, ò������������ϵ��������ϵ������
            }

            sw.WriteLine("Plane1");

            //����
            for (var i = 0; i < navMeshTriangulation.indices.Length; i += 3)
            {
                var indices = navMeshTriangulation.indices;
                sw.WriteLine($"f {(indices[i] + 1)} {(indices[i + 1] + 1)} {(indices[i + 2] + 1)}");
            }
        }

        AssetDatabase.Refresh();
        Debug.Log("����NavMesh�ɹ�");
    }

}