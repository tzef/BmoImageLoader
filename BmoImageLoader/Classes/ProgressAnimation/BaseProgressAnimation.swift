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
    var completionBlock: ((BmoProgressCompletionResult<UIImage, NSError>) -> Void)?
    var completionState = BmoProgressCompletionState.proceed
    var progress = Progress(totalUnitCount: 100)
    var progressColor = UIColor.black
    var displayLink: CADisplayLink? = nil
    var percentFont: UIFont?

    // Animation Parameters
    let transitionDuration = 0.33
    let enlargeDuration = 0.33
    var progressDuration = 0.5
    var marginPercent: CGFloat = 0.1

    // MARK: - Public
    @objc func displayLinkAction(_ dis: CADisplayLink) {
    }
    func successAnimation(_ imageView: UIImageView) {
    }
    func failureAnimation(_ imageView: UIImageView, error: NSError?) {
    }

    // MARK : - Private
    fileprivate func initDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
        displayLink = CADisplayLink(target: self, selector: #selector(BaseProgressAnimation.displayLinkAction(_:)))
        displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.UITrackingRunLoopMode)
        displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    // MARK: - ProgressAnimator Protocol
    func setCompletionBlock(_ completion: ((BmoProgressCompletionResult<UIImage, NSError>) -> Void)?) -> BmoProgressAnimator {
        self.completionBlock = completion
        return self
    }
    func setCompletionState(_ state: BmoProgressCompletionState) -> BmoProgressAnimator {
        self.completionState = state
        switch self.completionState {
        case .succeed:
            self.setCompletedUnitCount(progress.totalUnitCount).closure()
        case .failed(_):
            self.setCompletedUnitCount(0).closure()
        default:
            break
        }
        return self
    }
    func setTotalUnitCount(_ count: Int64) -> BmoProgressAnimator {
        progress.totalUnitCount = count
        return self
    }
    func setCompletedUnitCount(_ count: Int64) -> BmoProgressAnimator {
        guard let strongImageView = self.imageView else {
            return self
        }
        progress.completedUnitCount = count
        initDisplayLink()
        helpPointView.bounds = helpPointView.layer.presentation()?.bounds ?? helpPointView.bounds
        helpPointView.layer.removeAllAnimations()
        UIView.animate(withDuration: progressDuration, animations: {
            self.helpPointView.bounds = CGRect(x: CGFloat(self.progress.fractionCompleted), y: 0, width: 0, height: 0)
        }, completion: { (finished) in
            if finished {
                if self.progress.completedUnitCount >= self.progress.totalUnitCount {
                    switch self.completionState {
                    case .succeed:
                        self.successAnimation(strongImageView)
                    default:
                        break
                    }
                }
                if self.progress.completedUnitCount == 0 {
                    switch self.completionState {
                    case .failed(let error):
                        self.failureAnimation(strongImageView, error: error)
                    default:
                        break
                    }
                }
            }
        }) 
        return self
    }
    func resetAnimation() -> BmoProgressAnimator {
        return self
    }
    func setAnimationDuration(_ duration: TimeInterval) -> BmoProgressAnimator {
        self.progressDuration = duration
        return self
    }
    func setNewImage(_ image: UIImage) -> BmoProgressAnimator {
        self.newImage = image
        return self
    }
    func setMarginPercent(_ percent: CGFloat) -> BmoProgressAnimator {
        self.marginPercent = percent
        self.resetAnimation().closure()
        return self
    }
    func setProgressColor(_ color: UIColor) -> BmoProgressAnimator {
        self.progressColor = color
        self.resetAnimation().closure()
        return self
    }
    func setPercentFont(_ font: UIFont) -> BmoProgressAnimator {
        self.percentFont = font
        self.resetAnimation().closure()
        return self
    }

    /**
        Do nothing, in order to avoid the warning about result of call is unused
    */
    func closure() {
        return
    }
}
