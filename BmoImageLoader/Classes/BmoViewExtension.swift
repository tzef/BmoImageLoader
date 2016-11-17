//
//  BmoViewExtension.swift
//  CrazyMikeSwift
//
//  Created by LEE ZHE YU on 2016/8/9.
//  Copyright © 2016年 B1-Media. All rights reserved.
//

import UIKit

extension UIView {
    func autoFitCenter(_ toView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        var layoutConstraints = [NSLayoutConstraint]()
        layoutConstraints.append(
            NSLayoutConstraint.init(item: self, attribute: .centerX, relatedBy: .equal,
                toItem: toView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint.init(item: self, attribute: .centerY, relatedBy: .equal,
                toItem: toView, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0))
        NSLayoutConstraint.activate(layoutConstraints)
    }
    func autoFitCenterVertical(_ toView: UIView, height: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        var layoutConstraints = [NSLayoutConstraint]()
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal,
                toItem: toView, attribute: .leading, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal,
                toItem: toView, attribute: .trailing, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint.init(item: self, attribute: .centerY, relatedBy: .equal,
                toItem: toView, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: .equal,
                toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
        )
        NSLayoutConstraint.activate(layoutConstraints)
    }
    func autoFitTop(_ toView: UIView, height: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        var layoutConstraints = [NSLayoutConstraint]()
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal,
                toItem: toView, attribute: .leading, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal,
                toItem: toView, attribute: .trailing, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal,
                toItem: toView, attribute: .top, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: .equal,
                toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
        )
        NSLayoutConstraint.activate(layoutConstraints)
    }
    func autoFitBottom(_ toView: UIView, height: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        var layoutConstraints = [NSLayoutConstraint]()
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal,
                toItem: toView, attribute: .leading, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal,
                toItem: toView, attribute: .trailing, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal,
                toItem: toView, attribute: .bottom, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: .equal,
                toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
        )
        NSLayoutConstraint.activate(layoutConstraints)
    }
    func autoFit(_ toView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        var layoutConstraints = [NSLayoutConstraint]()
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal,
                toItem: toView, attribute: .leading, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal,
                toItem: toView, attribute: .trailing, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal,
                toItem: toView, attribute: .top, multiplier: 1.0, constant: 0))
        layoutConstraints.append(
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal,
                toItem: toView, attribute: .bottom, multiplier: 1.0, constant: 0))
        NSLayoutConstraint.activate(layoutConstraints)
    }
}
