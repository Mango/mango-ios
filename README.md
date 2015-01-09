mango-ios
=========

Mango SDK for iOS

#Installation
We use _CocoaPods_:

```
pod 'mango-ios', :git => 'https://github.com/betzerra/mango-ios.git'
```

#How to use
##Setup
```objc
#import <mango-ios/Mango.h>

...

[Mango sharedInstance].publicAPIKey = @"some_public_api_key";
```

##Tokenize credit card
```objc
[mango createTokenWithNumber:@"4507990000000010"
                        type:@"visa"
                  holdername:@"Test Visa"
             expirationMonth:10
              expirationYear:2015
                         CCV:@"023"
             completionBlock:^(NSError *error, NSDictionary *data) {
                if (error) {
                  // Handle error with grace 
                } else {
                  // Success! Get your credit card token from data
                }
             }];
```

##Create CCV
```objc
[mango createCCV:@"123" completionBlock:^(NSError *error, NSDictionary *data) {
  if (error) {
    // Handle error with grace 
  } else {
    // Success! Get your credit card token from data
  }
}];
```
