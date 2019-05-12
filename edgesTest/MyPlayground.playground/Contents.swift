import Cocoa

var str = "Hello, playground"

import EdgesFramework

var z = Style()
z.addAxis(name: "Bold", with:  0.6)
z.addAxis(name: "Regular", with: 0.2)
z.addAxis(name: "Text", with: 0.7)




print (z.coordinates)

