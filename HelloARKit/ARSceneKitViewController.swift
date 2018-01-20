//
//  ARSceneKitViewController.swift
//  HelloARKit
//
//  Created by Dion Larson on 9/21/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARSceneKitViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var planeCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Show feature points for debugging
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                if self.planeCount < 1 {
                    self.planeCount += 1
                    let waterScene = SKScene(fileNamed: "PondScene-Water")
                    let waterNode = self.createPlaneNode(center: planeAnchor.center, extent: planeAnchor.extent, contents: waterScene)
                    node.addChildNode(waterNode)
                    
                    let pondScene = PondScene(fileNamed: "PondScene-Main")
                    pondScene?.didMove(to: SKView())
                    pondScene?.isPaused = false
                    let pondNode = self.createPlaneNode(center: planeAnchor.center, extent: planeAnchor.extent, contents: pondScene, yOffset: 0.025)
                    node.addChildNode(pondNode)
                    
                    let plantScene = SKScene(fileNamed: "PondScene-Plants")
                    let plantNode = self.createPlaneNode(center: planeAnchor.center, extent: planeAnchor.extent, contents: plantScene, yOffset: 0.05)
                    node.addChildNode(plantNode)
                }
            }
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    // MARK: - Plane Helpers
    
    func createPlaneNode(center: vector_float3, extent: vector_float3, contents: Any? = UIColor.blue.withAlphaComponent(0.4), yOffset: Float = 0) -> SCNNode {
        let plane = SCNPlane(width: CGFloat(extent.x), height: CGFloat(extent.z))
        
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = contents
        plane.materials = [planeMaterial]
        let planeNode = SCNNode(geometry: plane)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        planeNode.position = SCNVector3Make(center.x, yOffset, center.z)
        return planeNode
    }
}
