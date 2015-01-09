//
//  ViewController.h
//  mango-ios
//
//  Created by Ezequiel Becerra on 12/6/14.
//  Copyright (c) 2014 Mango. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    __weak IBOutlet UITextField *_apiTextField;
    __weak IBOutlet UITextView *_responseTextView;
}

- (IBAction)createTokenButtonPressed:(id)sender;
- (IBAction)createCCVButtonPressed:(id)sender;

@end

