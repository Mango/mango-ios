//
//  mango_iosTests.m
//  mango-iosTests
//
//  Created by Ezequiel Becerra on 12/6/14.
//  Copyright (c) 2014 Mango. All rights reserved.
//

#import "MGTestConstants.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "Mango.h"

@interface MGTestValidators : XCTestCase

@end

@implementation MGTestValidators

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCCVValidator {
    Mango *mango = [Mango sharedInstance];
    
    XCTAssert([mango validateCCV:@"123"]); // Good CCV
    XCTAssert([mango validateCCV:@"1234"]); // Good CCV
    XCTAssert(![mango validateCCV:@"12345"]); // Bad CCV
    XCTAssert(![mango validateCCV:@"12"]); // Bad CCV
}

- (void)testCardNumberValidator {
    Mango *mango = [Mango sharedInstance];

    //  Using examples from https://developers.getmango.com/es/tools/javascript-sdk/
    XCTAssert([mango validateCardNumber:@"4242424242424242"]); // Good CC Number
    XCTAssert(![mango validateCardNumber:@"8"]); // Bad CC Number
}

- (void)testExpirationDateValidator {
    Mango *mango = [Mango sharedInstance];
    
    //  Using examples from https://developers.getmango.com/es/tools/javascript-sdk/
    XCTAssert([mango validateExpiryDateWithMonth:8 andYear:2030]); // Good expiration date
    XCTAssert(![mango validateExpiryDateWithMonth:12 andYear:2012]); // Bad expiration date
}

- (void)testNonNumberCharsInCardNumberValidator {
    Mango *mango = [Mango sharedInstance];
    
    XCTAssert(![mango validateCardNumber:@"a"]); // Bad CC Number
}

@end
