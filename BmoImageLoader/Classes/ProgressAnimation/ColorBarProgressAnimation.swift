//
//  ColorBarProgressAnimation.swift
//  CrazyMikeSwift
//
//  Created by LEE ZHE YU on 2016/8/8.
//  Copyright © 2016年 B1-Media. All rights reserved.
//

import UIKit

class ColorBarProgressAnimation: BaseProgressAnimation {
    var darkerView = BmoProgressHelpView()
    var containerView = BmoProgressHelpView()
    var containerViewMaskLayer = CAShapeLayer()
    var newImageView = BmoProgressImageView()
    let fillBarView = BmoProgressHelpView()
    let fillBarMaskLayer = CAShapeLayer()
    var position = BmoProgressPosition.PositionCenter
    let barHeight = 3
    
    convenience init(imageView: UIImageView, newImage: UIImage?, position: BmoProgressPosition) {
        self.init()
        
        self.imageView = imageView
        self.newImage = newImage
        self.position = position
        
        progressColor = UIColor(red: 6.0/255.0, green: 125.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        resetAnimation()
    }
    
    // MARK : - Override
    override func displayLinkAction(dis: CADisplayLink) {
        if let helpPoint = helpPointView.layer.presentationLayer()?.bounds.origin {
            if helpPoint.x == CGFloat(self.progress.fractionCompleted) {
                self.displayLink?.invalidate()
                self.displayLink = nil
            }
            let width = fillBarView.bounds.width * helpPoint.x
            fillBarMaskLayer.path = CGPathCreateWithRect(CGRectMake(0, 0, width, fillBarView.bounds.height), nil)
        }
    }
    override func successAnimation(imageView: UIImageView) {
        self.fillBarView.removeFromSuperview()
        UIView.transitionWithView(
            imageView,
            duration: self.transitionDuration,
            options: .TransitionCrossDissolve,
            animations: {
                self.newImageView.image = self.newImage
            }, completion: { (finished) in
                imageView.image = self.newImage
                UIView.animateWithDuration(self.transitionDuration, animations: {
                    self.darkerView.alpha = 0.0
                    self.newImageView.alpha = 0.0
                }, completion: { (finished) in
                    self.imageView?.image = self.newImageView.image
                    self.completionBlock?(.Success(self.newImage))
                    imageView.bmo_removeProgressAnimation()
                })
            }
        )
    }
    override func failureAnimation(imageView: UIImageView, error: NSError?) {
        self.fillBarView.removeFromSuperview()
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
        darkerView.autoFit(strongImageView)
        
        strongImageView.addSubview(containerView)
        containerView.autoFit(strongImageView)
        
        newImageView.contentMode = strongImageView.contentMode
        newImageView.layer.masksToBounds = strongImageView.layer.masksToBounds
        containerView.addSubview(newImageView)
        newImageView.autoFit(containerView)
        
        fillBarView.backgroundColor = progressColor
        fillBarView.layer.mask = fillBarMaskLayer
        containerView.addSubview(fillBarView)
        switch position {
        case .PositionTop:
            fillBarView.autoFitTop(containerView, height: CGFloat(barHeight))
        case .PositionCenter:
            fillBarView.autoFitCenterVertical(containerView, height: CGFloat(barHeight))
        case .PositionBottom:
            fillBarView.autoFitBottom(containerView, height: CGFloat(barHeight))
        }
        fillBarMaskLayer.path = CGPathCreateMutable()
        
        if let image = newImage {
            newImageView.image = image
            darkerView.backgroundColor = UIColor.blackColor()
            darkerView.alpha = 0.4
        }
        
        return self
    }
}

