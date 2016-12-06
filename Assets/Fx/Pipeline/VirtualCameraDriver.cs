using UnityEngine;
using System.Collections;

public class VirtualCameraDriver : MonoBehaviour {
    public RenderTexture color, depth;
    Camera cam;

    public int res = 512;
	// Use this for initialization
	void Start () {
        cam = GetComponent<Camera>();

        color = new RenderTexture(res, res, 0, RenderTextureFormat.ARGBFloat);
        depth = new RenderTexture(res, res, 0, RenderTextureFormat.ARGBFloat);

        
        //cam.SetTargetBuffers(color.colorBuffer, depth.colorBuffer);
	}
	
    public Shader depthNormalShader;

	// Update is called once per frame
	void Update () {
        cam.targetTexture = color;
        cam.Render();
        cam.targetTexture = depth;
        cam.RenderWithShader(depthNormalShader, "Opaque");
    }
}
