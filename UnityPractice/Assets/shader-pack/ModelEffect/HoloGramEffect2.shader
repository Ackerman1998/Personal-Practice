Shader "ModelEffect/HologramEffect2"
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
		ENDCG
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off
            CGPROGRAM
				#pragma target 3.0
				#pragma vertex HologramVertex
				#pragma fragment HologramFragment
            
                v2f_hg HologramVertex(a2v_hg v)
                {
                    v2f_hg o;
                    o.pos = UnityObjectToClipPos(v.vertex);
                     o.uv = v.uv;
                    return o;
                }

                float4 HologramFragment(v2f_hg i) : SV_Target
                {
                    float4 main_color = _HologramColor;
                    // 用主纹理的r通道做颜色蒙版
                    float2 mask_uv = i.uv.xy * _HologramMaskMap_ST.xy + _HologramMaskMap_ST.zw;
                    float4 mask = tex2D(_HologramMaskMap, mask_uv);
                    // 追加一个参数用来控制遮罩效果
                    float mask_alpha = lerp(1, mask.r, _HologramMaskAffect);
                    float4 resultColor = float4(main_color.rgb, _HologramAlpha * mask_alpha );
                    return resultColor;
                }
			ENDCG
        }
    }
}

