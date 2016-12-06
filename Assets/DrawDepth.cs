using UnityEngine;
using System.Collections;
using UnityStandardAssets.ImageEffects;

[ExecuteInEditMode]
[AddComponentMenu("Image Effects/Displacement/Grad")]
public class DrawDepth : ImageEffectBase
{
    public float scale;

    public float dotSize;
    public Texture dotTexture;
    // Called by camera to apply image effect
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        material.SetFloat("_Scale", scale);
        //material.SetFloat("_DotSize", numDots * dotSize);
        //material.SetTexture("_DotTex", dotTexture);

        Graphics.Blit(source, destination, material);
    }
}
