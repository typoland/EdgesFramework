import Foundation

import EdgesFramework
import SceneKit

public class EdgesView: SCNView {
    
    public var edges:Edges = Edges(0.8)
    
    override public func awakeFromNib() {
        print ("awake from nib")
    }
}
