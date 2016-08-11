//
//  DefaultIndicatorProgressAnimation.swift
//  CrazyMikeSwift
//
//  Created by LEE ZHE YU on 2016/8/8.
//  Copyright © 2016年 B1-Media. All rights reserved.
//

import UIKit

class DefaultIndicatorProgressAnimation: BaseProgressAnimation, BmoProgressHelpProtocol {
    var darkerView = BmoProgressHelpView()
    var indicator: UIActivityIndicatorView!
    var containerView: BmoProgressHelpView!
    var containerViewMaskLayer = CAShapeLayer()
    var newImageView = BmoProgressImageView()
    
    var borderShape: Bool!
    
    convenience init(imageView: UIImageView, newImage: UIImage?, indicatorStyle: UIActivityIndicatorViewStyle) {
        self.init()
        
        self.indicator = UIActivityIndicatorView(activityIndicatorStyle: indicatorStyle)
        self.containerView = BmoProgressHelpView(delegate: self)
        self.imageView = imageView
        self.newImage = newImage
        
        resetAnimation()
    }
    
    // MARK : - Override
    override func displayLinkAction(dis: CADisplayLink) {
        if !indicator.isAnimating() {
            indicator.startAnimating()
        }
        if let helpPoint = helpPointView.layer.presentationLayer()?.bounds.origin {
            if helpPoint.x == CGFloat(self.progress.fractionCompleted) {
                self.indicator.stopAnimating()
                self.displayLink?.invalidate()
                self.displayLink = nil
            }
        }
    }
    override func successAnimation(imageView: UIImageView) {
        indicator.stopAnimating()
        UIView.transitionWithView(
            imageView,
            duration: self.transitionDuration,
            options: .TransitionCrossDissolve,
            animations: {
                self.newImageView.image = self.newImage
            }, completion: { (finished) in
                var maskPath: UIBezierPath!
                if let maskLayer = imageView.layer.mask as? CAShapeLayer where maskLayer.path != nil {
                    maskPath = UIBezierPath(CGPath: maskLayer.path!)
                } else {
                    maskPath = UIBezierPath(rect: imageView.bounds)
                }
                self.containerViewMaskLayer.path = maskPath.CGPath
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    self.imageView?.image = self.newImage
                    self.completionBlock?(.Success(self.newImage))
                    imageView.bmo_removeProgressAnimation()
                })
                let animateEnlarge = CABasicAnimation(keyPath: "transform")
                let translatePoint = CGPoint(
                    x: maskPath.bounds.width * self.marginPercent / 2 + maskPath.bounds.origin.x * self.marginPercent,
                    y: maskPath.bounds.height * self.marginPercent / 2 + maskPath.bounds.origin.y * self.marginPercent)
                var transform3D = CATransform3DIdentity
                transform3D = CATransform3DTranslate(transform3D, translatePoint.x, translatePoint.y, 0)
                transform3D = CATransform3DScale(transform3D, 1 - self.marginPercent, 1 - self.marginPercent, 1)
                animateEnlarge.duration = self.enlargeDuration
                animateEnlarge.fromValue = NSValue(CATransform3D: transform3D)
                self.containerViewMaskLayer.addAnimation(animateEnlarge, forKey: "enlarge")
                CATransaction.commit()
            }
        )
    }
    override func failureAnimation(imageView: UIImageView, error: NSError?) {
        indicator.stopAnimating()
        UIView.animateWithDuration(self.transitionDuration, animations: {
            self.darkerView.alpha = 0.0
            self.newImageView.alpha = 0.0
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
        
        if let maskLayer = strongImageView.layer.mask as? CAShapeLayer where maskLayer.path != nil {
            containerViewMaskLayer.path = maskLayer.path!.insetPath(marginPercent)
        } else {
            containerViewMaskLayer.path = CGPathCreateWithRect(strongImageView.bounds, nil).insetPath(marginPercent)
        }
        containerView.layer.mask = containerViewMaskLayer
        
        if let image = newImage {
            newImageView.image = image
        }
        
        containerView.addSubview(indicator)
        indicator.autoFitCenter(containerView)
        indicator.center = CGPoint(x: strongImageView.bounds.midX, y: strongImageView.bounds.midY)
        indicator.hidesWhenStopped = true
        return self
    }
    
    //MARK: - ProgressHelpProtocol
    func layoutChanged(target: AnyObject) {
        guard let strongImageView = self.imageView else {
            return
        }
        if let maskLayer = strongImageView.layer.mask as? CAShapeLayer where maskLayer.path != nil {
            containerViewMaskLayer.path = maskLayer.path!.insetPath(marginPercent)
        } else {
            containerViewMaskLayer.path = CGPathCreateWithRect(strongImageView.bounds, nil).insetPath(marginPercent)
        }
    }
}
