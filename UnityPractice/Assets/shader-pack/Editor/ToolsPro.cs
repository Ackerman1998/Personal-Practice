using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEngine.SceneManagement;
using UnityEditor.SceneManagement;
using System.IO;

public class ToolsPro 
{
    [MenuItem("ToolsPro/Clear Scene SkyBox")]
    public static void ClearSceneSkyBox() {
        RenderSettings.skybox = null;
        SaveScene();
    }
    private static void SaveScene() {
        EditorSceneManager.MarkSceneDirty(EditorSceneManager.GetActiveScene());
        EditorSceneManager.SaveOpenScenes();
    }
    [MenuItem("Assets/Create/Shader/UI Shader")]
    public static void CreateUIShader()
    {
        string path = Application.dataPath+"/ackerman-test/Editor/ui-shader-example.txt";
        string str = File.ReadAllText(path);
        Debug.Log("text = "+str);
        string[] strs = Selection.assetGUIDs;
       
        string pathSelect = AssetDatabase.GUIDToAssetPath(strs[0]);
        
    }
}
