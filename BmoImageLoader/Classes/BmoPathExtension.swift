//
//  BmoPathExtention.swift
//  CrazyMikeSwift
//
//  Created by LEE ZHE YU on 2016/8/6.
//  Copyright © 2016年 B1-Media. All rights reserved.
//

import UIKit

extension CGPath {
    func insetPath(percent: CGFloat) -> CGPath {
        let path = UIBezierPath(CGPath: self)
        let translatePoint = CGPoint(x: path.bounds.width * percent / 2 + path.bounds.origin.x * percent,
                                     y: path.bounds.height * percent / 2 + path.bounds.origin.y * percent)
        var transform = CGAffineTransformIdentity
        transform = CGAffineTransformTranslate(transform, translatePoint.x, translatePoint.y)
        transform = CGAffineTransformScale(transform, 1 - percent, 1 - percent)
        path.applyTransform(transform)

        return path.CGPath
    }
}