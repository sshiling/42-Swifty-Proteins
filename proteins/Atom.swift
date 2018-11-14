//
//  Atom.swift
//  proteins
//
//  Created by Olga SKULSKA on 11/14/18.
//  Copyright © 2018 Sergiy SHILINGOV. All rights reserved.
//

import Foundation
import SceneKit
import ChameleonFramework

class Atom {
    
    let atomNum : Int
    var x : Float
    let y : Float
    let z : Float
    let atomName : String
    
    init(_ num: String, _ x: String, _ y: String, _ z: String, _ name: String) {
        
        self.atomName = name
        self.atomNum = Int(num)!
        self.x = Float(x)!
        self.y = Float(y)!
        self.z = Float(z)!
    }
    
    func makeAtom() -> SCNNode {
        let Atom = SCNSphere(radius: 1.70)
        Atom.firstMaterial!.diffuse.contents = UIColor.flatBlue
        Atom.firstMaterial!.specular.contents = UIColor.white
        let atomScene = SCNNode(geometry: Atom)
        atomScene.position = SCNVector3Make(x, y, z)
        return atomScene
    }
}
