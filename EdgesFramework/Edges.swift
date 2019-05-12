//
//  edges.swift
//  EdgesFramework
//
//  Created by Łukasz Dziedzic on 08/05/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation

public struct Edges {

    enum EdgesErrors:Error {
        case wrongEdgesNumber(edges: Int)
        case axesNumberLessThanOne(axes: Int)
    }

    private var _axes: [[Double]]
    
    public init (_ value: Double, position:[Double] = []) {
        _axes = [[value]]
    }

    public init (_ arrays: [[Double]]) {
        _axes = arrays
    }
    
    public subscript (axis:Int, edge:Int) -> Double {
        get {
            return _axes[axis][edge]
        }
        set {
            _axes[axis][edge] = newValue
        }
    }
    
    mutating public func addAxis(with value:Double) {

        _axes = _axes.map {$0+$0}

        let newAxis = Array<Double>(repeating: value, count: numberOfEdges(for: axesCount+1))
        _axes.append(newAxis)
        //for debug only:
//                (0..<_axes.count).forEach{ axisNr in
//                    (0..<_axes[axisNr].count).forEach({
//                        _axes[axisNr][$0] = Double($0)/50.0 + Double(axisNr)/10.0
//                    })
//                }
    }
    
    mutating public func removeAxis(index:Int) -> Edges {
        
        guard _axes.count > 1 else {return Edges(_axes[0][0])}

        var newAxes = [[Double]]()
        var removedAxis = [[Double]]()
        var axes = _axes

        let lastAxis = axes.remove(at: index)//[_axes.count-1]
        for axisNr in 0 ..< axes.count {
            var newEdges = [Double]()
            var removed = [Double]()
            for edge in 0 ..< axes[axisNr].count / 2 {
                let first = axes[axisNr][edge]
                
                let egdeIndex = edge + (axes[axisNr].count / 2)
                let second = axes[axisNr][egdeIndex]
                let offset = 1 << axisNr
                let thirdIndex = edge.insert(bit: false, at: axisNr)
                let third = lastAxis[thirdIndex]
                let fourth = lastAxis[thirdIndex + offset]
                let val = cross(x1: first, x2: second, y1: third, y2: fourth)
                newEdges.append(val.x)
                removed.append(val.y)
                
                
            }
            newAxes.append(newEdges)
            removedAxis.append(removed)
        }
        _axes = newAxes
        var removedEdges = Edges(0)
        removedEdges._axes = removedAxis
        
        while removedEdges.axesCount > 1 {
            removedEdges = removedEdges.removeAxis(index: removedEdges.axesCount-1)
        }
        
        return removedEdges
    }

    public var axesCount:Int {
        return _axes.count
    }
    
    public var coordinates:[Double] {
        var result:[Double] = []
        var e = self
        (0..<self.axesCount).forEach{ _ in
            result.append(e.removeAxis(index: 0)[0,0])
        }
        return result
    }
//    public var edgesCount:Int {
//        return _axes.reduce(into: 0, {$0 += $1.count})
//    }
    
//    func totalEdgesCount(for axes:Int) -> Int {
//        return axes * numberOfEdges(for: axes)
//    }
    
    public var edgesCount:Int  {
//        if axesCount < 1 {
//            fatalError("Axis is less than 0")//EdgesErrors.axesNumberLessThanOne(axes: axes)
//        }
        return 1 << (axesCount - 1)
    }

    func numberOfEdges(for axesCount: Int) -> Int {
        return 1 << (axesCount - 1)
    }
    
    
    func axesNrCountedFromEdges() throws -> Int {
        let edges = Double(edgesCount)
        let n = (edges * 2 * log(2)).plog / log(2)
        let t: Double = 100000
        if (n * t).rounded()/t != Double(Int(n)) {
            throw EdgesErrors.wrongEdgesNumber(edges: Int(n))
        }
        return Int(n)
    }
    
    public func move(axis:Int, edge:Int, by: Double, deep:Int) {
       //???
    }
    
}

extension Edges: CustomStringConvertible {
    public var description: String {
        let axesStr = _axes.reduce(into:"", {output, edges in
            let edgesStr = edges.reduce(into:"\t", {$0 += String(format: "%0.4f, ", $1)})
            output += "\(edgesStr)\n" })
        return "\(axesCount) axes,\n\(axesStr)"
    }
}

