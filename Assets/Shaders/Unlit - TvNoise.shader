Shader "Unlit/Unlit - TvNoise"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_NoiseTex ("Texture", 2D) = "black" {}
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
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _NoiseTex;
			float4 _NoiseTex_ST;

			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed2 uv = i.uv;
				fixed2 adduv = fixed2(0,0);
				fixed4 noiseColor = tex2D(_NoiseTex, fixed2( 0, i.uv.y + _Time.x * 5 ));
				fixed4 noiseColor2 = tex2D(_NoiseTex, fixed2( 0.25, i.uv.y + _Time.x * 20 ));
				if( noiseColor2.y < 0.7 )
				{
					adduv.x = ( noiseColor.x - 0.5 ) / 5;	// remap
				}
				fixed4 col = tex2D(_MainTex, uv + adduv);
				return col;
			}
			ENDCG
		}
	}
}
