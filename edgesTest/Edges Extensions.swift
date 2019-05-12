//
//  Edges Extensions.swift
//  edgesTest
//
//  Created by Łukasz Dziedzic on 09/05/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import EdgesFramework
import SceneKit


extension MultidimensionalStyle {

    func edgePoints(axis:Int, edge:Int) -> (start:[Double], end:[Double], value:[Double]) {

        var a = Array(repeating: Double.nan, count: axesCount)
        var b = Array(repeating: Double.nan, count: axesCount)
        var c = Array(repeating: Double.nan, count: axesCount)
        
        let a1 = edge.insert(bit: false, at: axis)
        let b1 = edge.insert(bit: true, at: axis)

        for i in 0..<axesCount {
            
            a[i] = a1 & (1 << i) == 0 ? 0.0 : 1.0
            b[i] = b1 & (1 << i) == 0 ? 0.0 : 1.0
            
            
        }
        c = a
        c[axis] = self[axis, edge]
        
        return (start: a, end: b, value: c)
    }
    
    func convertTo3D (leaveAxes:[Int], coordinates:[Double]) -> SCNVector3 {
        guard [0, 3].contains(leaveAxes.count) else { return SCNVector3() }

        var result = SCNVector3()
        
        let coords:Array<Double>
        
        if coordinates.count < 3 {
            coords = coordinates + (0...(3-coordinates.count)).map {_ in 0}
        } else {
            coords = Array(coordinates[0..<3])
        }
        if leaveAxes.count == 0 {
            result.x = CGFloat(coords[0])
            result.y = CGFloat(coords[1])
            result.z = CGFloat(coords[2])
          
        } else {
            result.x = CGFloat(coords[leaveAxes[0]])
            result.y = CGFloat(coords[leaveAxes[0]])
            result.z = CGFloat(coords[leaveAxes[0]])
        }
        
        
        return result
        
    }
}
