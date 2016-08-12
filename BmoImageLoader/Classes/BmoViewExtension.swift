//
//  BmoViewExtension.swift
//  CrazyMikeSwift
//
//  Created by LEE ZHE YU on 2016/8/9.
//  Copyright © 2016年 B1-Media. All rights reserved.
//

import UIKit

extension UIView {
    func autoFitCenter(toView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        var layoutConstraints = [NSLayoutConstraint]()
        layoutConstraints.append(
            NSLayoutConstraint.init(item: self, attribute: .CenterX, relatedBy: .Equal,
                toItem: toView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint.init(item: self, attribute: .CenterY, relatedBy: .Equal,
                toItem: toView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        NSLayoutConstraint.activateConstraints(layoutConstraints)
    }
    func autoFitCenterVertical(toView: UIView, height: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        var layoutConstraints = [NSLayoutConstraint]()
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal,
                toItem: toView, attribute: .Leading, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal,
                toItem: toView, attribute: .Trailing, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint.init(item: self, attribute: .CenterY, relatedBy: .Equal,
                toItem: toView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: .Equal,
                toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: height)
        )
        NSLayoutConstraint.activateConstraints(layoutConstraints)
    }
    func autoFitTop(toView: UIView, height: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        var layoutConstraints = [NSLayoutConstraint]()
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal,
                toItem: toView, attribute: .Leading, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal,
                toItem: toView, attribute: .Trailing, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal,
                toItem: toView, attribute: .Top, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: .Equal,
                toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: height)
        )
        NSLayoutConstraint.activateConstraints(layoutConstraints)
    }
    func autoFitBottom(toView: UIView, height: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        var layoutConstraints = [NSLayoutConstraint]()
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal,
                toItem: toView, attribute: .Leading, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal,
                toItem: toView, attribute: .Trailing, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal,
                toItem: toView, attribute: .Bottom, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: .Equal,
                toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: height)
        )
        NSLayoutConstraint.activateConstraints(layoutConstraints)
    }
    func autoFit(toView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        var layoutConstraints = [NSLayoutConstraint]()
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal,
                toItem: toView, attribute: .Leading, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal,
                toItem: toView, attribute: .Trailing, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal,
                toItem: toView, attribute: .Top, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal,
                toItem: toView, attribute: .Bottom, multiplier: 1.0, constant: 0))
        NSLayoutConstraint.activateConstraints(layoutConstraints)
    }
}