using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestGetInfo : MonoBehaviour
{
    private void Awake()
    {
        Debug.Log("�豸����ϸ��Ϣ");
        Debug.Log("�豸ģ��:" + SystemInfo.deviceModel);
        Debug.Log("�豸����:" + SystemInfo.deviceName);
        Debug.Log("�豸����:" + SystemInfo.deviceType.ToString());
        Debug.Log("�豸Ψһ��ʶ��:" + SystemInfo.deviceUniqueIdentifier);
        Debug.Log("�Ƿ�֧��������:" + SystemInfo.copyTextureSupport.ToString());
        Debug.Log("�Կ�ID:" + SystemInfo.graphicsDeviceID.ToString());
        Debug.Log("�Կ�����:" + SystemInfo.graphicsDeviceName);
        Debug.Log("�Կ�����:" + SystemInfo.graphicsDeviceType.ToString());
        Debug.Log("�Կ���Ӧ��:" + SystemInfo.graphicsDeviceVendor);
        Debug.Log("�Կ���Ӧ��ID:" + SystemInfo.graphicsDeviceVendorID.ToString());
        Debug.Log("�Կ��汾��:" + SystemInfo.graphicsDeviceVersion);
        Debug.Log("�Դ��С����λ��MB��:" + SystemInfo.graphicsMemorySize);
        Debug.Log("�Կ��Ƿ�֧�ֶ��߳���Ⱦ:" + SystemInfo.graphicsMultiThreaded.ToString());
        Debug.Log("֧�ֵ���ȾĿ������:" + SystemInfo.supportedRenderTargetCount.ToString());
        Debug.Log("ϵͳ�ڴ��С(��λ��MB):" + SystemInfo.systemMemorySize.ToString());
        Debug.Log("����ϵͳ:" + SystemInfo.operatingSystem);
    }
    void OnGUI()
    {
       
    }
}

