//
//  inputAccessoryView.m
//  InputAccessoryView-WindowLayer
//
//  Created by shake on 14/11/14.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUInputAccessoryView.h"

#define UUIAV_MAIN_W    CGRectGetWidth([UIScreen mainScreen].bounds)
#define UUIAV_MAIN_H    CGRectGetHeight([UIScreen mainScreen].bounds)
#define UUIAV_Edge_Hori 5
#define UUIAV_Edge_Vert 7
#define UUIAV_Btn_W    40
#define UUIAV_Btn_H    30


@interface UUInputAccessoryView ()<UITextFieldDelegate>
{
    UIButton *btnBack;
    UITextField *inputView;
    UIButton *BtnSave;
}
@end

@implementation UUInputAccessoryView

+ (UUInputAccessoryView*)sharedView {
    static dispatch_once_t once;
    static UUInputAccessoryView *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[UUInputAccessoryView alloc] init];
    });
    CGRectGetHeight([UIScreen mainScreen].bounds);
    return sharedView;
}

+ (void)showBlock:(UUInputAccessoryBlock)block
{
    [[UUInputAccessoryView sharedView] show:block keyboardType:UIKeyboardTypeDefault];
}

+ (void)showKeyboardType:(UIKeyboardType)type Block:(UUInputAccessoryBlock)block
{
    [[UUInputAccessoryView sharedView] show:block keyboardType:type];
}

- (void)show:(UUInputAccessoryBlock)block keyboardType:(UIKeyboardType)type
{
    inputBlock = block;
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, UUIAV_MAIN_W, UUIAV_MAIN_H);
    [btnBack addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    btnBack.backgroundColor=[UIColor clearColor];
    
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, UUIAV_MAIN_W, 44)];
    inputView = [[UITextField alloc]initWithFrame:CGRectMake(UUIAV_Edge_Hori, UUIAV_Edge_Vert, UUIAV_MAIN_W-UUIAV_Btn_W-4*UUIAV_Edge_Hori, UUIAV_Btn_H)];
    inputView.borderStyle = UITextBorderStyleRoundedRect;
    inputView.returnKeyType = UIReturnKeyDone;
    inputView.keyboardType = type;
    inputView.enablesReturnKeyAutomatically = YES;
    inputView.delegate = self;
    [toolbar addSubview:inputView];
    
    UITextField *assistView = [[UITextField alloc]init];
    assistView.delegate = self;
    assistView.returnKeyType = UIReturnKeyDone;
    assistView.keyboardType = type;
    assistView.enablesReturnKeyAutomatically = YES;
    [btnBack addSubview:assistView];
    [assistView becomeFirstResponder];
    assistView.inputAccessoryView = toolbar;
    
    
    BtnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    BtnSave.frame = CGRectMake(UUIAV_MAIN_W-UUIAV_Btn_W-2*UUIAV_Edge_Hori, UUIAV_Edge_Vert, UUIAV_Btn_W, UUIAV_Btn_H);
    BtnSave.backgroundColor = [UIColor clearColor];
    [BtnSave setTitle:@"确定" forState:UIControlStateNormal];
    [BtnSave setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [BtnSave addTarget:self action:@selector(Done) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:BtnSave];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(firstRes:) name:UIKeyboardDidShowNotification object:nil];

    [window addSubview:btnBack];
}
- (void)Done
{
    [inputView resignFirstResponder];
    inputBlock(inputView.text);
    [self dismiss];
}
- (void)firstRes:(id)sender
{
    [inputView becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self Done];
    return YES;
}

- (void)dismiss
{
    [inputView resignFirstResponder];
    [btnBack removeFromSuperview];
    btnBack = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self forKeyPath:UIKeyboardDidShowNotification];
}
@end
