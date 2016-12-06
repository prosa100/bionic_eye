using UnityEngine;
using System.Collections;

public class ImagePipeline : MonoBehaviour {
    public Material mat;

    public RenderTexture output;

    void Start()
    {
        output = new RenderTexture(256, 256, 0, RenderTextureFormat.RFloat);
    }

	// Use this for initialization
	void OnPostRender() {
	    
	}
}
