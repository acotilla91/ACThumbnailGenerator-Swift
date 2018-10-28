
# ACThumbnailGenerator-Swift

[![Version](https://img.shields.io/cocoapods/v/ACThumbnailGenerator-Swift.svg?style=flat)](https://cocoapods.org/pods/ACThumbnailGenerator-Swift)
[![License](https://img.shields.io/cocoapods/l/ACThumbnailGenerator-Swift.svg?style=flat)](https://cocoapods.org/pods/ACThumbnailGenerator-Swift)
[![Platform](https://img.shields.io/cocoapods/p/ACThumbnailGenerator-Swift.svg?style=flat)](https://cocoapods.org/pods/ACThumbnailGenerator-Swift)

ACThumbnailGenerator is an easy-to-use Swift utility for extracting still images (as UIImage) from remote video streams (e.g. HLS/.m3u8 streams) on iOS apps.

## Example

![Demo](https://github.com/acotilla91/ACThumbnailGenerator-Swift/blob/master/thumbnail_generator_demo.gif)

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

``` swift
var generator: ACThumbnailGenerator!

func captureSomeImage() {
    let streamUrl = URL(string: "https://p-events-delivery.akamaized.net/18oijbasfvuhbfsdvoijhbsdfvljkb6/m3u8/hls_vod_mvp.m3u8")!
    generator = ACThumbnailGenerator(streamUrl: streamUrl)
    generator.delegate = self
    generator.captureImage(at: 300)
}

func generator(_ generator: ACThumbnailGenerator, didCapture image: UIImage, at position: Double) {
    // Use `image`
}
```

## Installation

### CocoaPods

ACThumbnailGenerator-Swift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ACThumbnailGenerator-Swift'
```

### Manual

Just drag the *ACThumbnailGenerator.swift* file into your project.

## Author

Alejandro Cotilla, [@acotilla91](https://twitter.com/acotilla91)

## License

ACThumbnailGenerator-Swift is available under the MIT license. See the LICENSE file for more info.
