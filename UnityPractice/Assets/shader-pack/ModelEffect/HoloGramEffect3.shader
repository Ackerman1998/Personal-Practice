Shader "ModelEffect/HologramEffect3"
{
    Properties
    {
        //HDR 作用：让照片无论高光还是阴影部分细节都很清晰,
        [HDR]_HologramColor("Hologram Color", Color) = (1, 1, 1, 0)
		_HologramAlpha("Hologram Alpha", Range(0.0, 1.0)) = 1.0

        _HologramMaskMap("Hologram Mask", 2D) = "white"{}
		_HologramMaskAffect("Hologram Mask Affect", Range(0.0, 1.0)) = 0.5
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

            v2f_hg HologramVertex(a2v_hg v)
            {
                v2f_hg o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
		ENDCG
        Pass{
            Name "Depth Mask"
            ZWrite On
            ColorMask 0 
            // CGPROGRAM
            // #pragma target 3.0
            // #pragma vertex HologramVertex
            // #pragma fragment HologramMaskFragment
            // float4 HologramMaskFragment(v2f_hg i) : SV_TARGET
            // {
            //     return 0;
            // }
            // ENDCG
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
                    return resultColor;
                }
			ENDCG
        }
    }
}
/*
使用双PASS 来渲染model，一个开启深度写入，负责将model的深度值写入到深度缓冲里，
另一个负责正常的透明度混合
由于上一个Pass已经得到了逐像素的正确的深度信息，该Pass就可以按照像素级别的深度
排序结果进行透明渲染。但这种方法的缺点在于，多使用一个Pass 会对性能造成一定的
影响。可以看出，使用这种方法，我们仍然可以实现模型与它后面的背景混合的效果，
但模型内部之间不会有任何真正的半透明效果。

常见的透明度混合公式：
//正常(Normal )， 即透明度混合
Blend SrcAlpha OneMinusSrcAlpha
//柔和相加( soft Additive )
Blend OneMinusDstColor One
//正片叠底(Multiply)， 即相乘
Blend DstColor Zero
//两倍相乘(2x. Multiply )
Blend DstColor SrcColor
//变暗( Darken )
Blend0p Min
Blend One One
//变亮( Lighten )
BlendOp Max
Blend One One
//滤色( Screen )
Blend OneMinusDstColor One
//等同于
Blend One OneMinusSrcColor
//线性减淡( Linear Dodge )
Blend One One
*/
