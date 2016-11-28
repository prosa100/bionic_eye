Shader "Unlit/Points"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
	_DotFreq("Dot Freq", Float) = 10
	}
		SubShader
	{
		Tags{ "RenderType" = "Opaque" }
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

	float _DotFreq;
	sampler2D _MainTex;
	float4 _MainTex_ST;

	v2f vert(appdata v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = TRANSFORM_TEX(v.uv, _MainTex);
		return o;
	}


	float4 calcColor(float2 uv, float2 key) {

		float2 uvkey = key * _DotFreq;
		fixed4 col = tex2D(_MainTex, uvkey);
		float dist = distance(uv/ _DotFreq, key);
		//return float4(dist,dist,dist,dist);

		float intesity = saturate(dot(col, float4(0.3, 0.4, 0.3, 0)));
		
		
		float w = dist<intesity; //goes from zero to one.
		
		w = saturate(1 - dist);
								 //saturate(w);
		//scol.a = intesity;

		float4 c = w*col;
		//c.a = w;

		return c;
	}

	fixed4 frag(v2f i) : SV_Target
	{
		// sample the texture. maybe do lod???
		
		float2 nearestPoint = i.uv;
		nearestPoint-= nearestPoint%_DotFreq;
		nearestPoint /= _DotFreq;
		nearestPoint += 0.5;

		//float2 nearestPoint = floor(i.uv*_DotFreq) / _DotFreq;
		//nearestPoint += 0.5*_DotFreq;

		float4 acc = calcColor(i.uv, nearestPoint);
		acc += calcColor(i.uv, nearestPoint + float2(-1, 0));
		acc += calcColor(i.uv, nearestPoint + float2(1, 0));
		acc += calcColor(i.uv, nearestPoint + float2(0, 1));
		acc += calcColor(i.uv, nearestPoint + float2(0, -1));


		acc += calcColor(i.uv, nearestPoint + float2(-1, 1));
		acc += calcColor(i.uv, nearestPoint + float2(1, 1));
		acc += calcColor(i.uv, nearestPoint + float2(-1, -1));
		acc += calcColor(i.uv, nearestPoint + float2(1, -1));



		acc /= acc.a;

		return  acc ;
	}
		ENDCG
	}
	}
}
