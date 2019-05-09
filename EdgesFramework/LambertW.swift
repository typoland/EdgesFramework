//
//  LambertW.swift
//  EdgesFramework
//
//  Created by Łukasz Dziedzic on 08/05/2019.
//  translated from https://github.com/thomasluu/plog/blob/master/plog.cu
//

import Foundation

/**
 Lambert W log product fuction.
 - parameter z: Double
 */

func lambertW(z:Double) -> Double {
    
    if z == 0.0 { return 0.0 }
    
    var w0: Double
    var w1: Double = 0
    
    if (z > 0.0) {
        w0 = log(1.2 * z / log(2.4 * z / log1p(2.4 * z)))
    } else {
        let v = 1.4142135623730950488 * sqrt(1 + 2.7182818284590452354 * z);
        let N2 = 10.242640687119285146 + 1.9797586132081854940 * v;
        let N1 = 0.29289321881345247560 * (1.4142135623730950488 + N2);
        w0 = -1.0 + v * (N2 + v) / (N2 + v + N1 * v);
    }
    
    while (true) {
        let e = exp(w0);
        let f = w0 * e - z;
        w1 = w0 + ((f+f) * (1.0 + w0)) / (f * (2.0 + w0) - (e+e) * (1.0 + w0) * (1.0 + w0))
        if (fabs(w0 / w1 - 1.0) < 1.4901161193847656e-8) {
            break
        }
        w0 = w1
    }
    return w1
}
