Shader "UIEffect/OutLine"
{
	//外描边效果
	Properties
	{
		[PerRendererData] _MainTex ("MainTex", 2D) = "white" {}
		_Color("Tint", Color) = (1,1,1,1)
		_OutLineWide ("OutLineWide", Float) = 1
		_OutlineAlpha ("_OutlineAlpha", Float) = 1
		_OutLineColor ("OutLineColor", COLOR) = (0,0,0,1)


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
				half2 up_uv  : TEXCOORD1;
				half2 down_uv  : TEXCOORD2;
				half2 left_uv  : TEXCOORD3;
				half2 right_uv  : TEXCOORD4;
				UNITY_VERTEX_OUTPUT_STEREO
			};

			sampler2D _MainTex;
			float4 _MainTex_TexelSize;
			float4 _Color;
			half _OutLineWide;
			half _OutlineAlpha;
			fixed4 _OutLineColor;

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
				half4 col = tex2D(_MainTex, IN.texcoord);
				half2 destUv = half2(_OutLineWide * _MainTex_TexelSize.x * 200, _OutLineWide * _MainTex_TexelSize.y * 200);			
				half spriteLeft = tex2D(_MainTex, IN.texcoord + half2(destUv.x, 0)).a;
				half spriteRight = tex2D(_MainTex, IN.texcoord - half2(destUv.x, 0)).a;
				half spriteBottom = tex2D(_MainTex, IN.texcoord + half2(0, destUv.y)).a;
				half spriteTop = tex2D(_MainTex, IN.texcoord - half2(0, destUv.y)).a;
				half result = spriteLeft + spriteRight + spriteBottom + spriteTop;
				result *= (1 - col.a) * _OutlineAlpha;
				half4 outline = _OutLineColor;
				outline.a = result;
				col = lerp(col, outline, result);
				return col;
			}
		ENDCG
		}
	}
}