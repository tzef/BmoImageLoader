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
    case catchDefault
    case catchNone
}
extension UIImageView {
    func bmo_removeProgressAnimation() {
        for subView in self.subviews {
            if subView.isKind(of: BmoProgressHelpView.self) || subView.isKind(of: BmoProgressImageView.self) {
                subView.removeFromSuperview()
            }
        }
        if let subLayers = self.layer.sublayers {
            for subLayer in subLayers {
                if subLayer.isKind(of: BmoProgressShapeLayer.self) {
                    subLayer.removeFromSuperlayer()
                }
            }
        }
    }

    // MARK: - Public
    public func bmo_setImageWithURL (
        _ URL: Foundation.URL,
        style: BmoImageViewProgressStyle,
        placeholderImage: UIImage? = nil,
        completion: ((DataResponse<UIImage>) -> Void)? = nil) {

        let urlRequest = URLRequestWithURL(URL)
        guard !isURLRequestURLEqualToActiveRequestURL(urlRequest) else { return }

        self.af_cancelImageRequest()
        self.bmo_removeProgressAnimation()
        
        let imageDownloader = UIImageView.af_sharedImageDownloader
        let imageCache = imageDownloader.imageCache

        guard let request = urlRequest.urlRequest else {
            return
        }

        // Use the image from the image cache if it exists
        if let image = imageCache?.image(for: request, withIdentifier: nil) {
            let response = DataResponse<UIImage>(
                request: request,
                response: nil,
                data: nil,
                result: .success(image)
            )
            completion?(response)
            
            if let runAnimation = self.bmo_runAnimationIfCatched, runAnimation == true {
                let animator = generateAnimator(placeholderImage, style: style, urlRequest: request, completion: completion)
                animator
                    .setNewImage(image)
                    .setCompletionState(.succeed)
                    .closure()
            } else {
                self.image = image
            }
            return
        }

        // Generate progress animation if the image need to downlaod from internet
        let animator = generateAnimator(placeholderImage, style: style, urlRequest: request, completion: completion)
        let progrssHandler: ImageDownloader.ProgressHandler = {(progress) in
            animator
                .setTotalUnitCount(progress.totalUnitCount)
                .setCompletedUnitCount(progress.completedUnitCount)
                .closure()
        }

        // Generate a unique download id to check whether the active request has changed while downloading
        let downloadID = UUID().uuidString

        // Download the image, then run the image transition or completion handler
        let requestReceipt = imageDownloader.download(
            urlRequest,
            receiptID: downloadID,
            filter: nil,
            progress: progrssHandler,
            progressQueue: DispatchQueue.main,
            completion: { [weak self] response in
                guard let strongSelf = self else { return }
                guard
                    strongSelf.isURLRequestURLEqualToActiveRequestURL(response.request) &&
                        strongSelf.af_activeRequestReceipt?.receiptID == downloadID
                    else { return }

                if let image = response.result.value {
                    animator
                        .setNewImage(image)
                        .setCompletionState(.succeed)
                        .closure()
                } else {
                    animator
                        .setCompletionState(BmoProgressCompletionState.failed(error: response.result.error as NSError?))
                        .closure()
                }

                strongSelf.af_activeRequestReceipt = nil
            }
        )
        
        af_activeRequestReceipt = requestReceipt
    }
    public func bmo_runAnimationIfCatched(_ run: Bool) {
        self.bmo_runAnimationIfCatched = run
    }
    private func generateAnimator(_ newImage: UIImage?, style: BmoImageViewProgressStyle, urlRequest: URLRequest, completion: ((DataResponse<UIImage>) -> Void)?) -> BmoProgressAnimator {
        let animator = BmoImageViewFactory.progressAnimation(self, newImage: newImage, style: style)
        animator.setCompletionBlock { (animatorResult) in
            var errorMsg = ""
            guard let request = urlRequest.urlRequest else {
                return
            }
            if animatorResult.isSuccess {
                if let image = animatorResult.value {
                    let response = DataResponse<UIImage>(
                        request: request,
                        response: nil,
                        data: nil,
                        result: .success(image)
                    )
                    completion?(response)
                } else {
                    errorMsg = "Fetch Image Failed"
                }
            } else {
                if let error = animatorResult.error {
                    let response = DataResponse<UIImage>(
                        request: request,
                        response: nil,
                        data: nil,
                        result: .failure(error)
                    )
                    completion?(response)
                } else {
                    errorMsg = "Unknown Error"
                }
            }
            if errorMsg != "" {
                let userInfo = [NSLocalizedFailureReasonErrorKey: errorMsg]
                let response = DataResponse<UIImage>(
                    request: request,
                    response: nil,
                    data: nil,
                    result: .failure(NSError(domain: request.url?.absoluteString ?? "Unknown Domain", code: NSURLErrorCancelled, userInfo: userInfo))
                )
                completion?(response)
            }
        }.closure()
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
    private func URLRequestWithURL(_ URL: Foundation.URL) -> URLRequest {
        let mutableURLRequest = NSMutableURLRequest(url: URL)
        
        for mimeType in Request.acceptableImageContentTypes {
            mutableURLRequest.addValue(mimeType, forHTTPHeaderField: "Accept")
        }
        
        return mutableURLRequest as URLRequest
    }
    
    private func isURLRequestURLEqualToActiveRequestURL(_ urlRequest: URLRequestConvertible?) -> Bool {
        if
            let currentRequestURL = af_activeRequestReceipt?.request.task?.originalRequest?.url,
            let requestURL = urlRequest?.urlRequest?.url,
            currentRequestURL == requestURL
        {
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
