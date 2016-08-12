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
        resetAnimation()
    }

    // MARK : - Override
    override func displayLinkAction(dis: CADisplayLink) {
        if let helpPoint = helpPointView.layer.presentationLayer()?.bounds.origin {
            let percent = helpPoint.x
            if percent == CGFloat(self.progress.fractionCompleted) {
                self.displayLink?.invalidate()
                self.displayLink = nil
            }
            containerViewMaskLayer.path = fillPath.insetPath(marginPercent * (1 - percent))
        }
    }
    override func successAnimation(imageView: UIImageView) {
        imageView.image = self.newImage
        UIView.animateWithDuration(self.transitionDuration, animations: {
            self.darkerView.alpha = 0.0
            }, completion: { (finished) in
                self.completionBlock?(.Success(self.newImage))
                imageView.bmo_removeProgressAnimation()
        })
    }
    override func failureAnimation(imageView: UIImageView, error: NSError?) {
        UIView.animateWithDuration(self.transitionDuration, animations: {
            self.darkerView.alpha = 0.0
        }, completion: { (finished) in
            if finished {
                self.completionBlock?(.Failure(error))
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

        helpPointView.frame = CGRectZero
        strongImageView.addSubview(helpPointView)

        strongImageView.addSubview(darkerView)
        if strongImageView.image != nil {
            darkerView.backgroundColor = UIColor.blackColor()
            darkerView.alpha = 0.4
        } else {
            darkerView.backgroundColor = UIColor.whiteColor()
        }
        darkerView.autoFit(strongImageView)

        strongImageView.addSubview(containerView)
        containerView.autoFit(strongImageView)

        newImageView.contentMode = strongImageView.contentMode
        newImageView.layer.masksToBounds = strongImageView.layer.masksToBounds
        containerView.addSubview(newImageView)
        newImageView.autoFit(containerView)

        if borderShape == true {
            if let maskLayer = strongImageView.layer.mask as? CAShapeLayer where maskLayer.path != nil {
                fillPath = maskLayer.path!
            } else {
                fillPath = CGPathCreateWithRect(strongImageView.bounds, nil)
            }
            containerViewMaskLayer.path = fillPath.insetPath(marginPercent)
        } else {
            let path = CGPathCreateMutable()
            let radius = sqrt(pow(strongImageView.bounds.width / 2, 2) + pow(strongImageView.bounds.height / 2, 2))
            CGPathMoveToPoint(path, nil, strongImageView.bounds.midX, strongImageView.bounds.midY - radius)
            CGPathAddArc(path, nil, strongImageView.bounds.midX, strongImageView.bounds.midY, radius, CGFloat(-1 * M_PI_2), CGFloat(M_PI_2 * 3), false)
            fillPath = path
            containerViewMaskLayer.path = path.insetPath(marginPercent)
        }
        containerViewMaskLayer.fillColor = UIColor.blackColor().CGColor
        containerView.layer.mask = containerViewMaskLayer

        if let image = newImage {
            newImageView.image = image
        } else {
            newImageView.backgroundColor = progressColor
        }
        newImageView.backgroundColor = UIColor.blackColor()
        return self
    }
    
    //MARK: - ProgressHelpProtocol
    func layoutChanged(target: AnyObject) {
        guard let strongImageView = self.imageView else {
            return
        }
        if let maskLayer = strongImageView.layer.mask as? CAShapeLayer where maskLayer.path != nil {
            fillPath = maskLayer.path!
        } else {
            fillPath = CGPathCreateWithRect(strongImageView.bounds, nil)
        }
    }
}

