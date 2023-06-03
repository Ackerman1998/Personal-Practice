Shader "UIEffect/UIGlitch"
{
	Properties
	{
		[PerRendererData] _MainTex ("MainTex", 2D) = "white" {}
		_Color("Tint", Color) = (1,1,1,1)
		_ScanLineJitter("ScanLineJitter",Float) = 0
		_ColorDrift("ColorDrift",Vector) = (0,0,0,0)
		_HorizontalShake("Horizontal Shake", Range(0.0, 1.0)) = 1.0
		//UI MODUEL
		[Header(Stencil)]
		[HideInInspector]_StencilComp ("Stencil Comparison", Float) = 8
		[HideInInspector]_Stencil ("Stencil ID", Float) = 0
		[HideInInspector]_StencilOp ("Stencil Operation", Float) = 0
		[HideInInspector]_StencilWriteMask ("Stencil Write Mask", Float) = 255
		[HideInInspector]_StencilReadMask ("Stencil Read Mask", Float) = 255
		[HideInInspector]_ColorMask ("Color Mask", Float) = 15
		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
	}

	SubShader
	{
		Tags
		{
			"Queue"="Transparent"
			"IgnoreProjector"="True"
			"RenderType"="Transparent"
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}

		Stencil
		{
			Ref [_Stencil]
			Comp [_StencilComp]
			Pass [_StencilOp]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
		}
	        Cull Off   //关闭剔除
		Lighting Off
		ZWrite Off  //关闭深度写入
		ZTest [unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask [_ColorMask]

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag

			#pragma multi_compile __ UNITY_UI_ALPHACLIP

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			sampler2D _MainTex;
			float4 _MainTex_TexelSize;
			float4 _Color;

			float _ScanLineJitter; // (displacement, threshold)
			float _HorizontalShake;
			float2 _ColorDrift;     // (amount, time)

			//计算噪音公式(白噪声)[0,1]
			float nrand(float x, float y)
			{
				return frac(sin(dot(float2(x, y), float2(12.9898, 78.233))) * 43758.5453);
			}
			
			half4 frag(v2f_img i) : SV_Target
			{
				float u = i.uv.x;
				float v = i.uv.y;

				//扫描线 [-1,1]
				float jitter = nrand(v, _Time.x) * 2 - 1;
				jitter *= step(0, abs(jitter)) * _ScanLineJitter;
				//jitter = [-1,1] * 0.01 = [-0.01,0.01]
				//画面垂直跳
				//float jump = lerp(v, frac(v), 0);

				////画面左右震动
				//float shake = (nrand(_Time.x, 2) - 0.5) * _HorizontalShake;

				////颜色偏移
				//float drift = sin(v + _ColorDrift.y) * _ColorDrift.x;

				////have shake and color offset ,drift
				// half4 src1 = tex2D(_MainTex, frac(float2(u + jitter + shake, v)));
				// half4 src2 = tex2D(_MainTex, frac(float2(u + jitter + shake + drift, v)));
				//return half4(src1.r, src2.g, src1.b, 1);


				//simple glitch
				//原理：
				half4 src1 = tex2D(_MainTex, frac(float2(u + jitter , v)));
				//half4 src2 = tex2D(_MainTex, frac(float2(u + jitter , v)));
				return half4(src1.rgb, 1);
			}

		ENDCG
		}
	}
}
