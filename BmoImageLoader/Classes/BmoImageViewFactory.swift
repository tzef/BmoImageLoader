//
//  BmoImageFactory.swift
//  CrazyMikeSwift
//
//  Created by LEE ZHE YU on 2016/8/2.
//  Copyright © 2016年 B1-Media. All rights reserved.
//

import UIKit
import AlamofireImage
public enum BmoImageViewShape {
    case RoundedRect(corner: CGFloat)
    case Triangle
    case Pentagon
    case Ellipse
    case Circle
    case Heart
    case Star
}
public enum BmoImageViewProgressStyle {
    case CirclePie(borderShape: Bool)
    case CircleBrush(borderShape: Bool)
    case CirclePaint(borderShape: Bool)
    case CircleFill(borderShape: Bool)
    case ColorProgress(position: BmoProgressPosition)
    case PercentNumber
    case DefaultIndicator(indicatorStyle: UIActivityIndicatorViewStyle)
}
public enum BmoProgressPosition {
    case PositionTop
    case PositionCenter
    case PositionBottom
}
public struct BmoImageViewFactory {
    /**
        It created a shape path maskLayer and apply to imageView
        
        - parameter imageView: The UIImageView that will be set maskLayer
        - parameter shape: The mask shape defined in `BmoImageViewShape`
     
        ## Note ##
        1. If the imageView already have a maskLayer, it will be orverridden
        2. Make sure the imageView already layout finished
     */
    public static func shape(imageView: UIImageView, shape: BmoImageViewShape) {
        imageView.layoutIfNeeded()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = BmoShapeHelper.getShapePath(shape, rect: imageView.bounds)
        imageView.layer.mask = shapeLayer
    }
    
    /**
     It created a progressAnimator for the imageView
     
     - parameter imageView: The UIImageView that will be set progress animator
     - parameter newImage: It can be the placeholder Image or the image will be set
     - parameter style: The animation style shape defined in `BmoImageViewProgressStyle`
     
     ## Note ##
     1. If the imageView already have a maskLayer, the animation will fit the path
     2. If the imageView layout changed, animator will auto fit it
     */
    public static func progressAnimation (
        imageView: UIImageView,
        newImage: UIImage?,
        style: BmoImageViewProgressStyle) -> BmoProgressAnimator {

        switch style {
        case .CirclePie(let borderShape):
            return CirclePieProgressAnimation(imageView: imageView, newImage: newImage, borderShape: borderShape)
        case .CircleBrush(let borderShape):
            return CircleBrushProgressAnimation(imageView: imageView, newImage: newImage, borderShape: borderShape)
        case .CirclePaint(let borderShape):
            return CirclePaintProgressAnimation(imageView: imageView, newImage: newImage, borderShape: borderShape)
        case .CircleFill(let borderShape):
            return CircleFillProgressAnimation(imageView: imageView, newImage: newImage, borderShape: borderShape)
        case .ColorProgress(let position):
            return ColorBarProgressAnimation(imageView: imageView, newImage: newImage, position: position)
        case .DefaultIndicator(let indicatorStyle):
            return DefaultIndicatorProgressAnimation(imageView: imageView, newImage: newImage, indicatorStyle: indicatorStyle)
        case .PercentNumber:
            return PercentNumberProgressAnimation(imageView: imageView, newImage: newImage)
        }
    }
}
