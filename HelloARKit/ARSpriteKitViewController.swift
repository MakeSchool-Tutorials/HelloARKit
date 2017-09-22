//
//  ARSpriteKitViewController.swift
//  HelloARKit
//
//  Created by Dion Larson on 9/22/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

class ARSpriteKitViewController: UIViewController, ARSKViewDelegate {
    
    @IBOutlet var sceneView: ARSKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        // Load the SKScene from 'Scene.sks'
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

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
    
    // MARK: - ARSKViewDelegate
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        // Create and configure a node for the anchor added to the view's session.
        let node = SKSpriteNode(imageNamed: "ms-logo.png")
        node.setScale(0.05)
        node.anchorPoint = CGPoint(x: 0.5, y: 0)
        // Create a wrapper node so it will stay scaled down
        let anchorNode = SKNode()
        anchorNode.addChild(node)
        return anchorNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        // Grab furthest feature point (.first = closest feature point)
        if let hit = sceneView.hitTest(center, types: [.featurePoint]).last {
            // Add an anchor at the found hit, see view(_:nodeFor) to configure anchor node
            sceneView.session.add(anchor: ARAnchor(transform: hit.worldTransform))
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
}
