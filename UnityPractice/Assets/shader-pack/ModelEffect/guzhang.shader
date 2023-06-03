Shader "ModelEffect/HologramEffect4"
{
    //vertex glitch effect
    Properties
    {
        [HDR]_HologramColor("Hologram Color", Color) = (1, 1, 1, 0)
		_HologramAlpha("Hologram Alpha", Range(0.0, 1.0)) = 1.0

        _HologramMaskMap("Hologram Mask", 2D) = "white"{}
		_HologramMaskAffect("Hologram Mask Affect", Range(0.0, 1.0)) = 0.5

        _HologramGliterData1("Hologram Gliter Data1", Vector) = (0, 1, 0, 0) 
		_HologramGliterData2("Hologram Gliter Data2", Vector) = (0, 1, 0, 0)
    }
    SubShader
    {
        Tags{"Queue" = "Transparent" "RenderType" = "Transparent"}
        CGINCLUDE
			struct a2v_hg
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            struct v2f_hg
            {
                float4 pos : SV_POSITION;
                 float2 uv : TEXCOORD0;
            };

            float4 _HologramColor;
            fixed _HologramAlpha;
            
            sampler2D _HologramMaskMap;
            float4 _HologramMaskMap_ST;
            half _HologramMaskAffect;
            half4 _HologramGliterData1, _HologramGliterData2;
           half3 VertexHologramOffset(float3 vertex, half4 offsetData)
            {
                half speed = offsetData.x;
                half range = offsetData.y;
                half offset = offsetData.z;
                half frequency = offsetData.w;

                half offset_time = sin(_Time.y * speed);
                // step(y, x) 如果 x >= y 则返回1，否则返回0，用来决定在正弦时间的某个地方才开始进行顶点抖动
                half timeToGliter = step(frequency, offset_time);
                half gliterPosY = sin(vertex.y + _Time.z);
                half gliterPosYRange = step(0, gliterPosY) * step(gliterPosY, range);
                // 获取偏移量
                half res = gliterPosYRange * offset * timeToGliter * gliterPosY;

                // 将这个偏移量定义为视角坐标的偏移量，再转到模型坐标
                float3 view_offset = float3(res, 0, 0);
                return mul((float3x3)UNITY_MATRIX_T_MV, view_offset);;
            }
            v2f_hg HologramVertex(a2v_hg v)
            {
                v2f_hg o;
                v.vertex.xyz += VertexHologramOffset(v.vertex.xyz, _HologramGliterData1);
                //v.vertex.xyz += VertexHologramOffset(v.vertex.xyz, _HologramGliterData2);
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
		ENDCG
        Pass{
            Name "Depth Mask"
            ZWrite On
            ColorMask 0 
        }

        Pass
        {
            Name "Hologram Effect"
            Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off
            CGPROGRAM
				#pragma target 3.0
				#pragma vertex HologramVertex
				#pragma fragment HologramFragment
                
                float4 HologramFragment(v2f_hg i) : SV_Target
                {
                    float4 main_color = _HologramColor;
                    // 用主纹理的r通道做颜色蒙版
                    float2 mask_uv = i.uv.xy * _HologramMaskMap_ST.xy + _HologramMaskMap_ST.zw;
                    float4 mask = tex2D(_HologramMaskMap, mask_uv);
                    // 追加一个参数用来控制遮罩效果
                    float mask_alpha = lerp(1, mask.r, _HologramMaskAffect);
                    float4 resultColor = float4(main_color.rgb, _HologramAlpha * mask_alpha);
                    //return mask;
                    return resultColor;
                }
			ENDCG
        }
    }
}
