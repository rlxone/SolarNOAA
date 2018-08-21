//
//  FloatingPoint+Degrees.swift
//  Test
//
//  Created by Dmitry Medyuho on 8/21/18.
//  Copyright © 2018 rlxone. All rights reserved.
//

import Foundation

extension FloatingPoint {
    var degToRad: Self { return self * .pi / 180 }
    var radToDeg: Self { return self * 180 / .pi }
}
