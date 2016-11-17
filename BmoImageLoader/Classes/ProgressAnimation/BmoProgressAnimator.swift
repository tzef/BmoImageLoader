//
//  ProgressAnimator.swift
//  CrazyMikeSwift
//
//  Created by LEE ZHE YU on 2016/8/2.
//  Copyright © 2016年 B1-Media. All rights reserved.
//

import UIKit

public protocol BmoProgressAnimator {
    func setTotalUnitCount(_ count: Int64) -> BmoProgressAnimator
    func setCompletedUnitCount(_ count: Int64) -> BmoProgressAnimator
    func setCompletionState(_ state: BmoProgressCompletionState) -> BmoProgressAnimator
    func setCompletionBlock(_ completion: ((BmoProgressCompletionResult<UIImage, NSError>) -> Void)? ) -> BmoProgressAnimator
    func setNewImage(_ image: UIImage) -> BmoProgressAnimator
    func setProgressColor(_ color: UIColor) -> BmoProgressAnimator
    func setMarginPercent(_ percent: CGFloat) -> BmoProgressAnimator
    func setAnimationDuration(_ duration: TimeInterval) -> BmoProgressAnimator
    func closure()
    
    // For BmoImageViewProgressStyle.PercentNumber
    func setPercentFont(_ font: UIFont) -> BmoProgressAnimator
}
protocol BmoProgressHelpProtocol {
    func layoutChanged(_ target: AnyObject)
}
public enum BmoProgressCompletionResult<Value, Error: NSError> {
    case success(Value?)
    case failure(Error?)

    /// Returns `true` if the result is a success, `false` otherwise.
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
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
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }

    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}
public enum BmoProgressCompletionState {
    case proceed
    case succeed
    case failed(error: NSError?)
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
