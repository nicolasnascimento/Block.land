//
//  CoreGraphicsExtensions.swift
//  Block.land
//
//  Created by Nicolas Nascimento on 17/01/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import CoreGraphics

// CGSize + length
struct CGSize3 {
    var width: CGFloat
    var height: CGFloat
    var length: CGFloat
}

extension CGSize3: Equatable {
    static func == (lhs: CGSize3, rhs: CGSize3) -> Bool {
        return lhs.height == rhs.height && lhs.width == rhs.width && lhs.length == rhs.length
    }
}

extension CGSize3: Hashable {
    var hashValue: Int {
        return self.width.hashValue + self.height.hashValue + self.length.hashValue
    }
}
