using UnityEngine;
using System.Collections;
using UnityStandardAssets.ImageEffects;

[ExecuteInEditMode]
[AddComponentMenu("Image Effects/Depth FX")]
public class ShowDepthFx : ImageEffectBase
{
    public float speed;
	// Use this for initialization
	override protected void Start () {
        base.Start();
        GetComponent<Camera>().depthTextureMode |= DepthTextureMode.Depth;
	}
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        //Graphics.SetRenderTarget(destination);
        material.SetFloat("_Speed", speed);
        Graphics.Blit(source, destination, material);
    }
}
