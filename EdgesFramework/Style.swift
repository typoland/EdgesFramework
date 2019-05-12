//
//  edges.swift
//  EdgesFramework
//
//  Created by Łukasz Dziedzic on 08/05/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation

public struct Style {
    
    struct Axis {
        
        var name: String = ""
        var edges: [Edge] = []
        
        init() {
        }
        
        init (name: String, edges : [Double]) {
            self.name = name
            self.edges =  edges.map {Edge(value: $0)}
        }
        
        init (name: String, edges: [Edge]) {
            self.name = name
            self.edges = edges
        }
        
        subscript (i: Int) -> Edge {
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
    
    struct Edge {
        var value:Double = 0
        
        public init (value: Double) {
            self.value = value
        }
    }
    
    
    enum EdgesErrors:Error {
        case wrongEdgesNumber(edges: Int)
        case axesNumberLessThanOne(axes: Int)
    }

    private var _axes: [Axis] = []
    public var name:String {
        return _axes.reduce(into: "", {$0 += $1.name})
    }
    
    public init () {}
    
    public init (_ name:String, value: Double) {
        _axes = [Axis( name: name, edges: [ Edge(value: value) ])]
    }

    public init (_ name:String, _ arrays: [Double]) {
        _axes = [Axis(name: name, edges: arrays)]
    }
    
    public init (_ names:[String], _ array: [[Double]]) {
        _axes = (0..<array.count).map {Axis( name: names[$0], edges: array[$0])}
    }
    
    init (axes: [Axis]) {
        _axes = axes
    }
    
    init (_ names:[String], edges: [[Edge]]) {
        _axes = (0..<edges.count).map { Axis(name: names[$0], edges: edges[$0] )}
    }
    
    
    
    public subscript (axisNr:Int, edgeNr:Int) -> Double {
        get {
            return _axes[axisNr][edgeNr].value
        }
        set {
            _axes[axisNr][edgeNr].value = newValue
        }
    }
    
    mutating public func addAxis(name: String, with value:Double) {

        _axes = _axes.map {Axis( name: $0.name, edges: $0.edges+$0.edges)}

        let newAxis = Axis(name: name, edges: Array<Double>(repeating: value, count: numberOfEdges(for: axesCount+1)))
        _axes.append(newAxis)
        
        //for debug only:
//                (0..<_axes.count).forEach{ axisNr in
//                    (0..<_axes[axisNr].count).forEach({
//                        _axes[axisNr][$0] = Double($0)/50.0 + Double(axisNr)/10.0
//                    })
//                }
    }
    
    var coords = [Double]()
    
    public mutating func removeAxis(index:Int) -> Double {
        
        if self.axesCount == 1 {
            var result = self[0,0]
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
                let first = axes[axisNr][edgeNr].value
                
                let egdeIndex = edgeNr + (axes[axisNr].count / 2)
                
                let second = axes[axisNr][egdeIndex].value
                
                let thirdIndex = edgeNr.insert(bit: false, at: axisNr)
                let third = removedAxis[thirdIndex].value
                
                let offset = 1 << axisNr
                let fourth = removedAxis[thirdIndex + offset].value
                let val = cross(x1: first, x2: second, y1: third, y2: fourth)
                
                newEdges.append(val.x) // val.x)
                removed.append(val.y)
                
                
            }
            
            shortedStyleValues.append(newEdges)
            removedStyleValues.append(removed)
         
  
        }
        
        self = Style(axes.map {$0.name}, shortedStyleValues)
        
        
        var removedStyle = Style(Array(repeating: "", count: removedStyleValues.count), removedStyleValues)
        
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
    
//        (0..<self.axesCount-1).forEach{ _ in
//            result.append(e.removeAxis(index: 0)[0,0])
      
//        return result
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
}

extension Style: CustomStringConvertible {
    public var description: String {
        let axesStr = _axes.reduce(into:"", {output, edges in
            let edgesStr = "\t\(edges.name):" + edges.edges.reduce(into:"\t", {$0 += String(format: "%0.4f, ", $1.value)})
            output += "\(edgesStr)\n" })
        let coords = coordinates.reduce(into: "\t", {$0 += String(format: "%0.4f, ", $1)})
        return "Style \"\(name)\": \(axesCount) axes,\n\(axesStr)\n\tcoords: [\(coords)]"
    }
}

