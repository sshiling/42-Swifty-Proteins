//
//  SceneViewController.swift
//  proteins
//
//  Created by Olga SKULSKA on 11/14/18.
//  Copyright © 2018 Sergiy SHILINGOV. All rights reserved.
//

import UIKit
import SceneKit

class SceneViewController: UIViewController {

    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var sceneView: SCNView!
    
    var sceneData: [SCNNode] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(sceneData)
        sceneView.backgroundColor = UIColor.red
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        let scene = SCNScene()
        scene.rootNode.addChildNode(sceneData[0])
        sceneView.scene = scene
        print(sceneView.scene)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        test.text = "hello"
    }
    
    
//    func sceneSetup() {
//        let scene = SCNScene()
//
//        let ambientLightNode = SCNNode()
//        ambientLightNode.light = SCNLight()
//        ambientLightNode.light!.type = SCNLight.LightType.ambient
//        ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
//        scene.rootNode.addChildNode(ambientLightNode)
//
//        let omniLightNode = SCNNode()
//        omniLightNode.light = SCNLight()
//        omniLightNode.light!.type = SCNLight.LightType.omni
//        omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
//        omniLightNode.position = SCNVector3Make(0, 50, 50)
//        scene.rootNode.addChildNode(omniLightNode)
//
//        let cameraNode = SCNNode()
//        cameraNode.camera = SCNCamera()
//        cameraNode.position = SCNVector3Make(0, 0, 25)
//        scene.rootNode.addChildNode(cameraNode)
//
//        sceneView.scene = scene
//        scene.backgro = UIColor.blue
//    }


}
