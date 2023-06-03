using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestGetInfo : MonoBehaviour
{
    private void Awake()
    {
        Debug.Log("设备的详细信息");
        Debug.Log("设备模型:" + SystemInfo.deviceModel);
        Debug.Log("设备名称:" + SystemInfo.deviceName);
        Debug.Log("设备类型:" + SystemInfo.deviceType.ToString());
        Debug.Log("设备唯一标识符:" + SystemInfo.deviceUniqueIdentifier);
        Debug.Log("是否支持纹理复制:" + SystemInfo.copyTextureSupport.ToString());
        Debug.Log("显卡ID:" + SystemInfo.graphicsDeviceID.ToString());
        Debug.Log("显卡名称:" + SystemInfo.graphicsDeviceName);
        Debug.Log("显卡类型:" + SystemInfo.graphicsDeviceType.ToString());
        Debug.Log("显卡供应商:" + SystemInfo.graphicsDeviceVendor);
        Debug.Log("显卡供应商ID:" + SystemInfo.graphicsDeviceVendorID.ToString());
        Debug.Log("显卡版本号:" + SystemInfo.graphicsDeviceVersion);
        Debug.Log("显存大小（单位：MB）:" + SystemInfo.graphicsMemorySize);
        Debug.Log("显卡是否支持多线程渲染:" + SystemInfo.graphicsMultiThreaded.ToString());
        Debug.Log("支持的渲染目标数量:" + SystemInfo.supportedRenderTargetCount.ToString());
        Debug.Log("系统内存大小(单位：MB):" + SystemInfo.systemMemorySize.ToString());
        Debug.Log("操作系统:" + SystemInfo.operatingSystem);
    }
    void OnGUI()
    {
       
    }
}

