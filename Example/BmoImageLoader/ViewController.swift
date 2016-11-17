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
    func formatRead(_ text: String) {
        let mutableAttributes = NSMutableAttributedString(string: text)
        let textArray = text.components(separatedBy: CharacterSet.newlines)
        if textArray.count == 2 {
            let nsStr = NSString(string: text)
            let rangeSearch = NSMakeRange(0, nsStr.length)
            let rangeTitle = nsStr.range(of: textArray[0], options: .backwards, range: rangeSearch, locale: nil)
            let rangeContent = nsStr.range(of: textArray[1], options: .backwards, range: rangeSearch, locale: nil)
            mutableAttributes.addAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 18.0)], range: rangeTitle)
            mutableAttributes.addAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 12.0)], range: rangeContent)
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
    (.roundedRect(corner: 15), ".RoundedRect(corner: 15)"),
    (.circle, ".Circle"),
    (.heart, ".Heart"),
    (.star, ".Star"),
    (.triangle, ".Triangle"),
    (.pentagon, ".Pentagon"),
    (.ellipse, ".Ellipse"),
]
class ViewController: UIViewController, UITableViewDataSource, DemoImageCellProtocol {
    @IBOutlet weak var readLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var demoStep = DemoType.shapeImageView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Auto Demo
        goDemoType(.shapeImageView)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(3 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
            self.goDemoType(.setImageFromURL)
        }
    }
    func goDemoType(_ type: DemoType) {
        demoStep = type
        readLabel.formatRead(demoStep.rawValue)
        tableView.reloadData()
    }
    
    // MARK: - TableDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoShapes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "demoCell") as? DemoImageCell {
            cell.configureCell(demoStep, index: indexPath, delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - Cell Delegate
    func loadURLfinished() {
        //Local AutoDemo
        self.goDemoType(.controlProgress)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(3.0 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.goDemoType(.updateImage)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(7.0 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.goDemoType(.styleDemoCirclePaint)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(9.0 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.goDemoType(.styleDemoCircleFill)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(11.0 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.goDemoType(.styleDemoCirclePie)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(13.0 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.goDemoType(.styleDemoCircleBrush)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(15.0 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.goDemoType(.styleDemoColorBar)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(17.0 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.goDemoType(.styleDemoPercentNumber)
        }
        //Repeat
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(19.0 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
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
    
    func configureCell(_ type: DemoType, index: IndexPath, delegate: DemoImageCellProtocol?) {
        self.delegate = delegate
        readLabel.text = "\(demoShapes[index.row].1)"
        demoImageView.backgroundColor = UIColor.gray
        demoImageView.bmo_runAnimationIfCatched(true)
        let tinyDelay = DispatchTime.now() + Double(Int64(0.001 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: tinyDelay) {
            if let shape = demoShapes[index.row].0 {
                BmoImageViewFactory.shape(self.demoImageView, shape: shape)
            } else {
                // Custom Mask Layer Path
                let rect = self.demoImageView.bounds
                let maskShapeLayer = CAShapeLayer()
                let path = UIBezierPath.init()
                path.move(to: CGPoint(x: rect.minX, y: rect.midY - rect.height / 8))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.midY - rect.height / 8))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.midY + rect.height / 8))
                path.addLine(to: CGPoint(x: rect.minX, y: rect.midY + rect.height / 8))
                path.close()
                maskShapeLayer.path = path.cgPath
                self.demoImageView.layer.mask = maskShapeLayer
            }
            switch type {
            case .setImageFromURL:
                if let url = URL(string: "https://raw.githubusercontent.com/tzef/BmoImageLoader/master/DemoImage/beemo.png#\(index.row)") {
                    self.demoImageView.bmo_setImageWithURL(url, style: .circlePie(borderShape: true), placeholderImage: nil, completion: { (response) in
                        self.readLabel.text = "\(demoShapes[index.row].1) \n \(response.result)"
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                            self.delegate?.loadURLfinished()
                        })
                    })
                }
            case .controlProgress:
                let animator = BmoImageViewFactory
                                    .progressAnimation(self.demoImageView, newImage: nil, style: .circleBrush(borderShape: false))
                                    .setAnimationDuration(0.5)
                                    .setCompletedUnitCount(60)
                                    .setCompletionBlock({ (result) in
                                        self.readLabel.text = "\(demoShapes[index.row].1) \n \(result.isSuccess)"
                                    })
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(888 * NSEC_PER_MSEC)) / Double(NSEC_PER_SEC)) {
                    animator
                        .setAnimationDuration(0.5)
                        .setCompletedUnitCount(33)
                        .closure()
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1400 * NSEC_PER_MSEC)) / Double(NSEC_PER_SEC)) {
                    animator
                        .setNewImage(UIImage(named: "pikachu")!)
                        .setCompletionState(.succeed)
                        .closure()
                }
            case .updateImage:
                BmoImageViewFactory
                    .progressAnimation(self.demoImageView, newImage: UIImage(named: "beemo"), style: .circleBrush(borderShape: true))
                    .setMarginPercent(0.3)
                    .setAnimationDuration(2)
                    .setCompletionState(.succeed)
                    .setCompletionBlock({ (result) in
                        self.readLabel.text = "\(demoShapes[index.row].1) \n \(result.isSuccess)"
                    })
                    .closure()
            case .styleDemoColorBar:
                self.demoImageView?.image = nil
                BmoImageViewFactory
                    .progressAnimation(self.demoImageView, newImage: nil, style: .colorProgress(position: .positionCenter))
                    .setAnimationDuration(1)
                    .setNewImage(UIImage(named: "beemo")!)
                    .setCompletionState(.succeed)
                    .closure()
            case .styleDemoCirclePaint:
                BmoImageViewFactory
                    .progressAnimation(self.demoImageView, newImage: nil, style: .circlePaint(borderShape: true))
                    .setAnimationDuration(1)
                    .setNewImage(UIImage(named: "pikachu")!)
                    .setCompletionState(.succeed)
                    .closure()
            case .styleDemoCircleFill:
                BmoImageViewFactory
                    .progressAnimation(self.demoImageView, newImage: UIImage(named: "beemo"), style: .circleFill(borderShape: true))
                    .setAnimationDuration(1)
                    .setCompletionState(.succeed)
                    .closure()
            case .styleDemoCirclePie:
                BmoImageViewFactory
                    .progressAnimation(self.demoImageView, newImage: UIImage(named: "pikachu"), style: .circlePie(borderShape: true))
                    .setAnimationDuration(1)
                    .setCompletionState(.succeed)
                    .closure()
            case .styleDemoCircleBrush:
                self.demoImageView?.image = nil
                BmoImageViewFactory
                    .progressAnimation(self.demoImageView, newImage: nil, style: .circleBrush(borderShape: true))
                    .setAnimationDuration(1)
                    .setNewImage(UIImage(named: "beemo")!)
                    .setCompletionState(.succeed)
                    .closure()
            case .styleDemoPercentNumber:
                self.demoImageView?.image = nil
                BmoImageViewFactory
                    .progressAnimation(self.demoImageView, newImage: nil, style: .percentNumber)
                    .setAnimationDuration(1)
                    .setNewImage(UIImage(named: "beemo")!)
                    .setCompletionState(.succeed)
                    .closure()
            default:
                break
            }
        }
    }
}
