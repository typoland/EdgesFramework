//
//  AppDelegate.swift
//  edgesTest
//
//  Created by Łukasz Dziedzic on 09/05/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Cocoa
import EdgesFramework
import SceneKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var sceneView: EdgesView!
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let dim = 2
        var e = Edges(0.2)
        for i in 0..<dim {
            e.addAxis(with: Double(i)*0.1)
            
        }
        
        let testStyles : [Edges] = []
        
        let al1 = (1...11).map {1-log(Double(12-$0)) / log(11.0)}
        var al2 = (101...111).map {0.6-log(Double(112-$0)) / log(111.0)}
        al2 = al2.map {$0 * 1.667}
        var al3 = (1001...1011).map {0.6-log(Double(1012-$0)) / log(1011.0)}
        al3 = al3.map {($0) * 1}
        var al4 = (501...511).map {0.6-log(Double(512-$0)) / log(511.0)}
        al4 = al4.map {($0) * 1}
        
        
        let logStyles = (0...10).map{[al2[$0], al1[$0], al3[$0], al4[$0]]}
        print (al1)
        print (al2)
        print (al3)
        print (al4)
        let array10 = [Array(repeating: 0.0, count: 4),
                       Array(repeating: 0.1, count: 4),
                       Array(repeating: 0.2, count: 4),
                       Array(repeating: 0.3, count: 4),
                       Array(repeating: 0.4, count: 4),
                       Array(repeating: 0.5, count: 4),
                       Array(repeating: 0.6, count: 4),
                       Array(repeating: 0.7, count: 4),
                       Array(repeating: 0.8, count: 4),
                       Array(repeating: 0.9, count: 4),
                       Array(repeating: 1.0, count: 4)]
        
        // [[0.0, 0.0, 0.0, 0.0], [0.3, 0.3, 0.3, 0.3], [0.7, 0.7, 0.7, 0.7], [1.0, 1.0, 1.0, 1.0]]
        let axis00 = logStyles
        let axis01 = logStyles//[[0.0, 0.3, 0.3, 0.0], [0.1, 0.8, 0.6, 0.5], [1.0, 1.0, 1.0, 1.0]]//, [0.6, 0.75, 0.75, 0.9]]
        let axis02 = logStyles
        
        let axes = [axis00, axis01, axis02]
        
        
        var result = [[[Double]]]()

    
        func deep (axisNr : Int = 0, edges:[[Double]] = []) {
            if axisNr < axes.count {
                for style in axes[axisNr] {
                    deep(axisNr: axisNr + 1, edges: edges + [style])
                }
            }
            else {
                result.append(edges)
            }
        }
        
        deep()
        
        var styles = [Edges]()
        for array in result {
            styles.append(Edges(array))
        }
        
        guard let rootNode = sceneView.scene?.rootNode else {
            return}
                
            for style in styles {
            let value = style.convertTo3D(leaveAxes: [], coordinates: style.coordinates) * 10.0
            let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
            box.firstMaterial?.diffuse.contents = NSColor.red
            let boxNode = SCNNode.init(geometry: box)
            boxNode.position = value
            rootNode.addChildNode(boxNode)
            
        }
            
        e[0,0] = 0.5
        e[0,1] = 0.5
        e[0,2] = 0.5
        e[0,3] = 0.5
        
        e[1,0] = 0.5
        e[1,1] = 0.4
        e[1,2] = 0.5
        e[1,3] = 0.4
        
        e[2,0] = 0.5
        e[2,1] = 0.5
        e[2,2] = 0.5
        e[2,3] = 0.1
        
        
        
        print ("->",e, e.coordinates)
        //e.addAxis(with: 0.5)
       /*
         var lines  = [SCNNode]()
         var sides = [SCNNode]()
         for axisIndex in 0..<e.axesCount {
         var values = [SCNVector3]()
         for edgeIndex in 0..<e.edgesCount {
         print ("ndexes:", axisIndex, edgeIndex)
         let points = e.edgePoints(axis: axisIndex, edge: edgeIndex)
         let start = e.convertTo3D(leaveAxes: [], coordinates: points.start) * 10.0
         let end = e.convertTo3D(leaveAxes: [], coordinates: points.end) * 10.0
         lines.append( SCNScene.line(from: start, to: end, width: 1, color: NSColor.black))
         
                let value = e.convertTo3D(leaveAxes: [], coordinates: points.value) * 10.0
                let box = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0)
                box.firstMaterial?.diffuse.contents = NSColor.red
                let boxNode = SCNNode.init(geometry: box)
                boxNode.position = value
                sides.append(boxNode)
            }
            
            print()
        }
        guard let rootNode = sceneView.scene?.rootNode else {
            return
        }
        print ("adding nodes")
        lines.forEach({rootNode.addChildNode($0); print($0)})
        sides.forEach({rootNode.addChildNode($0)})
        rootNode.childNodes.forEach{print($0.rotation)}// ?? "no geometry for \($0.name ?? "no named object")")}
      */
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

