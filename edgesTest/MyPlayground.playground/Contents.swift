import Cocoa

var str = "Hello, playground"

import EdgesFramework

var z = MultidimensionalStyle()
z.addAxis(name: "Bold", with:  0.6)
z.addAxis(name: "Regular", with: 0.2)
z.addAxis(name: "Text", with: 0.9)
z.addAxis(name: "Swash", with: 0.3)
z.addAxis(name: "Swash", with: 0.5)
z.addAxis(name: "Ryba", with: 0.4)

z[2,7] = 0.1
z[3,6] = 0.9


print (z.coordinates, z.axesCount, z.edgesCount)

