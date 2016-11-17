//
//  BmoPathExtention.swift
//  CrazyMikeSwift
//
//  Created by LEE ZHE YU on 2016/8/6.
//  Copyright © 2016年 B1-Media. All rights reserved.
//

import UIKit

extension CGPath {
    func insetPath(_ percent: CGFloat) -> CGPath {
        let path = UIBezierPath(cgPath: self)
        let translatePoint = CGPoint(x: path.bounds.width * percent / 2 + path.bounds.origin.x * percent,
                                     y: path.bounds.height * percent / 2 + path.bounds.origin.y * percent)
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: translatePoint.x, y: translatePoint.y)
        transform = transform.scaledBy(x: 1 - percent, y: 1 - percent)
        path.apply(transform)

        return path.cgPath
    }
}
