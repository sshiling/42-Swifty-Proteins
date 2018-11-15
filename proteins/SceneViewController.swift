//
//  SceneViewController.swift
//  proteins
//
//  Created by Olga SKULSKA on 11/14/18.
//  Copyright © 2018 Sergiy SHILINGOV. All rights reserved.
//

import UIKit
import SceneKit
import SwiftyJSON

class SceneViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var melt: UILabel!
    @IBOutlet weak var boil: UILabel!
    @IBOutlet weak var mass: UILabel!
    @IBOutlet weak var descript: UILabel!
    @IBOutlet weak var sceneView: SCNView!
    
    @IBOutlet var tap: UITapGestureRecognizer!
    @IBOutlet var pinch: UIPinchGestureRecognizer!
    
    var scene = SCNScene()
    var previousScale:CGFloat = 1.0
    var hittedObj  =  SCNNode()
    var oldColor  = UIColor()
    var descData: [AtomDescription] = []
    
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
        sceneView.addGestureRecognizer(tap)
        tap.delegate = self
        sceneView.backgroundColor = UIColor.white
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 35)
        scene.rootNode.addChildNode(cameraNode)
        sceneView.scene = scene
        if let path = Bundle.main.path(forResource: "PeriodicTableJSON", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = JSON(data)
                for i in json["elements"]{
                    let atomDescription = AtomDescription(json: i.1)
                    descData.append(atomDescription)
                }
            } catch {
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: sceneView)
        hittedObj.geometry?.firstMaterial?.emission.contents = oldColor
        let hitList = sceneView.hitTest(location, options: nil)
        if let hitObject = hitList.first {
            print(hitObject.node)
            for currAtom in descData{
                if currAtom.symb == hitObject.node.name
                {
                    melt.text = "no value"
                    boil.text = "no value"
                    name.text = currAtom.name ?? "not set"
                    if let temp = currAtom.melt{
                        melt.text = String(describing: temp)
                    }
                    if let temp = currAtom.boil{
                        boil.text = String(describing: temp)
                    }
                    if let temp = currAtom.atomic_mass{
                        mass.text = String(describing: temp)
                    }
                    descript.text = currAtom.summary
                }
            }
            hittedObj = hitObject.node
            oldColor = hitObject.node.geometry?.firstMaterial?.emission.contents as! UIColor
            hitObject.node.geometry?.firstMaterial?.emission.contents = UIColor.yellow
            
        }
        else {
            name.text = nil
        }
    }
    
    @IBAction func scalePiece(_ gestureRecognizer : UIPinchGestureRecognizer) {   guard gestureRecognizer.view != nil else { return }
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            gestureRecognizer.view?.transform = (gestureRecognizer.view?.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale))!
            gestureRecognizer.scale = 1.0
        }}

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

