//
//  Extensions.swift
//  EdgesFramework
//
//  Created by Łukasz Dziedzic on 08/05/2019.
//  Copyright © 2019 Łukasz Dziedzic. All rights reserved.
//

import Foundation

extension Double {
    var plog:Double {
        return lambertW(z: self)
    }
}
extension Int {
    func insert(bit:Bool, at:Int) -> Int {
        let lowMask = at > 0 ? (1 << (at)) - 1 : 0// 00@111
        let low = self & lowMask
        let up = (((self >> at) << 1) ^ (bit ? 1 : 0)) << (at)
        return up | low
    }
}
