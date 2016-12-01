using UnityEngine;
using System.Collections;

public class CameraDriver : MonoBehaviour {
    WebCamTexture cam;
    public Transform follow;
    
    
    // Use this for initialization
	void Start () {
        var name = WebCamTexture.devices[1].name;
        Application.RequestUserAuthorization(UserAuthorization.WebCam);
        cam = new WebCamTexture(name);
        GetComponent<MeshRenderer>().material.mainTexture = cam;

        
        cam.Play();


	}
	
    
	// Update is called once per frame
	void Update () {
        if (cam.didUpdateThisFrame && follow)
        {
            transform.position = follow.position;
            transform.rotation = follow.rotation;

            // i don't know if this has anything to help prevent tering.
            // also proably not timestamped
            // I need to compesate for the latency by back positioning it.
            // keep a record
            // start the pipeline
            // want to use that sexy thing from ms...
        }
            //fuck the worod.
	}
}
