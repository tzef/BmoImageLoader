//
//  BaseProgressAnimation.swift
//  CrazyMikeSwift
//
//  Created by LEE ZHE YU on 2016/8/7.
//  Copyright © 2016年 B1-Media. All rights reserved.
//

import UIKit

class BaseProgressAnimation: BmoProgressAnimator {
    // Progress Animation View
    weak var imageView: UIImageView?
    var newImage: UIImage?
    let helpPointView = BmoProgressHelpView()

    // Progress Parameters
    var completionBlock: (BmoProgressCompletionResult<UIImage, NSError> -> Void)?
    var completionState = BmoProgressCompletionState.Proceed
    var progress = NSProgress()
    var progressColor = UIColor.blackColor()
    var displayLink: CADisplayLink? = nil
    var percentFont: UIFont?

    // Animation Parameters
    let transitionDuration = 0.33
    let enlargeDuration = 0.33
    var progressDuration = 0.5
    var marginPercent: CGFloat = 0.1

    // MARK: - Public
    @objc func displayLinkAction(dis: CADisplayLink) {
    }
    func successAnimation(imageView: UIImageView) {
    }
    func failureAnimation(imageView: UIImageView, error: NSError?) {
    }

    // MARK : - Private
    private func initDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
        displayLink = CADisplayLink(target: self, selector: #selector(BaseProgressAnimation.displayLinkAction(_:)))
        displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: UITrackingRunLoopMode)
        displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    }
    
    // MARK: - ProgressAnimator Protocol
    func setCompletionBlock(completion: (BmoProgressCompletionResult<UIImage, NSError> -> Void)?) -> BmoProgressAnimator {
        self.completionBlock = completion
        return self
    }
    func setCompletionState(state: BmoProgressCompletionState) -> BmoProgressAnimator {
        self.completionState = state
        switch self.completionState {
        case .Succeed:
            setCompletedUnitCount(progress.totalUnitCount)
        case .Failed(_):
            setCompletedUnitCount(0)
        default:
            break
        }
        return self
    }
    func setTotalUnitCount(count: Int64) -> BmoProgressAnimator {
        progress.totalUnitCount = count
        return self
    }
    func setCompletedUnitCount(count: Int64) -> BmoProgressAnimator {
        guard let strongImageView = self.imageView else {
            return self
        }
        progress.completedUnitCount = count
        initDisplayLink()
        helpPointView.bounds = helpPointView.layer.presentationLayer()?.bounds ?? helpPointView.bounds
        helpPointView.layer.removeAllAnimations()
        UIView.animateWithDuration(progressDuration, animations: {
            self.helpPointView.bounds = CGRectMake(CGFloat(self.progress.fractionCompleted), 0, 0, 0)
        }) { (finished) in
            if finished {
                if self.progress.completedUnitCount >= self.progress.totalUnitCount {
                    switch self.completionState {
                    case .Succeed:
                        self.successAnimation(strongImageView)
                    default:
                        break
                    }
                }
                if self.progress.completedUnitCount == 0 {
                    switch self.completionState {
                    case .Failed(let error):
                        self.failureAnimation(strongImageView, error: error)
                    default:
                        break
                    }
                }
            }
        }
        return self
    }
    func resetAnimation() -> BmoProgressAnimator {
        return self
    }
    func setAnimationDuration(duration: NSTimeInterval) -> BmoProgressAnimator {
        self.progressDuration = duration
        return self
    }
    func setNewImage(image: UIImage) -> BmoProgressAnimator {
        self.newImage = image
        return self
    }
    func setMarginPercent(percent: CGFloat) -> BmoProgressAnimator {
        self.marginPercent = percent
        resetAnimation()
        return self
    }
    func setProgressColor(color: UIColor) -> BmoProgressAnimator {
        self.progressColor = color
        resetAnimation()
        return self
    }
    func setPercentFont(font: UIFont) -> BmoProgressAnimator {
        self.percentFont = font
        resetAnimation()
        return self
    }
}
