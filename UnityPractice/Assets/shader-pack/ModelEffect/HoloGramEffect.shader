Shader "ModelEffect/HologramEffect"
{
    Properties
    {
        //HDR 作用 = 让照片无论高光还是阴影部分细节都很清晰,
        [HDR]_HologramColor("Hologram Color", Color) = (1, 1, 1, 0)
		_HologramAlpha("Hologram Alpha", Range(0.0, 1.0)) = 1.0
    }
    SubShader
    {
        Tags{"Queue" = "Transparent" "RenderType" = "Transparent"}
        CGINCLUDE
			struct a2v_hg
            {
                float4 vertex : POSITION;
            };
            struct v2f_hg
            {
                float4 pos : SV_POSITION;
            };

            float4 _HologramColor;
            fixed _HologramAlpha;
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
                    return o;
                }

                float4 HologramFragment(v2f_hg i) : SV_Target
                {
                    return float4(_HologramColor.rgb, _HologramAlpha);
                }
			ENDCG
        }
    }
}

