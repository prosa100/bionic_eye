Shader "Unlit/Points"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
	_DotTex("Dot", 2D) = "white" {}
	_DotSize("Dot Freq", Float) = 1 // not implemented
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

	float _DotFreq, _DotSize;
	sampler2D _MainTex;
	
	sampler2D _DotTex;

	float4 _MainTex_ST;

	v2f vert(appdata v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = v.uv;
		return o;
	}


	float4 calcColor(float2 uv, float2 key) {

		float4 col = tex2D(_MainTex, key);
		//return col;
		float2 offset = (uv - key)*_DotSize;

		float dist = length(offset);
		
		offset += 0.5; // make it uv space..
		offset=saturate(offset);
		//return float4(offset,0,1);
		//return float4(dist,dist,dist,1);

		float intesity = saturate(dot(col, float4(0.3, 0.4, 0.3, 0)));
		
		 float4 f = tex2D(_DotTex, float2(dist, 1 - intesity));
		 return f;
		 float w = f.r;
		 return float4(w, w, w, 1);

		/*
		w *= 2;
		//w *= w < 1;
		//w = saturate(0.2+ .4*intesity - dist);
		const float std = 0.07;
		const float PI = 3.1415;
		w = exp(-w*w / (2 * std*std)) / sqrt(2 * std*std*PI);
		*/

		w = 0.5 - dist;
		w = w < 0.5;
		//w = tex2D(_DotTex, offset).r; // grayscale.


		//w = saturate(.4- pow(dist,0.5));

		//w = pow(w, 3);

		//w *= w; // makes it apear square
		//w = w > 0.1;	 //saturate(w);
		//scol.a = intesity;

		float4 c = w*col;
		//c.a = w;

		return c;
	}

	fixed4 frag(v2f i) : SV_Target
	{
		// sample the texture. maybe do lod???
		
		float2 nearestPoint = i.uv;
		
		
		nearestPoint = floor(nearestPoint/_DotFreq)+0.5;
		nearestPoint *= _DotFreq;

		

		//float2 nearestPoint = floor(i.uv*_DotFreq) / _DotFreq;
		//nearestPoint += 0.5*_DotFreq;

		float4 acc = float4(0, 0, 0, 0);
			
			acc += calcColor(i.uv, nearestPoint);
		
			
		const float w = _DotFreq;
		/*
		acc += calcColor(i.uv, nearestPoint + float2(-w, 0));
		acc += calcColor(i.uv, nearestPoint + float2(w, 0));
		acc += calcColor(i.uv, nearestPoint + float2(0, w));
		acc += calcColor(i.uv, nearestPoint + float2(0, -w));
		acc += calcColor(i.uv, nearestPoint + float2(-w, w));
		acc += calcColor(i.uv, nearestPoint + float2(w, w));
		acc += calcColor(i.uv, nearestPoint + float2(-w, -w));
		acc += calcColor(i.uv, nearestPoint + float2(w, -w));
		*/
		acc = max(acc, calcColor(i.uv, nearestPoint + float2(w, 0)));
		acc = max(acc, calcColor(i.uv, nearestPoint + float2(0, w)));
		acc = max(acc, calcColor(i.uv, nearestPoint + float2(0, -w)));
		acc = max(acc, calcColor(i.uv, nearestPoint + float2(-w, w)));
		acc = max(acc, calcColor(i.uv, nearestPoint + float2(w, w)));
		acc = max(acc, calcColor(i.uv, nearestPoint + float2(-w, -w)));
		acc = max(acc,	calcColor(i.uv, nearestPoint + float2(w, -w)));

		acc /= acc.a;

		return  acc ;
	}
		ENDCG
	}
	}
}
