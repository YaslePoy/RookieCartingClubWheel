//
//  Vector2D.swift
//  RCCWheel
//
//  Created by Михаил Митрованов on 26.08.2025.
//


//
//  Vector2D.swift
//
//  Created by fewlinesofcode.com on 2/6/19.
//  Copyright © 2019 fewlinesofcode.com All rights reserved.
//

import Foundation

struct Vector2D {
    var x = 0.0, y = 0.0
    
    static let zero = Vector2D(x: 0, y: 0)
}

extension Vector2D: CustomStringConvertible {
    var description: String {
        return "(x: \(x), y: \(y))"
    }
}

extension Vector2D {
    // Vector addition
    static func + (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y + right.y)
    }
    
    // Vector subtraction
    static func - (left: Vector2D, right: Vector2D) -> Vector2D {
        return left + (-right)
    }
    
    // Vector addition assignment
    static func += (left: inout Vector2D, right: Vector2D) {
        left = left + right
    }
    
    // Vector subtraction assignment
    static func -= (left: inout Vector2D, right: Vector2D) {
        left = left - right
    }
    
    // Vector negation
    static prefix func - (vector: Vector2D) -> Vector2D {
        return Vector2D(x: -vector.x, y: -vector.y)
    }
}

infix operator * : MultiplicationPrecedence
infix operator / : MultiplicationPrecedence
infix operator • : MultiplicationPrecedence

extension Vector2D {
    // Scalar-vector multiplication
    static func * (left: Double, right: Vector2D) -> Vector2D {
        return Vector2D(x: right.x * left, y: right.y * left)
    }
    
    static func * (left: Vector2D, right: Double) -> Vector2D {
        return Vector2D(x: left.x * right, y: left.y * right)
    }
    
    // Vector-scalar division
    static func / (left: Vector2D, right: Double) -> Vector2D {
        guard right != 0 else { fatalError("Division by zero") }
        return Vector2D(x: left.x / right, y: left.y / right)
    }
    
    // Vector-scalar division assignment
    static func /= (left: inout Vector2D, right: Double) -> Vector2D {
        guard right != 0 else { fatalError("Division by zero") }
        return Vector2D(x: left.x / right, y: left.y / right)
    }
    
    // Scalar-vector multiplication assignment
    static func *= (left: inout Vector2D, right: Double) {
        left = left * right
    }
}

extension Vector2D {
    // Vector magnitude (length)
    var magnitude: Double {
        return sqrt(x*x + y*y)
    }
    
    // Distance between two vectors
    func distance(to vector: Vector2D) -> Double {
        return (self - vector).magnitude
    }
    
    // Vector normalization
    var normalized: Vector2D {
        return Vector2D(x: x / magnitude, y: y / magnitude)
    }
    
    // Dot product of two vectors
    static func • (left: Vector2D, right: Vector2D) -> Double {
        return left.x * right.x + left.y * right.y
    }
    
    // Angle between two vectors
    // θ = acos(AB)
    func angle(to vector: Vector2D) -> Double {
        return acos(self.normalized • vector.normalized)
    }
}

extension Vector2D: Equatable {
    static func == (left: Vector2D, right: Vector2D) -> Bool {
        return (left.x == right.x) && (left.y == right.y)
    }
}
