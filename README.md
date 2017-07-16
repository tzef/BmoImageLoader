# BmoImageLoader

[![CI Status](http://img.shields.io/travis/LEE%20ZHE%20YU/BmoImageLoader.svg?style=flat)](https://travis-ci.org/LEE%20ZHE%20YU/BmoImageLoader)
[![Version](https://img.shields.io/cocoapods/v/BmoImageLoader.svg?style=flat)](http://cocoapods.org/pods/BmoImageLoader)
[![License](https://img.shields.io/cocoapods/l/BmoImageLoader.svg?style=flat)](http://cocoapods.org/pods/BmoImageLoader)
[![Platform](https://img.shields.io/cocoapods/p/BmoImageLoader.svg?style=flat)](http://cocoapods.org/pods/BmoImageLoader)

BmoImageLoader is a progress animated component for UIImageView

Image downloader implementation and cache manager use AlamofireImage

<img src="https://raw.githubusercontent.com/tzef/BmoImageLoader/develop/demo.gif" width="300">

## Feature

- [x] UIImageView Extension for image downloading with progress animation
- [x] UIImageView Downloads with placeholder image
- [x] Shape UIImageView
- [x] Include 7 style progress animation
- [x] UIImageView progress animator support custom control, used in any case
- [x] AlamofireImage default In-Memory Image Cache
- [x] AlamofireImage default Prioritized Queue Order Image Downloading

## Requirements

iOS 8.0+ 
Xcode 8.0+
Swift 3.0+

## Dependencies

Alamofire 4.0+
AlamofireImage 3.1

## BmoImageViewFactory
#### Shape ImageView
Support RoundedRect, Circle, Ellipse, Triangle, Pentagon, Heart, Star totally 7 shape paths
```swift
BmoImageViewFactory.shape(UIImageView, shape: BmoImageViewShape)
```
#### Create Progress Animator
The factory will return a BmoProgressAnimator Protocol
```swift
let animator = BmoImageViewFactory
    .progressAnimation(UIImageView, newImage: nil, style: BmoImageViewProgressStyle)
```
BmoProgressAnimator default progress TotalUnitCount is 100, if need changed
```swift
animator.setTotalUnitCount(count: Int64)
```
When progress forward
```swift
animator.setCompletedUnitCount(count: Int64)
```
More, you can custom animation detail style
```swift
animator.setProgressColor(UIColor)
        .setMarginPercent(percent: CGFloat)
        .setAnimationDuration(duration: NSTimeInterval)
```

## UIImageView Extension
If you want to use more flexible, can use AlamofireImage's ImageCache and ImageDownloader, custom `ImageDownloader.ProgressHandler`, catch totalBytesRead and totalExpectedBytesToRead and use `BmoImageViewFactory.progressAnimation` to display progress animtion
#### Setting Image with URL
Setting the image with a URL will asynchronously download the image and set it once the request is finished.
```swift
imageView.bmo_setImageWithURL(IMAGE_URL)
```
#### Run image progress animation if catched
Whether to run the image progress animation if the image is cached. Defaults is `false`
```swift
imageView.bmo_runAnimationIfCatched(true)
```

## Example
#### Use CirclePie progress style to load a new image without handle downloading progress, just image transition
```swift
let placeholderImage = UIImage(named: "placeholder")
let animator = BmoImageViewFactory
    .progressAnimation(UIImageView, newImage: placeholderImage, style: BmoImageViewProgressStyle.CirclePie(borderShape: true))
    .setAnimationDuration(0.5)
    .setCompletionBlock({ (result) in
                        if result.isSuccess {
                            //do something when succeed
                        }
                        if result.isFailure {
                            //do something when failed
                        }
                    })
if let newImage = UIImage(named: "newImage") {
    animator.setNewImage(newImage)
            .setCompletionState(BmoProgressCompletionState.Succeed)
}
```
#### Use CircleBrush progress style to upload a new image
use Alamofire Uploading with Progress
```swift
Alamofire.upload(.POST, "https://httpbin.org/post", file: fileURL)
         .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
             print(totalBytesWritten)

             // This closure is NOT called on the main queue for performance
             // reasons. To update your ui, dispatch to the main queue.
             dispatch_async(dispatch_get_main_queue()) {
                 print("Total bytes written on main queue: \(totalBytesWritten)")
             }
         }
         .validate()
         .responseJSON { response in
             debugPrint(response)
         }
```
And then pass `totalBytesWritten`and `totalBytesExpectedToWrite` to BmoProgressAnimator
```swift
let newImage = UIImage(named: "newImage")
let animator = BmoImageViewFactory
    .progressAnimation(UIImageView, newImage: newImage, style: BmoImageViewProgressStyle.CircleBrush(borderShape: true))
    .setTotalUnitCount(totalBytesExpectedToWrite)
    .setCompletionBlock({ (result) in
                        if result.isSuccess {
                            //do something when succeed
                        }
                        if result.isFailure {
                            //do something when failed
                        }
                    })
```
When uploading
```swift
animator.setCompletedUnitCount(totalBytesWritten)
```
When uploading completed, succeed or failed
```swift
animator.setCompletionState(BmoProgressCompletionState.Succeed)
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

BmoImageLoader is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "BmoImageLoader"
```

## Author

LEE ZHE YU, tzef8220@gmail.com

## License

BmoImageLoader is available under the MIT license. See the LICENSE file for more info.
