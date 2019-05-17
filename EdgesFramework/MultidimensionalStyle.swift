//
//  edges.swift
//  EdgesFramework
//
//  Created by Łukasz Dziedzic on 08/05/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation

public struct MultidimensionalStyle {
    
    struct StyleAxis {
        
        var name: String = ""
        var edges: [Double] = []
        
        init() {}
        
        init (name: String, edges : [Double]) {
            self.name = name
            self.edges = edges
        }

        subscript (i: Int) -> Double {
            get {
                return edges [i]
            }
            set {
                edges [i] = newValue
            }
        }
        var count: Int {
            return edges.count
        }
    }

    enum EdgesErrors:Error {
        case wrongEdgesNumber(edges: Int)
        case axesNumberLessThanOne(axes: Int)
    }

    private var _axes: [StyleAxis] = []

    public var name:String {
        return _axes.reduce(into: "", {$0 += $1.name})
    }

    public init () {}

    public init (_ name:String, value: Double) {
        _axes = [StyleAxis( name: name, edges: [ value ])]
    }

    public init (_ name:String, _ array: [Double]) {
        _axes = [StyleAxis(name: name, edges: array)]
    }

    public init (_ names:[String], _ arrays: [[Double]]) {
        _axes = (0..<arrays.count).map {StyleAxis( name: names[$0], edges: arrays[$0])}
    }
    
    init (axes: [StyleAxis]) {
        _axes = axes
    }

    public subscript (axisNr:Int, edgeNr:Int) -> Double {
        get {
            return _axes[axisNr][edgeNr]
        }
        set {
            _axes[axisNr][edgeNr] = newValue
        }
    }

    mutating public func addAxis(name: String, with value:Double) {
        _axes = _axes.map {StyleAxis( name: $0.name, edges: $0.edges+$0.edges)}

        let newAxis = StyleAxis(name: name, edges: Array<Double>(repeating: value, count: numberOfEdges(for: axesCount+1)))
        _axes.append(newAxis)
    }

    public mutating func removeAxis(index:Int) -> Double {
        
        if self.axesCount == 1 {
            let result = self[0,0]
            self._axes = []
            return result
        }
        
        var shortedStyleValues = [[Double]]()
        var removedStyleValues = [[Double]]()
        var axes = _axes

        let removedAxis = axes.remove(at: index)//[_axes.count-1]
        
        for axisNr in 0 ..< axes.count {
            var newEdges = [Double]()
            var removed = [Double]()
            
            for edgeNr in 0 ..< axes[axisNr].count / 2 {
                let first = axes[axisNr][edgeNr]
                
                let egdeIndex = edgeNr + (axes[axisNr].count / 2)
                
                let second = axes[axisNr][egdeIndex]
                
                let thirdIndex = edgeNr.insert(bit: false, at: axisNr)
                let third = removedAxis[thirdIndex]
                
                let offset = 1 << axisNr
                let fourth = removedAxis[thirdIndex + offset]
                let val = cross(x1: first, x2: second, y1: third, y2: fourth)
                
                newEdges.append(val.x)
                removed.append(val.y)
            }
            
            shortedStyleValues.append(newEdges)
            removedStyleValues.append(removed)
         
  
        }
        
        self = MultidimensionalStyle(axes.map {$0.name}, shortedStyleValues)
        
        var removedStyle = MultidimensionalStyle(Array(repeating: "", count: removedStyleValues.count), removedStyleValues)

        var at:Double = Double.nan
        
        while removedStyle.axesCount > 0 {
            at = removedStyle.removeAxis(index: removedStyle.axesCount-1)
        }
        return at

    }

    public var axesCount:Int {
        return _axes.count
    }
    
    public var coordinates:[Double]  {
        var result:[Double] = []
        var e = self
        
        (0..<self.axesCount).forEach{ _ in
            result.append(e.removeAxis(index: 0))
        }

        return result
    }
    

//    func totalEdgesCount(for axes:Int) -> Int {
//        return axes * numberOfEdges(for: axes)
//    }
    
    public var edgesCount:Int  {
//        if axesCount < 1 {
//            fatalError("Axis is less than 0")//EdgesErrors.axesNumberLessThanOne(axes: axes)
//        }
        return _axes[0].edges.count // 1 << (axesCount - 1)
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
}

extension MultidimensionalStyle: CustomStringConvertible {
    public var description: String {
        let axesStr = _axes.reduce(into:"", {output, edges in
            let edgesStr = "\t\(edges.name):" + edges.edges.reduce(into:"\t", {$0 += String(format: "%0.4f, ", $1)})
            output += "\(edgesStr)\n" })
        let coords = coordinates.reduce(into: "\t", {$0 += String(format: "%0.4f, ", $1)})
        return "Style \"\(name)\": \(axesCount) axes\n\tcoords: [\(coords)]\n\(axesStr)"
    }
}

