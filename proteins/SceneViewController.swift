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
    var cordData = [[(x: Float, y: Float, z: Float)]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(sceneData)
        print(cordData)
        sceneView.backgroundColor = UIColor.white
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        let scene = SCNScene()
        scene.rootNode.addChildNode(SCNNode())
        scene.rootNode.name = "Test"
        for node in sceneData {
            scene.rootNode.addChildNode(node)
        }
        print(cordData.count)
        for atom in cordData {
            var from = atom[0]
            print(atom)
            for cord in 1...atom.count - 1 {
              let celinder = makeCylinder(positionStart: SCNVector3(from.x, from.y, from.z), positionEnd: SCNVector3([atom[cord].x, atom[cord].y, atom[cord].z]), radius: 0.1, color: UIColor.black, transparency: 0.1)
                scene.rootNode.addChildNode(celinder)
            }
        }
        //let celinder = makeCylinder(positionStart: SCNVector3([0.0,0.0, 0.0]), positionEnd: SCNVector3([1.0, 1.0, 1.0]), radius: 0.1, color: UIColor.black, transparency: 0.1)
        sceneView.scene = scene
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        test.text = "hello"
    }

    func makeCylinder(positionStart: SCNVector3, positionEnd: SCNVector3, radius: CGFloat , color: UIColor, transparency: CGFloat) -> SCNNode
    {
        let height = CGFloat(GLKVector3Distance(SCNVector3ToGLKVector3(positionStart), SCNVector3ToGLKVector3(positionEnd)))
        let startNode = SCNNode()
        let endNode = SCNNode()
        
        startNode.position = positionStart
        endNode.position = positionEnd
        
        let zAxisNode = SCNNode()
        zAxisNode.eulerAngles.x = Float(CGFloat(M_PI_2))
        
        let cylinderGeometry = SCNCylinder(radius: radius, height: height)
        cylinderGeometry.firstMaterial?.diffuse.contents = color
        let cylinder = SCNNode(geometry: cylinderGeometry)
        
        cylinder.position.y = Float(-height/2)
        zAxisNode.addChildNode(cylinder)
        
        let returnNode = SCNNode()
        
        if (positionStart.x > 0.0 && positionStart.y < 0.0 && positionStart.z < 0.0 && positionEnd.x > 0.0 && positionEnd.y < 0.0 && positionEnd.z > 0.0)
        {
            endNode.addChildNode(zAxisNode)
            endNode.constraints = [ SCNLookAtConstraint(target: startNode) ]
            returnNode.addChildNode(endNode)
            
        }
        else if (positionStart.x < 0.0 && positionStart.y < 0.0 && positionStart.z < 0.0 && positionEnd.x < 0.0 && positionEnd.y < 0.0 && positionEnd.z > 0.0)
        {
            endNode.addChildNode(zAxisNode)
            endNode.constraints = [ SCNLookAtConstraint(target: startNode) ]
            returnNode.addChildNode(endNode)
            
        }
        else if (positionStart.x < 0.0 && positionStart.y > 0.0 && positionStart.z < 0.0 && positionEnd.x < 0.0 && positionEnd.y > 0.0 && positionEnd.z > 0.0)
        {
            endNode.addChildNode(zAxisNode)
            endNode.constraints = [ SCNLookAtConstraint(target: startNode) ]
            returnNode.addChildNode(endNode)
            
        }
        else if (positionStart.x > 0.0 && positionStart.y > 0.0 && positionStart.z < 0.0 && positionEnd.x > 0.0 && positionEnd.y > 0.0 && positionEnd.z > 0.0)
        {
            endNode.addChildNode(zAxisNode)
            endNode.constraints = [ SCNLookAtConstraint(target: startNode) ]
            returnNode.addChildNode(endNode)
            
        }
        else
        {
            startNode.addChildNode(zAxisNode)
            startNode.constraints = [ SCNLookAtConstraint(target: endNode) ]
            returnNode.addChildNode(startNode)
        }
        
        return returnNode
    }
}
