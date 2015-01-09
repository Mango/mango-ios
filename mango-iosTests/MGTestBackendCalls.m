//
//  MGTestBackendCalls.m
//  mango-ios
//
//  Created by Gonzalo Larralde on 12/9/14.
//  Copyright (c) 2014 Mango. All rights reserved.
//

#import "MGTestConstants.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <AFNetworking/AFNetworking.h>
#import "Mango.h"

@interface MGTestBackendCalls : XCTestCase

@end

@implementation MGTestBackendCalls

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [[Mango sharedInstance] setPublicAPIKey:kPublicAPIKey];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [[Mango sharedInstance] setPublicAPIKey:nil];
    
    [super tearDown];
}

#pragma mark - Tests

- (void)testInvalidPublicAPIKey {
    
    Mango *mango = [Mango sharedInstance];
    mango.publicAPIKey = @"INVALID_API_KEY";
    
    //  Using CC data from https://developers.getmango.com/es/docs/test-card-numbers/
    XCTestExpectation *apiCallExpectation = [self expectationWithDescription:@"Create Token API call"];
    
    [mango createTokenWithNumber:@""
                            type:@""
                      holdername:@""
                 expirationMonth:1
                  expirationYear:1
                             CCV:@""
                 completionBlock:^(NSError *error, NSDictionary *data) {
                     NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
                     XCTAssert(response.statusCode == 401);
                     [apiCallExpectation fulfill];
                 }];
    
    [self waitForExpectationsWithTimeout:kTimeoutAPICall handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

- (void)testCreateToken {
    
    Mango *mango = [Mango sharedInstance];
    
    //  Using CC data from https://developers.getmango.com/es/docs/test-card-numbers/
    XCTestExpectation *apiCallExpectation = [self expectationWithDescription:@"Create Token API call"];
    
    [mango createTokenWithNumber:@"4507990000000010"
                            type:@"visa"
                      holdername:@"Test Visa"
                 expirationMonth:10
                  expirationYear:2015
                             CCV:@"123"
                 completionBlock:^(NSError *error, NSDictionary *data) {
                     XCTAssertNil(error);
                     [apiCallExpectation fulfill];
                 }];
    
    [self waitForExpectationsWithTimeout:kTimeoutAPICall handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

- (void)testCreateCCV {
    
    Mango *mango = [Mango sharedInstance];
    
    XCTestExpectation *apiCallExpectation = [self expectationWithDescription:@"Create CCV API call"];
    
    [mango createCCV:@"123" completionBlock:^(NSError *error, NSDictionary *data) {
        XCTAssertNil(error);
        [apiCallExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:kTimeoutAPICall handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

@end
