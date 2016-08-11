//
//  ProgressAnimator.swift
//  CrazyMikeSwift
//
//  Created by LEE ZHE YU on 2016/8/2.
//  Copyright © 2016年 B1-Media. All rights reserved.
//

import UIKit

public protocol BmoProgressAnimator {
    func setTotalUnitCount(count: Int64) -> BmoProgressAnimator
    func setCompletedUnitCount(count: Int64) -> BmoProgressAnimator
    func setCompletionState(state: BmoProgressCompletionState) -> BmoProgressAnimator
    func setCompletionBlock(completion: (BmoProgressCompletionResult<UIImage, NSError> -> Void)? ) -> BmoProgressAnimator
    func setNewImage(image: UIImage) -> BmoProgressAnimator
    func setProgressColor(color: UIColor) -> BmoProgressAnimator
    func setMarginPercent(percent: CGFloat) -> BmoProgressAnimator
    func setAnimationDuration(duration: NSTimeInterval) -> BmoProgressAnimator
    func setPercentFont(font: UIFont) -> BmoProgressAnimator
}
protocol BmoProgressHelpProtocol {
    func layoutChanged(target: AnyObject)
}
public enum BmoProgressCompletionResult<Value, Error: NSError> {
    case Success(Value?)
    case Failure(Error?)

    /// Returns `true` if the result is a success, `false` otherwise.
    public var isSuccess: Bool {
        switch self {
        case .Success:
            return true
        case .Failure:
            return false
        }
    }

    /// Returns `true` if the result is a failure, `false` otherwise.
    public var isFailure: Bool {
        return !isSuccess
    }

    /// Returns the associated value if the result is a success, `nil` otherwise.
    public var value: Value? {
        switch self {
        case .Success(let value):
            return value
        case .Failure:
            return nil
        }
    }

    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    public var error: Error? {
        switch self {
        case .Success:
            return nil
        case .Failure(let error):
            return error
        }
    }
}
public enum BmoProgressCompletionState {
    case Proceed
    case Succeed
    case Failed(error: NSError?)
}

class BmoProgressHelpView: UIView {
    var delegate: BmoProgressHelpProtocol?
    override func layoutSubviews() {
        delegate?.layoutChanged(self)
    }
    convenience init(delegate: BmoProgressHelpProtocol) {
        self.init()
        self.delegate = delegate
    }
}
class BmoProgressImageView: UIImageView {
    //no function, only for identify
}
class BmoProgressShapeLayer: CAShapeLayer {
    //no function, only for identify
}