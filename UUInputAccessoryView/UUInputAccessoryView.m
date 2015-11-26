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
    UUInputAccessoryBlock inputBlock;

    UIButton *btnBack;
    UITextField *inputView;
    UITextField *assistView;
    UIButton *BtnSave;
    
    // dirty code for iOS9
    BOOL shouldDismiss;
}
@end

@implementation UUInputAccessoryView

+ (UUInputAccessoryView*)sharedView {
    static dispatch_once_t once;
    static UUInputAccessoryView *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[UUInputAccessoryView alloc] init];
        
        sharedView->btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        sharedView->btnBack.frame = CGRectMake(0, 0, UUIAV_MAIN_W, UUIAV_MAIN_H);
        [sharedView->btnBack addTarget:sharedView action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        sharedView->btnBack.backgroundColor=[UIColor clearColor];
        
        UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, UUIAV_MAIN_W, 44)];
        sharedView->inputView = [[UITextField alloc]initWithFrame:CGRectMake(UUIAV_Edge_Hori, UUIAV_Edge_Vert, UUIAV_MAIN_W-UUIAV_Btn_W-4*UUIAV_Edge_Hori, UUIAV_Btn_H)];
        sharedView->inputView.borderStyle = UITextBorderStyleRoundedRect;
        sharedView->inputView.returnKeyType = UIReturnKeyDone;
        sharedView->inputView.clearButtonMode = UITextFieldViewModeWhileEditing;
        sharedView->inputView.enablesReturnKeyAutomatically = YES;
        sharedView->inputView.delegate = sharedView;
        [toolbar addSubview:sharedView->inputView];

        sharedView->assistView = [[UITextField alloc]init];
        sharedView->assistView.delegate = sharedView;
        sharedView->assistView.returnKeyType = UIReturnKeyDone;
        sharedView->assistView.enablesReturnKeyAutomatically = YES;
        [sharedView->btnBack addSubview:sharedView->assistView];
        sharedView->assistView.inputAccessoryView = toolbar;
        
        sharedView->BtnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        sharedView->BtnSave.frame = CGRectMake(UUIAV_MAIN_W-UUIAV_Btn_W-2*UUIAV_Edge_Hori, UUIAV_Edge_Vert, UUIAV_Btn_W, UUIAV_Btn_H);
        sharedView->BtnSave.backgroundColor = [UIColor clearColor];
        [sharedView->BtnSave setTitle:@"确定" forState:UIControlStateNormal];
        [sharedView->BtnSave setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [sharedView->BtnSave addTarget:sharedView action:@selector(Done) forControlEvents:UIControlEventTouchUpInside];
        [toolbar addSubview:sharedView->BtnSave];

    });
    CGRectGetHeight([UIScreen mainScreen].bounds);
    return sharedView;
}

+ (void)showBlock:(UUInputAccessoryBlock)block
{
    [[UUInputAccessoryView sharedView] show:block
                               keyboardType:UIKeyboardTypeDefault
                                    content:@""];
}

+ (void)showKeyboardType:(UIKeyboardType)type Block:(UUInputAccessoryBlock)block
{
    [[UUInputAccessoryView sharedView] show:block
                               keyboardType:type
                                    content:@""];
}

+ (void)showKeyboardType:(UIKeyboardType)type content:(NSString *)content Block:(UUInputAccessoryBlock)block
{
    [[UUInputAccessoryView sharedView] show:block
                               keyboardType:type
                                    content:content];
}

- (void)show:(UUInputAccessoryBlock)block keyboardType:(UIKeyboardType)type content:(NSString *)content
{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    [window addSubview:btnBack];

    inputBlock = block;
    inputView.text = content;
    inputView.keyboardType = type;
    assistView.keyboardType = type;
    [assistView becomeFirstResponder];
    shouldDismiss = NO;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidShowNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      if (!shouldDismiss) {
                                                          [inputView becomeFirstResponder];
                                                      }
                                                  }];
}

- (void)Done
{
    [inputView resignFirstResponder];
    !inputBlock ?: inputBlock(inputView.text);
    [self dismiss];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self Done];
    return NO;
}

- (void)dismiss
{
    shouldDismiss = YES;
    [inputView resignFirstResponder];
    [btnBack removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
