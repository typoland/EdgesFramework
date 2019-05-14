//
//  SCNScene + Line.swift
//  edgesTest
//
//  Created by Łukasz Dziedzic on 09/05/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import SceneKit
/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import CoreGraphics
import SceneKit

public extension SCNVector3 {
    
    // Vector Length is Zero
    func isZero() -> Bool {
        if self.x == 0 && self.y == 0 && self.z == 0 {
            return true
        }
        
        return false
    }
    
    /**
     Inverts vector
     */
    mutating func invert() -> SCNVector3 {
       self = self * -1
        return self
    }
    
    /**
     Calculates vector length based on Pythagoras theorem
     */
    var length: CGFloat {
        get {
            let result =  CGFloat(sqrtf(Float(lengthSquared)))
            print (result)
            return result
        }
        set {
            self = self.unit * newValue
        }
    }
    
    /**
     Calculate Length Squared of Vector
     - Used to determine Longest/Shortest Vector. Faster than using v.length
     */
    var lengthSquared: CGFloat {
        get {
            let x2 = x*x
            let y2 = y*y
            let z2 = z*z
            print (x, y, z)
            return x2 + y2 + z2
        }
    }
    
    /**
     Returns unit vector (aka Normalized Vector)
     - v.length = 1.0
     */
    var unit:SCNVector3 {
        get {
            return self / self.length
        }
    }
    
    /**
     Normalizes vector
     - v.Length = 1.0
     */
    mutating func normalize() {
        self = self.unit
    }
    
    /**
     Calculates distance to vector
     */
    func distance(toVector: SCNVector3) -> CGFloat {
        return (self - toVector).length
    }
    
    
    /**
     Calculates dot product to vector
     */
    func dot(toVector: SCNVector3) -> CGFloat {
        let xa = x * toVector.x
        let ya = y * toVector.y
        let za = z * toVector.z
        return xa + ya + za
    }
    
    /**
     Calculates cross product to vector
     */
    func cross(toVector: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(y * toVector.z - z * toVector.y, z * toVector.x - x * toVector.z, x * toVector.y - y * toVector.x)
    }
    
    /**
     Returns lerp from Vector to Vector
     */
    func lerp(toVector: SCNVector3, t: CGFloat) -> SCNVector3 {
        return SCNVector3Make(
            self.x + ((toVector.x - self.x) * t),
            self.y + ((toVector.y - self.y) * t),
            self.z + ((toVector.z - self.z) * t))
    }
    
    /**
     Project onto Vector
     */
    func project(ontoVector: SCNVector3) -> SCNVector3 {
        let scale = dotBetweenVectors(ontoVector, v2: self) / dotBetweenVectors(ontoVector, v2: ontoVector)
        let v: SCNVector3 = ontoVector * scale
        return v
    }
    
    /// Get/Set Angle of Vector
    mutating func rotate(angle:CGFloat) {
        let length = self.length
        self.x = cos(angle) * length
        self.y = sin(angle) * length
    }
    
    
    func toCGVector() -> CGVector {
        return CGVector(dx: CGFloat(self.x), dy: CGFloat(self.y))
    }
    
}

/**
 v1 = v2 + v3
 */
func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

/**
 v1 += v2
 */
func +=( left: inout SCNVector3, right: SCNVector3) {
    left = left + right
}

/**
 v1 = v2 - v3
 */
func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
}

/**
 v1 -= v2
 */
func -=( left: inout SCNVector3, right: SCNVector3) {
    left = left - right
}

/**
 v1 = v2 * v3
 */
public func *(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x * right.x, left.y * right.y, left.z * right.z)
}

/**
 v1 *= v2
 */
public func *=( left: inout SCNVector3, right: SCNVector3) {
    left = left * right
}

/**
 v1 = v2 * x
 */
public func *(left: SCNVector3, right: CGFloat) -> SCNVector3 {
    return SCNVector3Make(left.x * right, left.y * right, left.z * right)
}

/**
 v *= x
 */
public func *=( left: inout SCNVector3, right: CGFloat) {
    left = SCNVector3Make(left.x * right, left.y * right, left.z * right)
}

/**
 v1 = v2 / v3
 */
func /(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x / right.x, left.y / right.y, left.z / right.z)
}

/**
 v1 /= v2
 */
func /=( left: inout SCNVector3, right: SCNVector3) {
    left = SCNVector3Make(left.x / right.x, left.y / right.y, left.z / right.z)
}

/**
 v1 = v2 / x
 */
func /(left: SCNVector3, right: CGFloat) -> SCNVector3 {
    return SCNVector3Make(left.x / right, left.y / right, left.z / right)
}

/**
 v /= x
 */
func /=( left: inout SCNVector3, right: CGFloat) {
    left = SCNVector3Make(left.x / right, left.y / right, left.z / right)
}

/**
 v = -v
 */
prefix func -(v: SCNVector3) -> SCNVector3 {
    return v * -1
}

/**
 Returns distance between two vectors
 */
func distanceBetweenVectors(v1: SCNVector3, v2: SCNVector3) -> CGFloat {
    return (v2 - v1).length
}

/**
 Returns dot product between two vectors
 */
func dotBetweenVectors(_ v1: SCNVector3, v2: SCNVector3) -> CGFloat {
    return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
}

/**
 Returns cross product between two vectors
 */
func crossBetweenVectors(v1: SCNVector3, v2: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(v1.y * v2.z - v1.z * v2.y, v1.z * v2.x - v1.x * v2.z, v1.x * v2.y - v1.y * v2.x)
}

/**
 Generate a Random Vector
 */
func randomSCNVector3(rangeX:CGFloat, rangeY:CGFloat, rangeZ:CGFloat) -> SCNVector3 {
    
    return SCNVector3(
        x: CGFloat(arc4random()%UInt32(rangeX)),
        y: CGFloat(arc4random()%UInt32(rangeY)),
        z: CGFloat(arc4random()%UInt32(rangeZ)))
}

public extension SCNScene {
    class func line(from : SCNVector3, to : SCNVector3, width : Int, color : NSColor) -> SCNNode {
        let vector = to - from
        let lineLength = vector.length
        print ("lineLength", lineLength)
        let cylinder = SCNCylinder(radius: 1, height: lineLength)
        cylinder.radialSegmentCount = width
        cylinder.firstMaterial?.diffuse.contents = color
        
        let node = SCNNode(geometry: cylinder)
        
        node.position = (to + from) / 2
        node.eulerAngles = SCNVector3Make(CGFloat(Double.pi/2), acos((to.z-from.z)/lineLength), atan2((to.y-from.y), (to.x-from.x) ))
        
        return node
    }
}
