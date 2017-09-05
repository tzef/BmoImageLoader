//
//  CircleFillProgressAnimation.swift
//  CrazyMikeSwift
//
//  Created by LEE ZHE YU on 2016/8/7.
//  Copyright © 2016年 B1-Media. All rights reserved.
//

import UIKit

class CircleFillProgressAnimation: BaseProgressAnimation, BmoProgressHelpProtocol {
    var darkerView = BmoProgressHelpView()
    var containerView: BmoProgressHelpView!
    var containerViewMaskLayer = CAShapeLayer()
    var newImageView = BmoProgressImageView()
    let newImageViewMaskLayer = CAShapeLayer()
    
    var borderShape: Bool!
    var fillPath: CGPath!
    var insetPath: CGPath!

    convenience init(imageView: UIImageView, newImage: UIImage?, borderShape: Bool) {
        self.init()

        self.borderShape = borderShape
        self.imageView = imageView
        self.newImage = newImage
        self.containerView = BmoProgressHelpView(delegate: self)

        marginPercent = 0.9
        self.resetAnimation().closure()
    }

    // MARK : - Override
    override func displayLinkAction(_ dis: CADisplayLink) {
        if let helpPoint = helpPointView.layer.presentation()?.bounds.origin {
            let percent = helpPoint.x
            if percent == CGFloat(self.progress.fractionCompleted) {
                self.displayLink?.invalidate()
                self.displayLink = nil
            }
            containerViewMaskLayer.path = fillPath.insetPath(marginPercent * (1 - percent))
        }
    }
    override func successAnimation(_ imageView: UIImageView) {
        imageView.image = self.newImage
        UIView.animate(withDuration: self.transitionDuration, animations: {
            self.darkerView.alpha = 0.0
            }, completion: { (finished) in
                self.completionBlock?(.success(self.newImage))
                imageView.bmo_removeProgressAnimation()
        })
    }
    override func failureAnimation(_ imageView: UIImageView, error: NSError?) {
        UIView.animate(withDuration: self.transitionDuration, animations: {
            self.darkerView.alpha = 0.0
        }, completion: { (finished) in
            if finished {
                self.completionBlock?(.failure(error))
                imageView.bmo_removeProgressAnimation()
            }
        })
    }

    //MARK: - ProgressAnimator Protocol
    override func resetAnimation() -> BmoProgressAnimator {
        guard let strongImageView = self.imageView else {
            return self
        }
        strongImageView.layoutIfNeeded()
        strongImageView.bmo_removeProgressAnimation()

        helpPointView.frame = CGRect.zero
        strongImageView.addSubview(helpPointView)

        strongImageView.addSubview(darkerView)
        if strongImageView.image != nil {
            darkerView.backgroundColor = UIColor.black
            darkerView.alpha = 0.4
        } else {
            darkerView.backgroundColor = UIColor.white
        }
        darkerView.autoFit(strongImageView)

        strongImageView.addSubview(containerView)
        containerView.autoFit(strongImageView)

        newImageView.contentMode = strongImageView.contentMode
        newImageView.layer.masksToBounds = strongImageView.layer.masksToBounds
        containerView.addSubview(newImageView)
        newImageView.autoFit(containerView)

        if borderShape == true {
            if let maskLayer = strongImageView.layer.mask as? CAShapeLayer, maskLayer.path != nil {
                fillPath = maskLayer.path!
            } else {
                fillPath = CGPath(rect: strongImageView.bounds, transform: nil)
            }
            containerViewMaskLayer.path = fillPath.insetPath(marginPercent)
        } else {
            let path = CGMutablePath()
            let radius = sqrt(pow(strongImageView.bounds.width / 2, 2) + pow(strongImageView.bounds.height / 2, 2))
            path.move(to: CGPoint(x: strongImageView.bounds.midX, y: strongImageView.bounds.midY - radius))
            path.addArc(center: CGPoint(x: strongImageView.bounds.midX, y: strongImageView.bounds.midY), radius: radius, startAngle: CGFloat(-1 * Double.pi/2), endAngle: CGFloat(Double.pi/2 * 3), clockwise: false)
            fillPath = path
            containerViewMaskLayer.path = path.insetPath(marginPercent)
        }
        containerViewMaskLayer.fillColor = UIColor.black.cgColor
        containerView.layer.mask = containerViewMaskLayer

        if let image = newImage {
            newImageView.image = image
        } else {
            newImageView.backgroundColor = progressColor
        }
        newImageView.backgroundColor = UIColor.black
        return self
    }
    
    //MARK: - ProgressHelpProtocol
    func layoutChanged(_ target: AnyObject) {
        guard let strongImageView = self.imageView else {
            return
        }
        if let maskLayer = strongImageView.layer.mask as? CAShapeLayer, maskLayer.path != nil {
            fillPath = maskLayer.path!
        } else {
            fillPath = CGPath(rect: strongImageView.bounds, transform: nil)
        }
    }
}

