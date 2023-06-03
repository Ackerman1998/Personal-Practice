Shader "UIEffect/Pixel"
{
	//图片像素化
	Properties
	{
		[PerRendererData] _MainTex ("MainTex", 2D) = "white" {}
		_Color("Tint", Color) = (1,1,1,1)
			_PixelFactor ("PixelFactor", Float) = 1
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
			float _PixelFactor;

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
				/*
				_MainTex_TexelSize,这个变量的从字面意思是主贴图 _MainTex 的像素尺寸大小,是一个四元数,
				是 unity 内置的变量,它的值为 Vector4(1 / width, 1 / height, width, height)
				*/
				// fixed4 color = tex2D(_MainTex,IN.texcoord) * IN.color * _Color;
				//half2 pixelSize = max(2, (1-_PixelFactor*0.95) * _MainTex_TexelSize.zw);
				/*
				像素化公式： 根据_PixelFactor来控制这张图像素的大小,使用_PixelFactor这个参数对图片的UV
				进行放大取整,再用这个参数做除法，这样得到的UV精度就丢失了，得到的图片就是像素化效果.
				*/
				half2 pixelSize =(1-_PixelFactor*0.95) * _MainTex_TexelSize.zw;
				IN.texcoord = round(IN.texcoord * pixelSize) / pixelSize;
				half4 color = tex2D(_MainTex, IN.texcoord);
				return color;
			}
		ENDCG
		}
	}
}