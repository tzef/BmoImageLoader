//
//  ViewController.swift
//  BmoImageLoader
//
//  Created by LEE ZHE YU on 08/11/2016.
//  Copyright (c) 2016 LEE ZHE YU. All rights reserved.
//

import UIKit
import BmoImageLoader

extension UILabel {
    func formatRead(text: String) {
        let mutableAttributes = NSMutableAttributedString(string: text)
        let textArray = text.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        if textArray.count == 2 {
            let nsStr = NSString(string: text)
            let rangeSearch = NSMakeRange(0, nsStr.length)
            let rangeTitle = nsStr.rangeOfString(textArray[0], options: .BackwardsSearch, range: rangeSearch, locale: nil)
            let rangeContent = nsStr.rangeOfString(textArray[1], options: .BackwardsSearch, range: rangeSearch, locale: nil)
            mutableAttributes.addAttributes([NSFontAttributeName : UIFont.systemFontOfSize(18.0)], range: rangeTitle)
            mutableAttributes.addAttributes([NSFontAttributeName : UIFont.systemFontOfSize(12.0)], range: rangeContent)
        }
        self.attributedText = mutableAttributes
    }
}
enum DemoType: String {
    case shapeImageView = "Shape ImageView\nBmoImageViewFactory.shape(UIImageView, shape: BmoImageViewShape)"
    case setImageFromURL = "Set Image From URL\nUIImageView.bmo_setImageWithURL(NSURL, style: BmoImageViewProgressStyle)"
    case controlProgress = "Control Progress Self\nProgress completionState, animationDuration, completedCount, completionBlock"
    case updateImage = "Update Image\nPast new image to BmoImageViewFactory.progressAnimation()"
    case styleDemoCirclePaint = "Multi Animatio Style\nCirclePaint"
    case styleDemoCircleBrush = "Multi Animatio Style\nCircleBrush"
    case styleDemoCircleFill = "Multi Animatio Style\nCircleFill"
    case styleDemoCirclePie = "Multi Animatio Style\nCirclePie"
    case styleDemoColorBar = "Multi Animatio Style\nColorBar"
    case styleDemoPercentNumber = "Multi Animatio Style\nPercentNumber"
}
let demoShapes: [(BmoImageViewShape?, String)] = [
    (nil, "Custom ImageView Mask"),
    (.RoundedRect(corner: 15), ".RoundedRect(corner: 15)"),
    (.Circle, ".Circle"),
    (.Heart, ".Heart"),
    (.Star, ".Star"),
    (.Triangle, ".Triangle"),
    (.Pentagon, ".Pentagon"),
    (.Ellipse, ".Ellipse"),
]
class ViewController: UIViewController, UITableViewDataSource, DemoImageCellProtocol {
    @IBOutlet weak var readLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var demoStep = DemoType.shapeImageView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Auto Demo
        goDemoType(.shapeImageView)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
            self.goDemoType(.setImageFromURL)
        }
    }
    func goDemoType(type: DemoType) {
        demoStep = type
        readLabel.formatRead(demoStep.rawValue)
        tableView.reloadData()
    }
    
    // MARK: - TableDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoShapes.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("demoCell") as? DemoImageCell {
            cell.configureCell(demoStep, index: indexPath, delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - Cell Delegate
    func loadURLfinished() {
        //Local AutoDemo
        self.goDemoType(.controlProgress)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3.0 * Float(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.goDemoType(.updateImage)
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(7.0 * Float(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.goDemoType(.styleDemoCirclePaint)
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(9.0 * Float(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.goDemoType(.styleDemoCircleFill)
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(11.0 * Float(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.goDemoType(.styleDemoCirclePie)
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(13.0 * Float(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.goDemoType(.styleDemoCircleBrush)
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(15.0 * Float(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.goDemoType(.styleDemoColorBar)
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(17.0 * Float(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.goDemoType(.styleDemoPercentNumber)
        }
        //Repeat
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(19.0 * Float(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.loadURLfinished()
        }
    }
}

protocol DemoImageCellProtocol {
    func loadURLfinished()
}
class DemoImageCell: UITableViewCell {
    @IBOutlet weak var demoImageView: UIImageView!
    @IBOutlet weak var readLabel: UILabel!
    var delegate: DemoImageCellProtocol?
    
    func configureCell(type: DemoType, index: NSIndexPath, delegate: DemoImageCellProtocol?) {
        self.delegate = delegate
        readLabel.text = "\(demoShapes[index.row].1)"
        demoImageView.backgroundColor = UIColor.grayColor()
        demoImageView.bmo_runAnimationIfCatched(true)
        let tinyDelay = dispatch_time(DISPATCH_TIME_NOW, Int64(0.001 * Float(NSEC_PER_SEC)))
        dispatch_after(tinyDelay, dispatch_get_main_queue()) {
            if let shape = demoShapes[index.row].0 {
                BmoImageViewFactory.shape(self.demoImageView, shape: shape)
            } else {
                // Custom Mask Layer Path
                let rect = self.demoImageView.bounds
                let maskShapeLayer = CAShapeLayer()
                let path = UIBezierPath.init()
                path.moveToPoint(CGPointMake(rect.minX, rect.midY - rect.height / 8))
                path.addLineToPoint(CGPointMake(rect.midX, rect.midY - rect.height / 8))
                path.addLineToPoint(CGPointMake(rect.midX, rect.minY))
                path.addLineToPoint(CGPointMake(rect.maxX, rect.midY))
                path.addLineToPoint(CGPointMake(rect.midX, rect.maxY))
                path.addLineToPoint(CGPointMake(rect.midX, rect.midY + rect.height / 8))
                path.addLineToPoint(CGPointMake(rect.minX, rect.midY + rect.height / 8))
                path.closePath()
                maskShapeLayer.path = path.CGPath
                self.demoImageView.layer.mask = maskShapeLayer
            }
            switch type {
            case .setImageFromURL:
                if let url = NSURL(string: "https://raw.githubusercontent.com/tzef/BmoImageLoader/master/DemoImage/beemo.png#\(index.row)") {
                    self.demoImageView.bmo_setImageWithURL(url, style: BmoImageViewProgressStyle.CirclePie(borderShape: true), placeholderImage: nil, completion: { (response) in
                        self.readLabel.text = "\(demoShapes[index.row].1) \n \(response.result)"
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
                            self.delegate?.loadURLfinished()
                        }
                    })
                }
            case .controlProgress:
                let animator = BmoImageViewFactory
                                    .progressAnimation(self.demoImageView, newImage: nil, style: BmoImageViewProgressStyle.CircleBrush(borderShape: false))
                                    .setAnimationDuration(0.5)
                                    .setCompletedUnitCount(60)
                                    .setCompletionBlock({ (result) in
                                        self.readLabel.text = "\(demoShapes[index.row].1) \n \(result.isSuccess)"
                                    })
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(888 * NSEC_PER_MSEC)), dispatch_get_main_queue()) {
                    animator
                        .setAnimationDuration(0.5)
                        .setCompletedUnitCount(33)
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1400 * NSEC_PER_MSEC)), dispatch_get_main_queue()) {
                    animator
                        .setNewImage(UIImage(named: "pikachu")!)
                        .setCompletionState(BmoProgressCompletionState.Succeed)
                }
            case .updateImage:
                BmoImageViewFactory
                    .progressAnimation(self.demoImageView, newImage: UIImage(named: "beemo"), style: BmoImageViewProgressStyle.CircleBrush(borderShape: true))
                    .setMarginPercent(0.3)
                    .setAnimationDuration(2)
                    .setCompletionState(BmoProgressCompletionState.Succeed)
                    .setCompletionBlock({ (result) in
                        self.readLabel.text = "\(demoShapes[index.row].1) \n \(result.isSuccess)"
                    })
            case .styleDemoColorBar:
                self.demoImageView?.image = nil
                BmoImageViewFactory
                    .progressAnimation(self.demoImageView, newImage: nil, style: BmoImageViewProgressStyle.ColorProgress(position: BmoProgressPosition.PositionCenter))
                    .setAnimationDuration(1)
                    .setNewImage(UIImage(named: "beemo")!)
                    .setCompletionState(BmoProgressCompletionState.Succeed)
            case .styleDemoCirclePaint:
                BmoImageViewFactory
                    .progressAnimation(self.demoImageView, newImage: nil, style: BmoImageViewProgressStyle.CirclePaint(borderShape: true))
                    .setAnimationDuration(1)
                    .setNewImage(UIImage(named: "pikachu")!)
                    .setCompletionState(BmoProgressCompletionState.Succeed)
            case .styleDemoCircleFill:
                BmoImageViewFactory
                    .progressAnimation(self.demoImageView, newImage: UIImage(named: "beemo"), style: BmoImageViewProgressStyle.CircleFill(borderShape: true))
                    .setAnimationDuration(1)
                    .setCompletionState(BmoProgressCompletionState.Succeed)
            case .styleDemoCirclePie:
                BmoImageViewFactory
                    .progressAnimation(self.demoImageView, newImage: UIImage(named: "pikachu"), style: BmoImageViewProgressStyle.CirclePie(borderShape: true))
                    .setAnimationDuration(1)
                    .setCompletionState(BmoProgressCompletionState.Succeed)
            case .styleDemoCircleBrush:
                self.demoImageView?.image = nil
                BmoImageViewFactory
                    .progressAnimation(self.demoImageView, newImage: nil, style: BmoImageViewProgressStyle.CircleBrush(borderShape: true))
                    .setAnimationDuration(1)
                    .setNewImage(UIImage(named: "beemo")!)
                    .setCompletionState(BmoProgressCompletionState.Succeed)
            case .styleDemoPercentNumber:
                self.demoImageView?.image = nil
                BmoImageViewFactory
                    .progressAnimation(self.demoImageView, newImage: nil, style: BmoImageViewProgressStyle.PercentNumber)
                    .setAnimationDuration(1)
                    .setNewImage(UIImage(named: "beemo")!)
                    .setCompletionState(BmoProgressCompletionState.Succeed)
            default:
                break
            }
        }
    }
}