//
//  BmoShapeLayer.swift
//  CrazyMikeSwift
//
//  Created by LEE ZHE YU on 2016/8/2.
//  Copyright © 2016年 B1-Media. All rights reserved.
//

import UIKit

struct BmoShapeHelper {
    static func getShapePath(_ shape: BmoImageViewShape, rect: CGRect) -> CGPath {
        switch shape {
        case .roundedRect(let corner):
            return CGPath(roundedRect: rect, cornerWidth: corner, cornerHeight: corner, transform: nil)
        case .triangle:
            let path = CGMutablePath()
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.closeSubpath()
            return path
        case .pentagon:
            let adjustment = CGFloat(360 / 5 / 4)
            let path = CGMutablePath()
            let radius = min(rect.width, rect.height) / 2
            let startPoint = CGPoint(x: rect.midX, y: rect.midY)
            let points = polygonPointsArray(5, x: startPoint.x, y: startPoint.y, radius: radius, adjustment: adjustment)
            path.move(to: CGPoint(x: points[0].x, y: points[0].y))
            for p in points {
                path.addLine(to: CGPoint(x: p.x, y: p.y))
            }
            path.closeSubpath()
            return path
        case .ellipse:
            return CGPath(ellipseIn: rect, transform: nil)
        case .circle:
            let path = CGMutablePath()
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: min(rect.width, rect.height) / 2, startAngle: CGFloat(-1 * Double.pi/2), endAngle: CGFloat(Double.pi/2 * 3), clockwise: false)
            return path
        case .heart:
            let path = CGMutablePath()
            path.move(to: CGPoint(x: rect.midX, y: rect.minY + rect.height / 4))
            path.addCurve(to: CGPoint(x: rect.minX + rect.width / 16, y: rect.midY),
                          control1: CGPoint(x: rect.midX - rect.width / 16, y: rect.minY),
                          control2: CGPoint(x: rect.minX, y: rect.minY))
            path.addCurve(to: CGPoint(x: rect.midX, y: rect.maxY),
                          control1: CGPoint(x: rect.minX + rect.width / 8, y: rect.midY + rect.height * 3 / 8),
                          control2: CGPoint(x: rect.midX - rect.width / 16, y: rect.maxY - rect.height / 16))
            path.addCurve(to: CGPoint(x: rect.maxX - rect.width / 16, y: rect.midY),
                          control1: CGPoint(x: rect.midX + rect.width / 16, y: rect.maxY - rect.height / 16),
                          control2: CGPoint(x: rect.maxX - rect.width / 8, y: rect.midY + rect.height * 3 / 8))
            path.addCurve(to: CGPoint(x: rect.midX, y: rect.minY + rect.height / 4),
                          control1: CGPoint(x: rect.maxX, y: rect.minY),
                          control2: CGPoint(x: rect.midX + rect.width / 16, y: rect.minY))
            path.closeSubpath()
            return path
        case .star:
            let adjustment_outside = CGFloat(360 / 5 / 4)
            let adjustment_inside = CGFloat(360 / 5 / 4) - CGFloat(360 / 5 / 2)
            let path = CGMutablePath()
            let radius = min(rect.width, rect.height) / 2
            let startPoint = CGPoint(x: rect.midX, y: rect.midY)
            let points_outside = polygonPointsArray(5, x: startPoint.x, y: startPoint.y, radius: radius, adjustment: adjustment_outside)
            let points_inside = polygonPointsArray(5, x: startPoint.x, y: startPoint.y, radius: radius / 2, adjustment: adjustment_inside)
            var i = 0
            path.move(to: CGPoint(x: points_outside[0].x, y: points_outside[0].y))
            for p in points_outside {
                path.addLine(to: CGPoint(x: p.x, y: p.y))
                path.addLine(to: CGPoint(x: points_inside[i].x, y: points_inside[i].y))
                i += 1
            }
            path.closeSubpath()
            return path
        }
    }
    
    static func polygonPointsArray(_ sides: Int, x: CGFloat, y: CGFloat, radius: CGFloat, adjustment: CGFloat = 0) -> [CGPoint] {
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
    
    static func degreeToRadians(_ value: CGFloat) -> CGFloat {
        return CGFloat(Double.pi) * value / 180.0
    }
    static func radiansToDegrees(_ value: CGFloat) -> CGFloat {
        return value * 180.0 / CGFloat(Double.pi)
    }
}
