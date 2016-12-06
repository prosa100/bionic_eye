Shader "Hidden/EdgeDetect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	_Scale("Scale", Float) = 0.01
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

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

			float _Scale;

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 c = tex2D(_MainTex, i.uv);
				fixed4 a = tex2D(_MainTex, i.uv + _Scale*float2(0, 1));
				fixed4 b = tex2D(_MainTex, i.uv + _Scale*float2(1, 0));
				
				
				
				float4 d = abs(a - c ) + abs(b - c);
				
				float di = dot(d, float4(.3, .4, .3, 0));
				float ci = dot(c, float4(.3, .4, .3, 0));
				float x;
				x = pow(1 - ci, 4.5);
				x = (-5000*pow(di, 2.0) + 0.9)* x;
				
				//x = pow(x, 2);
				//x = 1 - saturate(x);
				return float4(x,x,x,1);
			}
			ENDCG
		}
	}
}
