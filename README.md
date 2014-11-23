# XBChatModule

[![CI Status](http://img.shields.io/travis/eugenenguyen/XBChatModule.svg?style=flat)](https://travis-ci.org/eugenenguyen/XBChatModule)
[![Version](https://img.shields.io/cocoapods/v/XBChatModule.svg?style=flat)](http://cocoadocs.org/docsets/XBChatModule)
[![License](https://img.shields.io/cocoapods/l/XBChatModule.svg?style=flat)](http://cocoadocs.org/docsets/XBChatModule)
[![Platform](https://img.shields.io/cocoapods/p/XBChatModule.svg?style=flat)](http://cocoadocs.org/docsets/XBChatModule)

## About

You tired about hundreds of line to install chat module? We're here to help.

XBChatModule is a simple to use module to implement chat module integrated with Jabber server. Just 4 lines of config and goooooooo

``` objective-c
[[XBChatModule sharedInstance] setUsername:@"username"];
[[XBChatModule sharedInstance] setPassword:@"password"];
[[XBChatModule sharedInstance] setHost:@"chat.example.com"];
[[XBChatModule sharedInstance] connect];
```

And we also provide some other config as you wish :)

``` objective-c
[[XBChatModule sharedInstance] setAvatarFormat:@"http://chat.example.com/avatar/%@"];
[[XBChatModule sharedInstance] setAvatarPlaceHolder:[UIImage imageNamed:@"girl_9"]];
```

That's all of what you need :)

XBChatModule is a product of [LIBRETeamStudio](https://twitter.com/LIBRETeamStudio)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

XBChatModule is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "XBChatModule"

## Author

eugenenguyen, xuanbinh91@gmail.com

## License

XBChatModule is available under the MIT license. See the LICENSE file for more info.

