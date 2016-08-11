//
//  BmoImageFactory.swift
//  CrazyMikeSwift
//
//  Created by LEE ZHE YU on 2016/8/2.
//  Copyright © 2016年 B1-Media. All rights reserved.
//

import UIKit
import AlamofireImage
enum BmoImageViewShape {
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
    case ColorProgress(positionTop: Bool)
    case PercentNumber
    case DefaultIndicator(indicatorStyle: UIActivityIndicatorViewStyle)
}
struct BmoImageViewFactory {
    static func shape(imageView: UIImageView, shape: BmoImageViewShape) {
        imageView.layoutIfNeeded()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = BmoShapeHelper.getShapePath(shape, rect: imageView.bounds)
        imageView.layer.mask = shapeLayer
    }
    
    static func progressAnimation (
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
        case .ColorProgress(let positionTop):
            return ColorBarProgressAnimation(imageView: imageView, newImage: newImage, positionTop: positionTop)
        case .DefaultIndicator(let indicatorStyle):
            return DefaultIndicatorProgressAnimation(imageView: imageView, newImage: newImage, indicatorStyle: indicatorStyle)
        case .PercentNumber:
            return PercentNumberProgressAnimation(imageView: imageView, newImage: newImage)
        }
    }
}
