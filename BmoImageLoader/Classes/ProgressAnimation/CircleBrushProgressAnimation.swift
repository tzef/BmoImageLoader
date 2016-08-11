//
//  CircleBrushProgressAnimation.swift
//  CrazyMikeSwift
//
//  Created by LEE ZHE YU on 2016/8/7.
//  Copyright © 2016年 B1-Media. All rights reserved.
//

import UIKit

class CircleBrushProgressAnimation: BaseProgressAnimation, BmoProgressHelpProtocol {
    var darkerView = BmoProgressHelpView()
    var containerView: BmoProgressHelpView!
    var containerViewMaskLayer = CAShapeLayer()
    var newImageView = BmoProgressImageView()
    let newImageViewMaskLayer = CAShapeLayer()
    
    var oldImage: UIImage?
    var borderShape: Bool!

    convenience init(imageView: UIImageView, newImage: UIImage?, borderShape: Bool) {
        self.init()

        self.borderShape = borderShape
        self.imageView = imageView
        self.newImage = newImage
        self.oldImage = imageView.image
        self.containerView = BmoProgressHelpView(delegate: self)

        marginPercent = (borderShape ? 0.1 : 0.5)
        resetAnimation()
    }

    // MARK : - Override
    override func displayLinkAction(dis: CADisplayLink) {
        if let helpPoint = helpPointView.layer.presentationLayer()?.bounds.origin {
            if helpPoint.x == CGFloat(self.progress.fractionCompleted) {
                self.displayLink?.invalidate()
                self.displayLink = nil
            }
            let radius = sqrt(pow(newImageView.bounds.width / 2, 2) + pow(newImageView.bounds.height / 2, 2))
            let startAngle = CGFloat(-1 * M_PI_2)
            let circlePath = UIBezierPath(arcCenter: newImageView.center,
                                          radius: radius,
                                          startAngle: startAngle,
                                          endAngle: helpPoint.x * CGFloat(M_PI * 2) + startAngle,
                                          clockwise: true)
            circlePath.addLineToPoint(newImageView.center)
            newImageViewMaskLayer.path = circlePath.CGPath
        }
    }
    override func successAnimation(imageView: UIImageView) {
        if self.borderShape == false {
            imageView.image = self.newImage
            UIView.animateWithDuration(self.transitionDuration, animations: {
                self.darkerView.alpha = 0.0
                self.containerView.alpha = 0.0
                }, completion: { (finished) in
                    self.completionBlock?(.Success(self.newImage))
                    imageView.bmo_removeProgressAnimation()
            })
        } else {
            UIView.transitionWithView(
                imageView,
                duration: self.transitionDuration,
                options: .TransitionCrossDissolve,
                animations: {
                    self.newImageView.alpha = 1.0
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
    }
    override func failureAnimation(imageView: UIImageView, error: NSError?) {
        UIView.animateWithDuration(self.transitionDuration, animations: {
            self.darkerView.alpha = 0.0
            imageView.image = self.oldImage
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
            if let checkerBoard = CIFilter(name: "CICheckerboardGenerator", withInputParameters: [
                    "inputColor0"    : CIColor(color: UIColor.blackColor()),
                    "inputColor1"    : CIColor(color: UIColor.whiteColor()),
                    kCIInputWidthKey : 10
                ])?.outputImage {
                let context = CIContext()
                let drawRect = CGRectMake(0.0, 0.0, 40, 40)
                let outputImage = context.createCGImage(checkerBoard, fromRect: drawRect)
                
                darkerView.backgroundColor = UIColor(patternImage: UIImage(CGImage: outputImage))
            } else {
                darkerView.backgroundColor = UIColor.whiteColor()
            }
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
                containerViewMaskLayer.path = maskLayer.path!.insetPath(marginPercent)
            } else {
                containerViewMaskLayer.path = CGPathCreateWithRect(strongImageView.bounds, nil).insetPath(marginPercent)
            }
        } else {
            containerViewMaskLayer.path = BmoShapeHelper.getShapePath(.Circle, rect: strongImageView.bounds).insetPath(marginPercent)
        }
        containerView.layer.mask = containerViewMaskLayer

        if let image = newImage {
            strongImageView.image = image
            newImageView.image = image
        } else {
            newImageView.backgroundColor = progressColor
            newImageView.alpha = 0.4
        }

        newImageViewMaskLayer.path = CGPathCreateMutable()
        newImageView.layer.mask = newImageViewMaskLayer
        return self
    }
    
    //MARK: - ProgressHelpProtocol
    func layoutChanged(target: AnyObject) {
        guard let strongImageView = self.imageView else {
            return
        }
        if borderShape == true {
            if let maskLayer = strongImageView.layer.mask as? CAShapeLayer where maskLayer.path != nil {
                containerViewMaskLayer.path = maskLayer.path!.insetPath(marginPercent)
            } else {
                containerViewMaskLayer.path = CGPathCreateWithRect(strongImageView.bounds, nil).insetPath(marginPercent)
            }
        } else {
            containerViewMaskLayer.path = BmoShapeHelper.getShapePath(.Circle, rect: strongImageView.bounds).insetPath(marginPercent)
        }
    }
}

