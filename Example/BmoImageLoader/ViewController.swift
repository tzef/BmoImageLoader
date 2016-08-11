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
    case shapeImageView = "ImageViewShape\nBmoImageViewFactory.shape(UIImageView, shape: BmoImageViewShape)"
}
let demoShapes: [(BmoImageViewShape?, String)] = [
    (.RoundedRect(corner: 15), ".RoundedRect(corner: 15)"),
    (.Triangle, ".Triangle"),
    (.Pentagon, ".Pentagon"),
    (.Ellipse, ".Ellipse"),
    (.Circle, ".Circle"),
    (.Heart, ".Heart"),
    (.Star, ".Star"),
    (nil, "Custeom ImageView Mask")
]
class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var readLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var demoStep = DemoType.shapeImageView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readLabel.formatRead(demoStep.rawValue)
    }
    
    // MARK: TableDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoShapes.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("demoCell") as? DemoImageCell {
            cell.configureCell(demoStep, index: indexPath)
            return cell
        }
        return UITableViewCell()
    }
}

class DemoImageCell: UITableViewCell {
    @IBOutlet weak var demoImageView: UIImageView!
    @IBOutlet weak var readLabel: UILabel!
    
    func configureCell(type: DemoType, index: NSIndexPath) {
        readLabel.text = "\(demoShapes[index.row].1)"
        demoImageView.image = UIImage(named: "beemo")
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
        }
    }
}