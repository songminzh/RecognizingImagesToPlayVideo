//
//  ViewController.swift
//  ARKitPlayVideo
//
//  Created by Murphy Zheng on 2018/11/21.
//  Copyright © 2018 mulberry. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    var session: ARSession {
        return sceneView.session
    }
    
    // MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.session.delegate = self as? ARSessionDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Start the AR experience
        resetTracking()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
         session.pause()
    }
    
    // MARK: - Session management (Image detection setup)
    
    var isRestartAvailable = true
    
    func resetTracking() {
        guard let refernceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = refernceImages
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    // MARK: - ARSCNViewDelegate (Image detection results)
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return
        }
        let referenceImage = imageAnchor.referenceImage
        if (referenceImage.name != nil) {
            initPlayer(fileName: referenceImage.name! as NSString)
            let imageWidth = referenceImage.physicalSize.width
            let imageHeight = referenceImage.physicalSize.height
            let bgBox = SCNBox(width: imageWidth, height: imageHeight, length: 0.01, chamferRadius: 0.0)
            let tempNode = SCNNode(geometry: bgBox)
            tempNode.eulerAngles = SCNVector3Make(Float(-.pi/2.0), 0.0, 0.0)
            tempNode.opacity = 1.0
            let material = SCNMaterial()
            material.diffuse.contents = player
            tempNode.geometry?.materials = [material]
            player?.play()
            
            node.addChildNode(tempNode)
        }
    }
}

var player : AVPlayer?

func initPlayer(fileName: NSString) {
    let urlStr = Bundle.main.path(forResource: fileName as String, ofType: "mp4")
    let url = URL(fileURLWithPath: urlStr ?? "")
    let playerItem = AVPlayerItem(url: url)
    player = AVPlayer(playerItem: playerItem)
}

