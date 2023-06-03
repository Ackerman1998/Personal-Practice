Shader "UIEffect/Shiny"
{
	//图片扫光效果
	Properties
	{
		[PerRendererData] _MainTex ("MainTex", 2D) = "white" {}
		_Color("Tint", Color) = (1,1,1,1)
		_Rotation("Rotation",Float) = 1
		_Factor("Factor",Float) = 1
		_Width("Width",Float) = 1
		_Softness("Softness",Float) = 1
		_Brightness("Brightness",Float) = 1
		_Gloss("Gloss",Float) = 1
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
			float _Rotation;
			float _Factor;
			float _Width;
			float _Brightness;
			float _Gloss;
			float _Softness;

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
				float2 shinyUv=mul(_Rotation,IN.texcoord-0.5);
				half4 color = tex2D(_MainTex,IN.texcoord) * IN.color * _Color;
				fixed nomalizedPos = shinyUv.x;
				half location = _Factor * 2 - 0.5;
				half normalized = 1 - saturate(abs((nomalizedPos - location) / _Width));
				half shinePower = smoothstep(0, _Softness, normalized);
				half3 reflectColor = lerp(fixed3(1,1,1), color.rgb * 7, _Gloss);
				color.rgb += color.a * (shinePower / 2) * _Brightness * reflectColor*_Color;
				return color;
			}
		ENDCG
		}
	}
}