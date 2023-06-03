Shader "eff/dissolveEff"
{
    /*
    溶解
    */
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DissolveTex ("Texture", 2D) = "white" {}
        _DissolveThreshold ("DissolveThreshold" , float) = 1
        _DissolveLerpVal ("DissolveLerpVal" ,float ) = 0.7
        _DissolveLerpColor ("DissolveLerpColor" ,Color ) = (0,0,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _DissolveTex;
            float4 _MainTex_ST;
            fixed4 _DissolveLerpColor;
            float _DissolveThreshold;
            float _DissolveLerpVal;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 colDis = tex2D(_DissolveTex, i.uv);
                clip(colDis.r-_DissolveThreshold);
                float lerpVal = _DissolveThreshold / colDis.r;
                if(lerpVal > _DissolveLerpVal){
                    return _DissolveLerpColor;
                }
                // apply fog
                return col;
            }
            ENDCG
        }
    }
}
