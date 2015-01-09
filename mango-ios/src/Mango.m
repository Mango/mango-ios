//
//  Mango.m
//  mango-ios
//
//  Created by Ezequiel Becerra on 12/6/14.
//  Copyright (c) 2014 Mango. All rights reserved.
//

#import "Mango.h"

@interface Mango ()
-(AFHTTPRequestOperation *)requestWithMethod:(NSString *)method
                                relativePath:(NSString *)relativePath
                                  parameters:(NSDictionary *)params
                             completionBlock:(void (^)(NSError *error, NSDictionary *data))completionBlock;
@end

@implementation Mango

static NSString *kMangoBaseURL = @"https://api.getmango.com/v1";

#pragma mark - Private

-(AFHTTPRequestOperation *)requestWithMethod:(NSString *)method
                                relativePath:(NSString *)relativePath
                                  parameters:(NSDictionary *)params
                             completionBlock:(void (^)(NSError *error, NSDictionary *data))completionBlock {
    
    void (^aSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *parseError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                           options:NSJSONReadingAllowFragments
                                                                             error:&parseError];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(parseError, responseDictionary);
        });
    };
    
    void (^aFailBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSError *parseError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:operation.responseData
                                                                           options:NSJSONReadingAllowFragments
                                                                             error:&parseError];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(error, responseDictionary);
        });
    };
    
    if ([method isEqualToString:@"GET"]){
        
        return [_operationManager GET:relativePath
                           parameters:params
                              success:aSuccessBlock
                              failure:aFailBlock];
        
    }else if ([method isEqualToString:@"POST"]){
        
        return [_operationManager POST:relativePath
                            parameters:params
                               success:aSuccessBlock
                               failure:aFailBlock];
        
    }else if ([method isEqualToString:@"DELETE"]){
        
        return [_operationManager DELETE:relativePath
                              parameters:params
                                 success:aSuccessBlock
                                 failure:aFailBlock];
        
    }else{
        NSLog(@"#ERROR METHOD NOT IMPLEMENTED: %@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    }
    
    return nil;
}

#pragma mark - Properties

- (void)setPublicAPIKey:(NSString *)publicAPIKey {
    _publicAPIKey = publicAPIKey;

    NSString *encodedPublicAPIKey = [[_publicAPIKey dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", encodedPublicAPIKey];
    [_operationManager.requestSerializer setValue:authValue forHTTPHeaderField:@"Authorization"];
}

#pragma mark - Public

+ (instancetype)sharedInstance {
    static Mango *sharedInstance;
    if (!sharedInstance) {
        sharedInstance = [[Mango alloc] init];
    }
    
    return sharedInstance;
}

-(id)init{
    self = [super init];
    if (self){
        NSURL *baseURL = [NSURL URLWithString:kMangoBaseURL];
        _operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
        _operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",nil];        
        _operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}


- (void)createTokenWithNumber:(NSString *)number
                         type:(NSString *)type
                   holdername:(NSString *)holdername
              expirationMonth:(NSInteger)expirationMonth
               expirationYear:(NSInteger)expirationYear
                          CCV:(NSString*)creditCardVerification
              completionBlock:(void (^)(NSError *error, NSDictionary *data))completionBlock {

    NSDictionary *params = @{
                             @"number" : number,
                             @"type" : type,
                             @"holdername" : holdername,
                             @"exp_month" : @(expirationMonth),
                             @"exp_year" : @(expirationYear),
                             @"ccv" : creditCardVerification
                             };
    
    [self requestWithMethod:@"POST"
               relativePath:@"tokens/"
                 parameters:params
            completionBlock:completionBlock];
}

- (void)createCCV:(NSString*)creditCardVerification
  completionBlock:(void (^)(NSError *error, NSDictionary *data))completionBlock {
    
    NSDictionary *params = @{
                             @"ccv" : creditCardVerification
                             };
    
    [self requestWithMethod:@"POST"
               relativePath:@"ccvs/"
                 parameters:params
            completionBlock:completionBlock];
}

- (BOOL)validateCardNumber:(NSString*)cardNumber {
    NSUInteger len = cardNumber.length;
    NSInteger mul = 0;
    NSArray *prodArr = @[
                   @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9],
                   @[@0, @2, @4, @6, @8, @1, @3, @5, @7, @9]
                   ];
    NSInteger sum = 0;
    while (len--) {
        int number = [cardNumber characterAtIndex:len]-'0';
        
        // Non ASCII numbers invalidates the result
        if(number < 0 || number > 9) {
            return false;
        }
        
        sum += [prodArr[mul][number] integerValue];
        mul ^= 1;
    }
    return sum % 10 == 0 && sum > 0;
}

- (BOOL)validateExpiryDateWithMonth:(NSInteger)month andYear:(NSInteger)year {
    if(month < 1 || month > 12)
        return false;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = month + 1 > 12 ? 1 : month + 1;
    components.year = month + 1 > 12 ? year + 1 : year;
    components.day = 1;
    
    NSDate *expDate = [calendar dateFromComponents:components];
    
    return ([expDate compare:[NSDate date]] == NSOrderedDescending);
}

- (BOOL)validateCCV:(NSString*)creditCardVerification {
    return creditCardVerification.length >= 3 && creditCardVerification.length <= 4;
}

@end
