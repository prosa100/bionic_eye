Shader "Hidden/DepthEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Speed("Speed", Float) = 3
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
			sampler2D _CameraDepthTexture;
			float _Speed;
			fixed4 frag (v2f i) : SV_Target
			{
				
				float de = tex2D(_CameraDepthTexture, i.uv).r;
				float depth = LinearEyeDepth(de);
				
				const float far = _ProjectionParams.z;

				

				float x = depth/ far ; // 1 m mod
				
				float3 dir = normalize(float3(i.uv - 0.5,_Speed));
				//x = length(dir / dir.z *x);
				//x=  length(float3(0.2*(i.uv - 0.5), x));

				float refDist = _ProjectionParams.z*frac(_Time.y * _Speed);
				
				//x = frac(depth / refDist);
				//x = saturate(depth - refDist);
				//x = 0.1*abs(depth - refDist);
				
				//x = saturate(depth*_Speed);
				//x = pow(depth, _Speed);
				return float4(x, x, x, 1);
				//now with technicolor!!!
				return float4(depth, depth/10, 1/ depth, 1)%1;
			}
			ENDCG
		}
	}
}
