Shader "UIEffect/Blur"
{
	Properties
	{
		[PerRendererData] _MainTex ("MainTex", 2D) = "white" {}
		_Color("Tint", Color) = (1,1,1,1)
		_BlurIntensive("模糊强度",Float) = 0.5
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
			float _BlurIntensive;
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
			/*
			原理：
			获取像素点周围的八个像素点的color,累加起来得到的结果就是最终值
			得到的效果：一张图片有八个重影，重叠在一起的效果就像是模糊.
			1 2 1
			2 4 2
			1 2 1
			*/
			half4 BlurFunc(half2 uv , sampler2D sourcePic , float blurIntensive){
				half step = 0.00390625f * blurIntensive;
				half4 result = half4(0,0,0,0);
				half2 texCoord = half2(0, 0);
				float beishu2 = 2;
				float beishu4 = 4;
				float beishu3 = 0.0625;
				texCoord = uv + half2(-step,-step);
				result += tex2D(sourcePic,texCoord);

				texCoord = uv + half2(-step,0);
				result += beishu2*tex2D(sourcePic,texCoord);

				texCoord = uv + half2(-step,step);
				result += tex2D(sourcePic,texCoord);

				texCoord = uv + half2(0,-step);
				result += beishu2*tex2D(sourcePic,texCoord);

				texCoord = uv ;
				result += beishu4*tex2D(sourcePic,texCoord);

				texCoord = uv + half2(0,step);
				result += beishu2*tex2D(sourcePic,texCoord);

				texCoord = uv + half2(step,-step);
				result += tex2D(sourcePic,texCoord);

				texCoord = uv + half2(step,0);
				result += beishu2*tex2D(sourcePic,texCoord);

				texCoord = uv + half2(step,step);
				result += tex2D(sourcePic,texCoord);

				result *= beishu3;
				return result;
			}
			fixed4 frag(v2f IN) : SV_Target
			{
				//half4 color = tex2D(_MainTex,IN.texcoord) * IN.color * _Color;
				half4 color = half4(BlurFunc(IN.texcoord,_MainTex,_BlurIntensive).rgb,1);
				return color;
			}
		ENDCG
		}
	}
}
/*
颜色的rgb的每个值都是[0,1]的，颜色值相乘必然会使颜色值减小（物体更暗），
相加必然会使颜色值增加更加接近1（物体更亮）。
在计算光照反射时，经过物体材质的反射，光的颜色必然是经过削弱的，
所以在计算光照反射时用颜色值相乘。

而在计算贴图采样颜色和环境光颜色时，也用了颜色值相乘，这是因为这时候计算的
是两个颜色值的混合。在现实生活中，把很多不同颜色的颜料混合在一起时，他们的
颜色最后会变为黑色。这说明他们的颜色值都是越来越小的，rgb值越来越趋近于0，
所以才会变成黑色。所以在计算两个颜色值的混合时用颜色相乘。

颜色相加，在最后返回像素颜色的时候，用的时环境光颜色和漫反射颜色、高光反射颜色相加。
这是因为不同类型的光照计算必然是要让物体变亮的（即颜色值增加），所以在计算各种不同
的光照效果叠加时应用颜色值相加。
*/