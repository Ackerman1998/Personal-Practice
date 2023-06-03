Shader "UIEffect/Shadow"
{
	//图片像素化
	Properties
	{
		[PerRendererData] _MainTex ("MainTex", 2D) = "white" {}
		_Color("Tint", Color) = (1,1,1,1)
		_OffsetX ("Offset X", range(-0.2,0.2)) = 0 
		_OffsetY ("Offset Y", range(-0.2,0.2)) = 0 
		_ShadowColor ("Shadow Color", COLOR) = (0,0,0,1)
		_ThresholdAlpha("Threshold Alpha", Range(0,0.5)) = 0.1


		[Header(Stencil)]
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255
		_ColorMask ("Color Mask", Float) = 15
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
			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile __ UNITY_UI_ALPHACLIP

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
		        struct v2f
			{
				float4 vertex   : SV_POSITION;
				float4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
				UNITY_VERTEX_OUTPUT_STEREO
			};

			sampler2D _MainTex;
			float4 _MainTex_TexelSize;
			float4 _Color;
			half _OffsetX;
			half _OffsetY;
			fixed4 _ShadowColor;
			half _ThresholdAlpha;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);

				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color;
				return OUT;
			}

			fixed4 frag(v2f IN) : SV_Target
			{
				half4 color = tex2D(_MainTex, IN.texcoord);
				half4 shadow = tex2D(_MainTex, IN.texcoord.xy + half2(_OffsetX,_OffsetY));
				fixed4 shadowCol = fixed4(shadow.rgb,shadow.a*_ShadowColor.a);
				fixed4 finalCol = shadowCol;
				fixed stepVal = step(_ThresholdAlpha , color.a);
				finalCol = stepVal * color + (1-stepVal)*shadowCol;
				return finalCol;
			}
		ENDCG
		}
	}
}