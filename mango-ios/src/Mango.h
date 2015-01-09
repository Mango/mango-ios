//
//  Mango.h
//  mango-ios
//
//  Created by Ezequiel Becerra on 12/6/14.
//  Copyright (c) 2014 Mango. All rights reserved.
//

#import <Foundation/Foundation.h>

//  Libs
#import <AFNetworking/AFNetworking.h>

@interface Mango : NSObject {
    AFHTTPRequestOperationManager *_operationManager;
}

@property (nonatomic, strong) NSString *publicAPIKey;

+ (instancetype)sharedInstance;

- (void)createTokenWithNumber:(NSString *)number
                         type:(NSString *)type
                   holdername:(NSString *)holdername
              expirationMonth:(NSInteger)expirationMonth
               expirationYear:(NSInteger)expirationYear
                          CCV:(NSString*)creditCardVerification
              completionBlock:(void (^)(NSError *error, NSDictionary *data))completionBlock;

- (void)createCCV:(NSString*)creditCardVerification
  completionBlock:(void (^)(NSError *error, NSDictionary *data))completionBlock;

- (BOOL)validateCardNumber:(NSString*)cardNumber;
- (BOOL)validateExpiryDateWithMonth:(NSInteger)month andYear:(NSInteger)year;
- (BOOL)validateCCV:(NSString*)creditCardVerification;

@end
