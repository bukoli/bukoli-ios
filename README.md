# Bukoli iOS SDK

[![CI Status](http://img.shields.io/travis/bukoli/bukoli-ios.svg?style=flat)](https://travis-ci.org/bukoli/bukoli-ios)
[![Version](https://img.shields.io/cocoapods/v/Bukoli.svg?style=flat)](http://cocoapods.org/pods/Bukoli)
[![License](https://img.shields.io/cocoapods/l/Bukoli.svg?style=flat)](http://cocoapods.org/pods/Bukoli)
[![Platform](https://img.shields.io/cocoapods/p/Bukoli.svg?style=flat)](http://cocoapods.org/pods/Bukoli)

You can sign up for a Bukoli account at http://www.bukoli.com.

## Requirements

- iOS 8.0+
- Xcode 7.3+
- Swift 2.3

## Dependencies

- [Alamofire 3.0+](https://github.com/Alamofire/Alamofire)
- [AlamofireImage 2.0+](https://github.com/Alamofire/AlamofireImage)
- [ObjectMapper 1.0+](https://github.com/Hearst-DD/ObjectMapper)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

### CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Bukoli into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'Bukoli', '~> 0.1'
end
```

Then, run the following command:

```bash
$ pod install
```

### Api Key

You need api key to integrate sdk to your application. You can get it from [Bukoli](http://www.bukoli.com)

## Usage

### Configuration

In Xcode, secondary-click your project's .plist file and select Open As -> Source Code.
Insert the following XML snippet into the body of your file just before the final </dict> element.

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>{Human readable reason for location access}</string>
<dict>
	<key>NSAllowsArbitraryLoads</key>
	<false/>
	<key>NSExceptionDomains</key>
    <dict>
        <key>bukoli.borusan.com</key>
        <dict>
            <key>NSTemporaryExceptionRequiresForwardSecrecy</key>
            <false/>
        </dict>
		<key>bukoli.mobillium.com</key>
		<dict>
			<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
			<true/>
        </dict>
    </dict>
</dict>
```

### Initialize

```swift
AppDelegate.swift
import Bukoli

func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    ...
    Bukoli.initialize("your api key")
    ...
    return true
}

### Customization

```swift
import Bukoli

Bukoli.sharedInstance.brandName = "Brand" // Brand Name for info dialog
Bukoli.sharedInstance.brandName2 = "Brand'den" // Ablative Brand Name for info dialog
Bukoli.sharedInstance.buttonTextColor = UIColor.white // Text Colors on button
Bukoli.sharedInstance.buttonBackgroundColor = UIColor.black // Button background color
Bukoli.sharedInstance.shouldAskPhoneNumber = true // If you want to ask user phone number for Bukoli point
```

### Bukoli Select Point

SetUser function first parameter is user unique id on your system

Select function first parameter is presenter viewcontroller.

```swift
import Bukoli


Bukoli.setUser(userCode, phone: "phoneNumber", email: "email")
Bukoli.select(self, completion: { (result: BukoliResult, point: BukoliPoint?, phoneNumber: String?) in
    switch(result) {
    case .success:
        // Point selected
        // If you asked for phone number, phone number is taken.
        // Phone number format is: 1231234567
        self.handleSuccess(point, phoneNumber: phoneNumber)
    case .phoneNumberMissing:
        // Point selected
        // User didn't give phone number.
        self.handlePhoneNumberMissing(point, phoneNumber: phoneNumber)
    case .pointNotSelected:
        // User closed without selecting a point
        self.handlePointNotSelected(point, phoneNumber: phoneNumber)
    }
})
```

### Bukoli Info

First parameter is presenter viewcontroller.

```swift
import Bukoli

Bukoli.info(self)
```

### Bukoli Point Status

First parameter is point code

```swift
import Bukoli

Bukoli.pointStatus(pointCode, completion: { (result, point) in
    switch(result) {
    case .enabled:
    	// Point is enabled
    case .disabled:
    	// Point is disabled
    case .notFound:
    	// Point not found
    }
})

```

## License

Bukoli is available under the MIT license. See the LICENSE file for more info.
