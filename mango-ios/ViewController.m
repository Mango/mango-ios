//
//  ViewController.m
//  mango-ios
//
//  Created by Ezequiel Becerra on 12/6/14.
//  Copyright (c) 2014 Mango. All rights reserved.
//

#import "ViewController.h"
#import "Mango.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createTokenButtonPressed:(id)sender {
    Mango *mango = [Mango sharedInstance];
    mango.publicAPIKey = _apiTextField.text;
    
    NSLog(@"CC Number OK %d", [mango validateCardNumber:@"4507990000000010"]);
    NSLog(@"CCV OK %d", [mango validateCCV:@"123"]);
    
    [mango createTokenWithNumber:@"4507990000000010"
                            type:@"visa"
                      holdername:@"Test Visa"
                 expirationMonth:10
                  expirationYear:2015
                             CCV:@"023"
                 completionBlock:^(NSError *error, NSDictionary *data) {
                     _responseTextView.text = data.description;
                 }];
    
    NSLog(@"#DEBUG %@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}

- (IBAction)createCCVButtonPressed:(id)sender {
    Mango *mango = [Mango sharedInstance];
    mango.publicAPIKey = _apiTextField.text;
    
    [mango createCCV:@"123"
     completionBlock:^(NSError *error, NSDictionary *data) {
         _responseTextView.text = data.description;
     }];
    NSLog(@"#DEBUG %@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}
@end
