//: A Cocoa based Playground to present user interface
import Foundation
import AppKit
import PlaygroundSupport

let nibFile = NSNib.Name("MyView")
var topLevelObjects : NSArray?
let height = CGFloat(500.0)
let width = CGFloat(500.0)

Bundle.main.loadNibNamed(nibFile, owner:nil, topLevelObjects: &topLevelObjects)
let views = (topLevelObjects as! Array<Any>).filter { $0 is NSView }

print (views)

//let view = (views[0] as! NSView) as! EdgesView

let view = EdgesView(frame: NSMakeRect(0, 0, width, height))
view.backgroundColor = NSColor.black
// Present the view in Playground
PlaygroundPage.current.liveView = view //views[0] as! NSView

view.edges.addAxis(with: 0.4)
view.edges.addAxis(with: 0.2)
view.edges[0, 0] = 0.2
view.edges[0, 1] = 0.5
view.edges[0, 2] = 0.3
view.edges[0, 3] = 0.7

view.edges[1, 0] = 0.1
view.edges[1, 1] = 0.8
view.edges[1, 2] = 0.2
view.edges[1, 3] = 0.9

view.edges[2, 0] = 0.4
view.edges[2, 1] = 0.5
view.edges[2, 2] = 0.9
view.edges[2, 3] = 1.0

var e1 = view.edges
var e2 = view.edges
var e3 = view.edges


print (view.edges)

print ("e1 (0,0)", e1)
e1.removeAxis(index: 0)
print (e1)
e1.removeAxis(index: 0)
print (e1)

print ("e2 (2,1)", e2)
e2.removeAxis(index: 2)
print (e2)
e2.removeAxis(index: 1)
print (e2)

print ("e3 (1,1)", e3)
e3.removeAxis(index: 1)
print (e3)
e3.removeAxis(index: 1)
print (e3)


