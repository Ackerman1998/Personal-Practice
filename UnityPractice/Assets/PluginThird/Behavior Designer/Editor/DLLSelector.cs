using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections.Generic;

namespace BehaviorDesigner.Editor
{
    [InitializeOnLoad]
    public class DLLSelector
    {
        // run at startup and remove any DLLs that do not correspond with the installed Unity version. This script will self destruct after it has completed its task
        static DLLSelector()
        {
            // wait until all loading is done
            EditorApplication.delayCall += RemoveAssembly;
        }

        public static void RemoveAssembly()
        {
            // no longer need this callback
            EditorApplication.delayCall -= RemoveAssembly;

            // Don't show a dialog if there are no dlls to remove
            if (Directory.GetFiles(Application.dataPath, "*.pre4_3.dll", SearchOption.AllDirectories).Length == 0 &&
                Directory.GetFiles(Application.dataPath, "*.post4_3", SearchOption.AllDirectories).Length == 0) {
                return;
            }

            // Inform the user of what we are doing
            if (EditorUtility.DisplayDialog("Remove Unnecessary Assemblies",
                "Behavior Designer includes assemblies for versions before and after Unity 4.3. Do you want to delete the unnecessary assemblies?",
                "Yes", "No")) {

                // Remove the old runtime assembly
                var runtimePath = Directory.GetFiles(Application.dataPath, "BehaviorDesignerRuntime.dll", SearchOption.AllDirectories);
                if (runtimePath.Length == 1) {
                    File.Delete(runtimePath[0]);
                }

                // get the assemblies with the .pre4.3 extension
                var assembilyPaths = Directory.GetFiles(Application.dataPath, "*.pre4_3.dll", SearchOption.AllDirectories);
                for (int i = 0; i < assembilyPaths.Length; ++i) {
#if UNITY_3_5 || UNITY_4_0 || UNITY_4_0_1 || UNITY_4_1 || UNITY_4_2
                    try {
                        // rename the pre4.3 assembly if we are running on a Unity version before 4.3
                        var newPath = assembilyPaths[i].Substring(0, assembilyPaths[i].Length - 11) + ".dll"; // ".pre4_3.dll" is 11 characters
                        if (File.Exists(newPath)) {
                            File.Delete(newPath); // delete the old assembly
                        }
                        File.Move(assembilyPaths[i], newPath);
                    }
                    catch (FileNotFoundException e) {
                        Debug.Log("Unable to rename " + e.FileName);
                    }
#else
                    try {
                        // remove the pre4.3 assembly if we are running on a Unity version after 4.3
                        File.Delete(assembilyPaths[i]);
                        if (File.Exists(assembilyPaths[i] + ".meta")) {
                            File.Delete(assembilyPaths[i] + ".meta");
                        }
                    }
                    catch (FileNotFoundException e) {
                        Debug.Log("Unable to delete " + e.FileName);
                    }
#endif
                }

                // repeat for the post4.3 extension
                assembilyPaths = Directory.GetFiles(Application.dataPath, "*.post4_3", SearchOption.AllDirectories);
                for (int i = 0; i < assembilyPaths.Length; ++i) {
#if UNITY_3_5 || UNITY_4_0 || UNITY_4_0_1 || UNITY_4_1 || UNITY_4_2
                    try {
                        // Remove the pre4.3 assembly if we are running on a Unity version after 4.3
                        File.Delete(assembilyPaths[i]);
                    }
                    catch (FileNotFoundException e) {
                        Debug.Log("Unable to delete " + e.FileName);
                    }
#else
                    try {
                        // rename the post4.3 assembly if we are running on a Unity version after 4.3
                        var newPath = assembilyPaths[i].Substring(0, assembilyPaths[i].Length - 8); // ".post4_3" is 12 characters
                        if (File.Exists(newPath)) {
                            File.Delete(newPath); // delete the old assembly
                        }
                        File.Move(assembilyPaths[i], newPath);
                        if (File.Exists(newPath + ".meta")) {
                            File.Delete(newPath + ".meta"); // delete the old meta file
                        }
                        if (File.Exists(assembilyPaths[i] + ".meta")) {
                            File.Move(assembilyPaths[i] + ".meta", newPath + ".meta");
                        }
                    }
                    catch (FileNotFoundException e) {
                        Debug.Log("Unable to rename " + e.FileName);
                    }
#endif
                }

                // this script no longer needs to be run
                try {
                    File.Delete(Application.dataPath + "/Behavior Designer/Editor/DLLSelector.cs");
                    if (File.Exists(Application.dataPath + "/Behavior Designer/Editor/DLLSelector.cs.meta"))
                        File.Delete(Application.dataPath + "/Behavior Designer/Editor/DLLSelector.cs.meta");
                }
                catch (FileNotFoundException e) {
                    Debug.Log("Unable to delete " + e.FileName);
                }

                // Reload the asset database
                AssetDatabase.Refresh();

#if UNITY_3_5 || UNITY_4_0 || UNITY_4_0_1 || UNITY_4_1 || UNITY_4_2
                EditorUtility.DisplayDialog("Assemblies Removed",
                    "The assemblies were removed. If you update Unity to a later version make sure you reimport Behavior Designer. Behavior Designer can be accessed from the Window toolbar.", "OK");
#else
                EditorUtility.DisplayDialog("Assemblies Removed", "The assemblies were removed. Behavior Designer can be accessed from the Tools toolbar.", "OK");
#endif
            } else {
                EditorUtility.DisplayDialog("Assemblies Not Removed",
                    "The assemblies were not removed. You can manually delete the assemblies located within the Behavior Designer and Behavior Designer editor folder. Behavior Designer can be accessed from the Tools toolbar.", "OK");
            }
        }
    }
}