//
//  EdgesView.swift
//  edgesTest
//
//  Created by Łukasz Dziedzic on 09/05/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation
import SceneKit
class EdgesView: SCNView {
    var cursorGeom: SCNBox!
    var cursorNode: SCNNode!
    override func awakeFromNib() {
        cursorGeom = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        cursorNode = SCNNode(geometry: cursorGeom)
        cursorNode.name = "cursor"
        cursorGeom.firstMaterial?.diffuse.contents = NSColor.green
        print ("SCN awaked")
        scene = SCNScene.init(named: "testScene.scn")
        allowsCameraControl = true
        scene?.rootNode.addChildNode(cursorNode)
        print (scene)
    }
   
    
    override func mouseDown(with event: NSEvent) {
        let point = convert(event.locationInWindow, to: nil)
        let r = hitTest(point, options: [SCNHitTestOption.firstFoundOnly : true])
        print (r)
        
    }
}
