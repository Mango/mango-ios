//
//  MGTestMangoParams.m
//  mango-ios
//
//  Created by Gonzalo Larralde on 12/9/14.
//  Copyright (c) 2014 Mango. All rights reserved.
//

#import "MGTestConstants.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "Mango.h"

// Exposing private methods for testing porpuses

@interface Mango (PrivateMethods)

-(AFHTTPRequestOperation *)requestWithMethod:(NSString *)method
                                relativePath:(NSString *)relativePath
                                  parameters:(NSDictionary *)params
                             completionBlock:(void (^)(NSError *error, NSDictionary *data))completionBlock;

@end

@interface MGTestMangoParams : XCTestCase

@end

@implementation MGTestMangoParams

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [[Mango sharedInstance] setPublicAPIKey:nil];
    
    [super tearDown];
}

- (void)testTokenCreationParams {
    Mango *mangoInstance = [[Mango alloc] init];
    Mango *mangoMock = OCMPartialMock(mangoInstance);
    
    OCMStub([mangoMock requestWithMethod:[OCMArg any]
                            relativePath:[OCMArg any]
                              parameters:[OCMArg any]
                         completionBlock:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
        __unsafe_unretained NSDictionary *parameters;
        [invocation getArgument:&parameters atIndex:4];
        
        XCTAssertEqualObjects(parameters[@"number"], @"4507990000000010");
        XCTAssertEqualObjects(parameters[@"type"], @"visa");
        XCTAssertEqualObjects(parameters[@"holdername"], @"Test Visa");
        XCTAssertEqualObjects(parameters[@"exp_month"], @(10));
        XCTAssertEqualObjects(parameters[@"exp_year"], @(2015));
        XCTAssertEqualObjects(parameters[@"ccv"], @"123");
    });
    
    [mangoMock createTokenWithNumber:@"4507990000000010"
                                type:@"visa"
                          holdername:@"Test Visa"
                     expirationMonth:10
                      expirationYear:2015
                                 CCV:@"123"
                     completionBlock:nil];

}

@end
