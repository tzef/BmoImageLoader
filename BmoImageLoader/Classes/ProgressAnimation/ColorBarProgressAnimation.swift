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
    var position = BmoProgressPosition.positionCenter
    let barHeight = 3
    
    convenience init(imageView: UIImageView, newImage: UIImage?, position: BmoProgressPosition) {
        self.init()
        
        self.imageView = imageView
        self.newImage = newImage
        self.position = position
        
        progressColor = UIColor(red: 6.0/255.0, green: 125.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.resetAnimation().closure()
    }
    
    // MARK : - Override
    override func displayLinkAction(_ dis: CADisplayLink) {
        if let helpPoint = helpPointView.layer.presentation()?.bounds.origin {
            if helpPoint.x == CGFloat(self.progress.fractionCompleted) {
                self.displayLink?.invalidate()
                self.displayLink = nil
            }
            let width = fillBarView.bounds.width * helpPoint.x
            fillBarMaskLayer.path = CGPath(rect: CGRect(x: 0, y: 0, width: width, height: fillBarView.bounds.height), transform: nil)
        }
    }
    override func successAnimation(_ imageView: UIImageView) {
        self.fillBarView.removeFromSuperview()
        UIView.transition(
            with: imageView,
            duration: self.transitionDuration,
            options: .transitionCrossDissolve,
            animations: {
                self.newImageView.image = self.newImage
            }, completion: { (finished) in
                imageView.image = self.newImage
                UIView.animate(withDuration: self.transitionDuration, animations: {
                    self.darkerView.alpha = 0.0
                    self.newImageView.alpha = 0.0
                }, completion: { (finished) in
                    self.imageView?.image = self.newImageView.image
                    self.completionBlock?(.success(self.newImage))
                    imageView.bmo_removeProgressAnimation()
                })
            }
        )
    }
    override func failureAnimation(_ imageView: UIImageView, error: NSError?) {
        self.fillBarView.removeFromSuperview()
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
        case .positionTop:
            fillBarView.autoFitTop(containerView, height: CGFloat(barHeight))
        case .positionCenter:
            fillBarView.autoFitCenterVertical(containerView, height: CGFloat(barHeight))
        case .positionBottom:
            fillBarView.autoFitBottom(containerView, height: CGFloat(barHeight))
        }
        fillBarMaskLayer.path = CGMutablePath()
        
        if let image = newImage {
            newImageView.image = image
            darkerView.backgroundColor = UIColor.black
            darkerView.alpha = 0.4
        }
        
        return self
    }
}

