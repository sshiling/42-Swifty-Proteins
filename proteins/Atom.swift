//
//  Atom.swift
//  proteins
//
//  Created by Olga SKULSKA on 11/14/18.
//  Copyright © 2018 Sergiy SHILINGOV. All rights reserved.
//

import Foundation

class Atom {
    
    let atomNum : Int
    let x : Double
    let y : Double
    let z : Double
    let atomName : String
    
    init(_ num: String, _ x: String, _ y: String, _ z: String, _ name: String) {
        
        self.atomName = name
        self.atomNum = Int(num)!
        self.x = Double(x)!
        self.y = Double(y)!
        self.z = Double(z)!
    }
}
