//
//  BmoShapeLayer.swift
//  CrazyMikeSwift
//
//  Created by LEE ZHE YU on 2016/8/2.
//  Copyright © 2016年 B1-Media. All rights reserved.
//

import UIKit

struct BmoShapeHelper {
    static func getShapePath(shape: BmoImageViewShape, rect: CGRect) -> CGPath {
        switch shape {
        case .RoundedRect(let corner):
            return CGPathCreateWithRoundedRect(rect, corner, corner, nil)
        case .Triangle:
            let path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, rect.midX, rect.minY)
            CGPathAddLineToPoint(path, nil, rect.minX, rect.maxY)
            CGPathAddLineToPoint(path, nil, rect.maxX, rect.maxY)
            CGPathCloseSubpath(path)
            return path
        case .Pentagon:
            let adjustment = CGFloat(360 / 5 / 4)
            let path = CGPathCreateMutable()
            let radius = min(rect.width, rect.height) / 2
            let startPoint = CGPoint(x: rect.midX, y: rect.midY)
            let points = polygonPointsArray(5, x: startPoint.x, y: startPoint.y, radius: radius, adjustment: adjustment)
            CGPathMoveToPoint(path, nil, points[0].x, points[0].y)
            for p in points {
                CGPathAddLineToPoint(path, nil, p.x, p.y)
            }
            CGPathCloseSubpath(path)
            return path
        case .Ellipse:
            return CGPathCreateWithEllipseInRect(rect, nil)
        case .Circle:
            let path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, rect.midX, rect.minY)
            CGPathAddArc(path, nil, rect.midX, rect.midY, min(rect.width, rect.height) / 2, CGFloat(-1 * M_PI_2), CGFloat(M_PI_2 * 3), false)
            return path
        case .Heart:
            let path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, rect.midX, rect.minY + rect.height / 4)
            CGPathAddCurveToPoint(path, nil,
                                  rect.midX - rect.width / 16, rect.minY,
                                  rect.minX, rect.minY,
                                  rect.minX + rect.width / 16, rect.midY)
            CGPathAddCurveToPoint(path, nil,
                                  rect.minX + rect.width / 8, rect.midY + rect.height * 3 / 8,
                                  rect.midX - rect.width / 16, rect.maxY - rect.height / 16,
                                  rect.midX, rect.maxY)
            CGPathAddCurveToPoint(path, nil,
                                  rect.midX + rect.width / 16, rect.maxY - rect.height / 16,
                                  rect.maxX - rect.width / 8, rect.midY + rect.height * 3 / 8,
                                  rect.maxX - rect.width / 16, rect.midY)
            CGPathAddCurveToPoint(path, nil,
                                  rect.maxX, rect.minY,
                                  rect.midX + rect.width / 16, rect.minY,
                                  rect.midX, rect.minY + rect.height / 4)
            CGPathCloseSubpath(path)
            return path
        case .Star:
            let adjustment_outside = CGFloat(360 / 5 / 4)
            let adjustment_inside = CGFloat(360 / 5 / 4) - CGFloat(360 / 5 / 2)
            let path = CGPathCreateMutable()
            let radius = min(rect.width, rect.height) / 2
            let startPoint = CGPoint(x: rect.midX, y: rect.midY)
            let points_outside = polygonPointsArray(5, x: startPoint.x, y: startPoint.y, radius: radius, adjustment: adjustment_outside)
            let points_inside = polygonPointsArray(5, x: startPoint.x, y: startPoint.y, radius: radius / 2, adjustment: adjustment_inside)
            var i = 0
            CGPathMoveToPoint(path, nil, points_outside[0].x, points_outside[0].y)
            for p in points_outside {
                CGPathAddLineToPoint(path, nil, p.x, p.y)
                CGPathAddLineToPoint(path, nil, points_inside[i].x, points_inside[i].y)
                i += 1
            }
            CGPathCloseSubpath(path)
            return path
        }
    }
    
    static func polygonPointsArray(sides: Int, x: CGFloat, y: CGFloat, radius: CGFloat, adjustment: CGFloat = 0) -> [CGPoint] {
        let angle = degreeToRadians(360 / CGFloat(sides))
        var points = [CGPoint]()
        var i = sides
        while points.count <= sides {
            let x = x - radius * cos(angle * CGFloat(i) + degreeToRadians(adjustment))
            let y = y - radius * sin(angle * CGFloat(i) + degreeToRadians(adjustment))
            points.append(CGPoint(x: x, y: y))
            i -= 1
        }
        return points
    }
    
    static func degreeToRadians(value: CGFloat) -> CGFloat {
        return CGFloat(M_PI) * value / 180.0
    }
    static func radiansToDegrees(value: CGFloat) -> CGFloat {
        return value * 180.0 / CGFloat(M_PI)
    }
}
