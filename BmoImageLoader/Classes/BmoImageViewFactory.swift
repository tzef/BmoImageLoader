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
    case roundedRect(corner: CGFloat)
    case triangle
    case pentagon
    case ellipse
    case circle
    case heart
    case star
}
public enum BmoImageViewProgressStyle {
    case circlePie(borderShape: Bool)
    case circleBrush(borderShape: Bool)
    case circlePaint(borderShape: Bool)
    case circleFill(borderShape: Bool)
    case colorProgress(position: BmoProgressPosition)
    case percentNumber
    case defaultIndicator(indicatorStyle: UIActivityIndicatorViewStyle)
}
public enum BmoProgressPosition {
    case positionTop
    case positionCenter
    case positionBottom
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
    public static func shape(_ imageView: UIImageView, shape: BmoImageViewShape) {
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
        _ imageView: UIImageView,
        newImage: UIImage?,
        style: BmoImageViewProgressStyle) -> BmoProgressAnimator {

        switch style {
        case .circlePie(let borderShape):
            return CirclePieProgressAnimation(imageView: imageView, newImage: newImage, borderShape: borderShape)
        case .circleBrush(let borderShape):
            return CircleBrushProgressAnimation(imageView: imageView, newImage: newImage, borderShape: borderShape)
        case .circlePaint(let borderShape):
            return CirclePaintProgressAnimation(imageView: imageView, newImage: newImage, borderShape: borderShape)
        case .circleFill(let borderShape):
            return CircleFillProgressAnimation(imageView: imageView, newImage: newImage, borderShape: borderShape)
        case .colorProgress(let position):
            return ColorBarProgressAnimation(imageView: imageView, newImage: newImage, position: position)
        case .defaultIndicator(let indicatorStyle):
            return DefaultIndicatorProgressAnimation(imageView: imageView, newImage: newImage, indicatorStyle: indicatorStyle)
        case .percentNumber:
            return PercentNumberProgressAnimation(imageView: imageView, newImage: newImage)
        }
    }
}
