//
//  BmoImageViewExtension.swift
//  CrazyMikeSwift
//
//  Created by LEE ZHE YU on 2016/8/2.
//  Copyright © 2016年 B1-Media. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

enum BmoImageCatch {
    case CatchDefault
    case CatchNone
}
extension UIImageView {
    func bmo_removeProgressAnimation() {
        for subView in self.subviews {
            if subView.isKindOfClass(BmoProgressHelpView) || subView.isKindOfClass(BmoProgressImageView) {
                subView.removeFromSuperview()
            }
        }
        if let subLayers = self.layer.sublayers {
            for subLayer in subLayers {
                if subLayer.isKindOfClass(BmoProgressShapeLayer) {
                    subLayer.removeFromSuperlayer()
                }
            }
        }
    }

    // MARK: - Public
    public func bmo_setImageWithURL (
        URL: NSURL,
        style: BmoImageViewProgressStyle,
        placeholderImage: UIImage? = nil,
        completion: (Response<UIImage, NSError> -> Void)? = nil) {

        let urlRequest = URLRequestWithURL(URL)
        guard !isURLRequestURLEqualToActiveRequestURL(urlRequest) else { return }

        self.af_cancelImageRequest()
        self.bmo_removeProgressAnimation()
        
        let imageDownloader = UIImageView.af_sharedImageDownloader
        let imageCache = imageDownloader.imageCache
        
        // Use the image from the image cache if it exists
        if let image = imageCache?.imageForRequest(urlRequest.URLRequest, withAdditionalIdentifier: nil) {
            let response = Response<UIImage, NSError>(
                request: urlRequest.URLRequest,
                response: nil,
                data: nil,
                result: .Success(image)
            )
            completion?(response)
            
            if let runAnimation = self.bmo_runAnimationIfCatched where runAnimation == true {
                let animator = generateAnimator(placeholderImage, style: style, urlRequest: urlRequest.URLRequest, completion: completion)
                animator
                    .setNewImage(image)
                    .setCompletionState(.Succeed)
            } else {
                self.image = image
            }
            return
        }

        // Generate progress animation if the image need to downlaod from internet
        let animator = generateAnimator(placeholderImage, style: style, urlRequest: urlRequest.URLRequest, completion: completion)
        let progrssHandler: ImageDownloader.ProgressHandler = {(bytesRead: Int64, totalBytesRead: Int64, totalExpectedBytesToRead: Int64) in
            animator
                .setTotalUnitCount(totalExpectedBytesToRead)
                .setCompletedUnitCount(totalBytesRead)
        }

        // Generate a unique download id to check whether the active request has changed while downloading
        let downloadID = NSUUID().UUIDString

        // Download the image, then run the image transition or completion handler
        let requestReceipt = imageDownloader.downloadImage (
            URLRequest: urlRequest,
            receiptID: downloadID,
            filter: nil,
            progress: progrssHandler,
            progressQueue: dispatch_get_main_queue(),
            completion: { [weak self] response in
                guard let strongSelf = self else { return }
                guard
                    strongSelf.isURLRequestURLEqualToActiveRequestURL(response.request) &&
                        strongSelf.af_activeRequestReceipt?.receiptID == downloadID
                    else {
                        return
                }

                if let image = response.result.value {
                    animator
                        .setNewImage(image)
                        .setCompletionState(.Succeed)
                } else {
                    animator.setCompletionState(BmoProgressCompletionState.Failed(error: response.result.error))
                }
                
                strongSelf.af_activeRequestReceipt = nil
            }
        )
        
        af_activeRequestReceipt = requestReceipt
    }
    public func bmo_runAnimationIfCatched(run: Bool) {
        self.bmo_runAnimationIfCatched = run
    }
    private func generateAnimator(newImage: UIImage?, style: BmoImageViewProgressStyle, urlRequest: NSURLRequest, completion: (Response<UIImage, NSError> -> Void)?) -> BmoProgressAnimator {
        let animator = BmoImageViewFactory.progressAnimation(self, newImage: newImage, style: style)
        animator.setCompletionBlock { (animatorResult) in
            var errorMsg = ""
            if animatorResult.isSuccess {
                if let image = animatorResult.value {
                    let response = Response<UIImage, NSError>(
                        request: urlRequest.URLRequest,
                        response: nil,
                        data: nil,
                        result: .Success(image)
                    )
                    completion?(response)
                } else {
                    errorMsg = "Fetch Image Failed"
                }
            } else {
                if let error = animatorResult.error {
                    let response = Response<UIImage, NSError>(
                        request: urlRequest.URLRequest,
                        response: nil,
                        data: nil,
                        result: .Failure(error)
                    )
                    completion?(response)
                } else {
                    errorMsg = "Unknown Error"
                }
            }
            if errorMsg != "" {
                let userInfo = [NSLocalizedFailureReasonErrorKey: errorMsg]
                let response = Response<UIImage, NSError>(
                    request: urlRequest.URLRequest,
                    response: nil,
                    data: nil,
                    result: .Failure(NSError(domain: Error.Domain, code: NSURLErrorCancelled, userInfo: userInfo))
                )
                completion?(response)
            }
        }
        return animator
    }
    
    // MARK: - Private - AssociatedKeys
    private struct AssociatedKeys {
        static var ActiveRequestReceiptKey = "af_UIImageView.ActiveRequestReceipt"
        static var BmoProgressAnimatorKey = "bmo_ProgressAnimator"
        static var BmoRunAnimationIfCatched = "bmo_runAnimationIfCatched"
    }
    var af_activeRequestReceipt: RequestReceipt? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ActiveRequestReceiptKey) as? RequestReceipt
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ActiveRequestReceiptKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    var bmo_runAnimationIfCatched: Bool? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.BmoRunAnimationIfCatched) as? Bool
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.BmoRunAnimationIfCatched, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // MARK: - Private AlamofireImage URL Request Helper Methods
    private func URLRequestWithURL(URL: NSURL) -> NSURLRequest {
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        
        for mimeType in Request.acceptableImageContentTypes {
            mutableURLRequest.addValue(mimeType, forHTTPHeaderField: "Accept")
        }
        
        return mutableURLRequest
    }
    
    private func isURLRequestURLEqualToActiveRequestURL(URLRequest: URLRequestConvertible?) -> Bool {
        if let currentRequest = af_activeRequestReceipt?.request.task.originalRequest
            where currentRequest.URLString == URLRequest?.URLRequest.URLString {
            return true
        }
        
        return false
    }
}

// MARK: - Private AlamofireImage Request Extension
extension Request {
    static var acceptableImageContentTypes: Set<String> = [
        "image/tiff",
        "image/jpeg",
        "image/gif",
        "image/png",
        "image/ico",
        "image/x-icon",
        "image/bmp",
        "image/x-bmp",
        "image/x-xbitmap",
        "image/x-ms-bmp",
        "image/x-win-bitmap"
    ]
}
