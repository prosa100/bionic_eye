using UnityEngine;
using System.Collections;
using UnityStandardAssets.ImageEffects;

[ExecuteInEditMode]
[AddComponentMenu("Image Effects/Displacement/Points")]
public class PointsFx : ImageEffectBase
{
    public float numDots;
  
    public float dotScale;
    public Texture dotTexture;
    // Called by camera to apply image effect
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        material.SetFloat("_DotFreq", 1 / numDots);
        material.SetFloat("_DotSize", dotScale);
        material.SetTexture("_DotTex", dotTexture);

        Graphics.Blit(source, destination, material);
    }
}
