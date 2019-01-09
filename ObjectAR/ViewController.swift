//
//  ViewController.swift
//  ObjectAR
//
//  Created by Андрей Парчуков on 10/01/2019.
//  Copyright © 2019 Andrei Parchukov. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    var player: AVPlayer?

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = .showWorldOrigin
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        guard let objectReference = ARReferenceObject.referenceObjects(inGroupNamed: "RecognitionObject", bundle: nil) else {
            fatalError("sas")
        }
        configuration.detectionObjects = objectReference

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if let objectAnchor = anchor as? ARObjectAnchor {
            node.addChildNode(addVideoToNode(anchor: objectAnchor))
        }
        return node
    }
    
    func addVideoToNode(anchor: ARObjectAnchor) -> SCNNode {
        let tvNode = SCNNode()
        
        guard let videoFile = Bundle.main.url(forResource: "videoplayback", withExtension: "mp4") else {return tvNode}
        player = AVPlayer(url: videoFile)
        
        let tvPlane = SCNPlane(width: CGFloat(anchor.referenceObject.extent.x * 1.6), height: CGFloat(anchor.referenceObject.extent.y * 0.9))
        tvPlane.firstMaterial?.diffuse.contents = player
        tvPlane.firstMaterial?.isDoubleSided = true
        
        tvNode.geometry = tvPlane
        tvNode.position = SCNVector3(anchor.referenceObject.center.x, anchor.referenceObject.center.y + 0.2, anchor.referenceObject.center.z)
        
        playVideo()
        return tvNode
    }
    
    func playVideo() {
        player?.seek(to: CMTime.zero)
        player?.play()
        player?.volume = 3
    }

}
