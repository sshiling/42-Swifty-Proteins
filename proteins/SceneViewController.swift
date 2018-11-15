//
//  SceneViewController.swift
//  proteins
//
//  Created by Olga SKULSKA on 11/14/18.
//  Copyright © 2018 Sergiy SHILINGOV. All rights reserved.
//

import UIKit
import SceneKit

class SceneViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var sceneView: SCNView!
    
    @IBOutlet var pinch: UIPinchGestureRecognizer!
    var sceneData: [SCNNode] = []
    var cordData = [[(x: Float, y: Float, z: Float)]]()
    var alreadyUsedAtoms = [(x: Float, y: Float, z: Float)]()
    var previousScale:CGFloat = 1.0
    
    @IBAction func shareImage(_ sender: Any) {
        let bounds = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let activityViewController = UIActivityViewController(activityItems: [img!], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // TAP Gesture
        pinch.delegate = self
        view.addGestureRecognizer(pinch)
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
            alreadyUsedAtoms.append(from)
            print(atom)
            for cord in 1...atom.count - 1 {
                if !checkIfAlreadyUsed(atomsArray: alreadyUsedAtoms, toSearch: atom[cord]) {
                  let celinder = makeCylinder(positionStart: SCNVector3(from.x, from.y, from.z), positionEnd: SCNVector3([atom[cord].x, atom[cord].y, atom[cord].z]), radius: 0.1, color: UIColor.black, transparency: 0.1)
                    scene.rootNode.addChildNode(celinder)
                }
            }
        }
        sceneView.scene = scene
    }
    
    @IBAction func scalePiece(_ gestureRecognizer : UIPinchGestureRecognizer) {   guard gestureRecognizer.view != nil else { return }
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            gestureRecognizer.view?.transform = (gestureRecognizer.view?.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale))!
            gestureRecognizer.scale = 1.0
        }}

    
    func checkIfAlreadyUsed(atomsArray: [(x: Float, y: Float, z: Float)], toSearch: (x: Float, y: Float, z: Float)) -> Bool {
        let (x1, x2, x3) = toSearch
        for (v1, v2, v3) in atomsArray { if v1 == x1 && v2 == x2 && v3 == x3 { return true } }
        return false
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
