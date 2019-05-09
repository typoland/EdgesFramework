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
    override func awakeFromNib() {
        print ("SCN awaked")
        backgroundColor = NSColor.brown
    }
}
