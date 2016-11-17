//
//  PercentNumberProgressAnimation.swift
//  CrazyMikeSwift
//
//  Created by LEE ZHE YU on 2016/8/8.
//  Copyright © 2016年 B1-Media. All rights reserved.
//

import UIKit

class PercentNumberProgressAnimation: BaseProgressAnimation, BmoProgressHelpProtocol {
    var darkerView = BmoProgressHelpView()
    var containerView: BmoProgressHelpView!
    var containerViewMaskLayer = CAShapeLayer()
    var newImageView = BmoProgressImageView()
    let percentLabel = UILabel()
    var percentNumber = 0
    
    var borderShape: Bool!
    
    convenience init(imageView: UIImageView, newImage: UIImage?) {
        self.init()
        
        self.imageView = imageView
        self.newImage = newImage
        self.percentFont = UIFont.systemFont(ofSize: 18.0)
        self.containerView = BmoProgressHelpView(delegate: self)
        
        self.resetAnimation().closure()
    }
    
    // MARK : - Override
    override func displayLinkAction(_ dis: CADisplayLink) {
        if let helpPoint = helpPointView.layer.presentation()?.bounds.origin {
            if helpPoint.x == CGFloat(self.progress.fractionCompleted) {
                self.displayLink?.invalidate()
                self.displayLink = nil
            }
            if Int(helpPoint.x * 100) > percentNumber {
                percentNumber = Int(helpPoint.x * 100)
                self.percentLabel.text = "\(String(self.percentNumber)) %"
            }
        }
    }
    override func successAnimation(_ imageView: UIImageView) {
        percentLabel.removeFromSuperview()
        UIView.transition(
            with: imageView,
            duration: self.transitionDuration,
            options: .transitionCrossDissolve,
            animations: {
                self.newImageView.image = self.newImage
            }, completion: { (finished) in
                var maskPath: UIBezierPath!
                if let maskLayer = imageView.layer.mask as? CAShapeLayer, maskLayer.path != nil {
                    maskPath = UIBezierPath(cgPath: maskLayer.path!)
                } else {
                    maskPath = UIBezierPath(rect: imageView.bounds)
                }
                self.containerViewMaskLayer.path = maskPath.cgPath
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    self.imageView?.image = self.newImage
                    self.completionBlock?(.success(self.newImage))
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
                animateEnlarge.fromValue = NSValue(caTransform3D: transform3D)
                self.containerViewMaskLayer.add(animateEnlarge, forKey: "enlarge")
                CATransaction.commit()
            }
        )
    }
    override func failureAnimation(_ imageView: UIImageView, error: NSError?) {
        UIView.animate(withDuration: self.transitionDuration, animations: {
            self.darkerView.alpha = 0.0
            self.newImageView.alpha = 0.0
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
        
        if strongImageView.image != nil {
            darkerView.backgroundColor = UIColor.black
            darkerView.alpha = 0.4
        } else {
            darkerView.backgroundColor = UIColor.white
        }
        strongImageView.addSubview(darkerView)
        darkerView.autoFit(strongImageView)
        
        strongImageView.addSubview(containerView)
        containerView.autoFit(strongImageView)
        
        if let maskLayer = strongImageView.layer.mask as? CAShapeLayer, maskLayer.path != nil {
            containerViewMaskLayer.path = maskLayer.path!.insetPath(marginPercent)
        } else {
            containerViewMaskLayer.path = CGPath(rect: strongImageView.bounds, transform: nil).insetPath(marginPercent)
        }
        containerView.layer.mask = containerViewMaskLayer
        
        newImageView.contentMode = strongImageView.contentMode
        newImageView.layer.masksToBounds = strongImageView.layer.masksToBounds
        containerView.addSubview(newImageView)
        newImageView.autoFit(containerView)
        if let image = newImage {
            newImageView.image = image
        }
        
        percentLabel.backgroundColor = UIColor.clear
        percentLabel.textColor = progressColor
        percentLabel.textAlignment = NSTextAlignment.center
        percentLabel.font = percentFont
        percentLabel.minimumScaleFactor = 0.1
        containerView.addSubview(percentLabel)
        percentLabel.autoFit(containerView)
        return self
    }
    
    //MARK: - ProgressHelpProtocol
    func layoutChanged(_ target: AnyObject) {
        guard let strongImageView = self.imageView else {
            return
        }
        if let maskLayer = strongImageView.layer.mask as? CAShapeLayer, maskLayer.path != nil {
            containerViewMaskLayer.path = maskLayer.path!.insetPath(marginPercent)
        } else {
            containerViewMaskLayer.path = CGPath(rect: strongImageView.bounds, transform: nil).insetPath(marginPercent)
        }
    }
}
