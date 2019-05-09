//
//  Cross.swift
//  EdgesFramework
//
//  Created by Łukasz Dziedzic on 08/05/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
/**
Optimized lines intersection point for 0...1×0...1 square, reads only `x`s for first line and `y`s for second one.
- parameter x1: x of first line, y = 0
- parameter x2: x of first line, y = 1
- parameter y1: y of second line, x = 0
- parameter y2: y of second line, x = 1
- returns: tuple (x,y) for intersetion point
*/

public func cross(x1:Double,
           x2:Double,
           y1:Double,
           y2:Double)
    -> (x:Double, y:Double) {
        
        let mul = (x1 -  x2) * (y1 - y2) - 1
        let x =  (x1 * y1 - x1 - x2 * y1 ) / mul
        let y = (x1 * y1 - y1 - x1 * y2) / mul
        return (x:x, y:y)
}
