//
//  ViewController.m
//  UUKeyboardInputView
//
//  Created by shake on 14/12/30.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "ViewController.h"
#import "UUKeyboardInputView.h"

@implementation ViewController

- (IBAction)click:(UIButton *)sender {
    
    UIKeyboardType type = sender.tag == 1 ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
    NSString *content = sender.tag == 2 ? [sender titleForState:UIControlStateNormal] : @"";
    UIColor *color = sender.tag==0 ? [UIColor colorWithWhite:0 alpha:0.5]:[UIColor clearColor];
    
    [UUKeyboardInputView showKeyboardConfige:^(UUInputConfiger * _Nonnull configer) {
        // 配置信息（后续可继续添加）
        configer.keyboardType = type;
        configer.content = content;
        configer.backgroundColor = color;
        
    }block:^(NSString * _Nonnull contentStr) {
        // 回调事件处理
        if (contentStr.length == 0) return ;
        [sender setTitle:contentStr forState:UIControlStateNormal];
    }];
}



@end
