//
//  ViewController.m
//  UUKeyboardInputView
//
//  Created by shake on 14/12/30.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "ViewController.h"
#import "UUInputAccessoryView.h"

@implementation ViewController

- (IBAction)click:(UIButton *)sender {
    
    UIKeyboardType type = sender.tag == 1 ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
    NSString *content = sender.tag == 2 ? [sender titleForState:UIControlStateNormal] : @"";
    
    [UUInputAccessoryView showKeyboardType:type
                                   content:content
                                     Block:^(NSString *contentStr)
    {
        if (contentStr.length == 0) return ;
        [sender setTitle:contentStr forState:UIControlStateNormal];
    }];
}

@end
