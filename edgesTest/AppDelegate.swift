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
        sceneView.scene = SCNScene.init()
        
        var e = Edges(0.2)
        e.addAxis(with: 0.3)
        e.addAxis(with: 0.4)
        e.addAxis(with: 0.5)

        var lines  = [SCNNode]()
        for axisIndex in 0..<e.axesCount {
            var values = [SCNVector3]()
            for edgeIndex in 0..<e.edgesCount {
                let points = e.edgePoints(axis: axisIndex, edge: edgeIndex)
                let start = e.convertTo3D(leaveAxes: [], coordinates: points.start) * 10.0
                let end = e.convertTo3D(leaveAxes: [], coordinates: points.start) * 10.0
                lines.append( SCNScene.line(from: start, to: end, width: 1, color: NSColor.black))
                
                let value = e.convertTo3D(leaveAxes: [], coordinates: points.value) * 10.0
                values.append(value)
            }
            print()
        }
        guard let rootNode = sceneView.scene?.rootNode else {
            print ("FUCK")
            return
        }
        print ("adding nodes")
        lines.forEach({rootNode.addChildNode($0)})
        print (rootNode.childNodes)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

