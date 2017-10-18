//
//  inputAccessoryView.m
//  InputAccessoryView-WindowLayer
//
//  Created by shake on 14/11/14.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUKeyboardInputView.h"

#define UUIAV_SCREEN_WIDTH    CGRectGetWidth([UIScreen mainScreen].bounds)
#define UUIAV_SCREEN_HEIGHT    CGRectGetHeight([UIScreen mainScreen].bounds)

@interface UUKeyboardInputView ()<UITextViewDelegate>

@property (nonatomic, copy) UUInputViewResultBlock finishBlock;

@property (nonatomic, strong) UITextView *inputView;
@property (nonatomic, strong) UIButton *btnSave;
@property (nonatomic, strong) UIView *toolbar;

@property (nonatomic, strong) UIButton *assistDismissButton;
@property (nonatomic, strong) UITextField *assistInputView;

@end

@implementation UUKeyboardInputView

+ (UUKeyboardInputView*)sharedView {
    
    static dispatch_once_t once;
    
    static UUKeyboardInputView *sharedView;
    
    dispatch_once(&once, ^ {
        sharedView = [[UUKeyboardInputView alloc] init];
    });
    return sharedView;
}

+ (void)dimiss
{
    [[UUKeyboardInputView sharedView] dismiss];
}

+ (void)showBlock:(UUInputViewResultBlock)block
{
    [[UUKeyboardInputView sharedView] configer:[UUInputConfiger new] show:block];
}

+ (void)showKeyboardType:(UIKeyboardType)type block:(UUInputViewResultBlock)block
{
    UUInputConfiger *configer = [UUInputConfiger new];
    configer.keyboardType = type;
    [[UUKeyboardInputView sharedView] configer:configer show:block];
}

+ (void)showKeyboardType:(UIKeyboardType)type content:(NSString *)content block:(UUInputViewResultBlock)block
{
    UUInputConfiger *configer = [UUInputConfiger new];
    configer.keyboardType = type;
    configer.content = content;
    [[UUKeyboardInputView sharedView] configer:configer show:block];
}

+ (void)showKeyboardConfige:(UUInputAccessoryConfige)confige block:(UUInputViewResultBlock)block
{
    UUInputConfiger *configer = [UUInputConfiger new];
    !confige?:confige(configer);
    [[UUKeyboardInputView sharedView] configer:configer show:block];
}

- (void)configer:(UUInputConfiger *_Nullable)configer show:(UUInputViewResultBlock)block
{
    [self initBaseElements];
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.assistDismissButton.frame = window.bounds;
    self.assistDismissButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [window addSubview:self.assistDismissButton];
    
    [self updateLayoutAtBegin:YES];
    
    self.finishBlock = block;
    self.inputView.text = configer.content;
    self.assistInputView.text = configer.content;
    self.inputView.keyboardType = configer.keyboardType;
    self.assistInputView.keyboardType = configer.keyboardType;
    self.btnSave.selected = configer.content.length==0;
    self.assistDismissButton.userInteractionEnabled = configer.backgroundUserInterface;
    self.assistDismissButton.backgroundColor = configer.backgroundColor ?: [UIColor clearColor];
    
    self.assistInputView.inputAccessoryView = _toolbar;
    [self.assistInputView becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidShowNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      if (self.assistDismissButton.window && self.assistInputView.isFirstResponder) {
                                                          [self.inputView becomeFirstResponder];
                                                          [self.inputView scrollRangeToVisible:NSMakeRange(self.inputView.text.length, 1)];
//                                                          [self updateLayoutAtBegin:NO];
                                                      }
                                                  }];
    
    //note: scroll to dismiss keyboard
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidHideNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      [self cleanBaseElements];
                                                  }];

    //note: scroll to dismiss keyboard
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      if (self.inputView.isFirstResponder) {
                                                          [self dismiss];
                                                      }
                                                  }];

}

- (void)updateLayoutAtBegin:(BOOL)atBeigin
{
    CGFloat const saveButtonWidth = 60;
    CGFloat const edge = 4;
    
    CGFloat height = MAX(40, _inputView.contentSize.height);
    height = MIN(height, 80);
//    height = atBeigin ? 40:height;
    [UIView animateWithDuration:atBeigin ? 0:0.2 animations:^{
        _btnSave.frame = CGRectMake(UUIAV_SCREEN_WIDTH-saveButtonWidth, (height-40)/2.0, saveButtonWidth, 40);
        _toolbar.frame = CGRectMake(0, 40-height, UUIAV_SCREEN_WIDTH, height);
        _inputView.frame = CGRectMake(edge, edge, UUIAV_SCREEN_WIDTH-saveButtonWidth-edge, height-edge*2);
    }];
}

- (void)saveButtonAction
{
    [self.inputView resignFirstResponder];
    if (!self.btnSave.selected) {
        !self.finishBlock ?: self.finishBlock(self.inputView.text ?: @"");
    }
    [self dismiss];
}

- (void)dismiss
{
    [self.inputView resignFirstResponder];
    [self.assistDismissButton removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// textView's delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self saveButtonAction];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self updateLayoutAtBegin:NO];
    self.btnSave.selected = textView.text.length==0;
}

- (void)initBaseElements
{
    UIButton *backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backgroundBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *toolbar = [[UIView alloc] init];
    toolbar.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1000, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [toolbar addSubview:line];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.returnKeyType = UIReturnKeyDone;
    textView.enablesReturnKeyAutomatically = YES;
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:15];
    textView.layer.cornerRadius = 5;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    [toolbar addSubview:textView];
    
    UITextField *assistTxf = [UITextField new];
    assistTxf.returnKeyType = UIReturnKeyDone;
    assistTxf.enablesReturnKeyAutomatically = YES;
    [backgroundBtn addSubview:assistTxf];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.backgroundColor = [UIColor clearColor];
    [saveBtn setTitle:@"确定" forState:UIControlStateNormal];
    [saveBtn setTitle:@"取消" forState:UIControlStateSelected];
    [saveBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [saveBtn addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:saveBtn];
    
    self.toolbar = toolbar;
    self.assistDismissButton = backgroundBtn;
    self.inputView = textView;
    self.assistInputView = assistTxf;
    self.btnSave = saveBtn;
}

- (void)cleanBaseElements
{
    [self.toolbar removeFromSuperview];
    [self.assistDismissButton removeFromSuperview];
    [self.inputView removeFromSuperview];
    [self.assistInputView removeFromSuperview];
    [self.btnSave removeFromSuperview];
    _toolbar = nil;
    _assistDismissButton = nil;
    _inputView = nil;
    _assistInputView = nil;
    _btnSave = nil;
    _finishBlock = nil;
}

@end



@implementation UUInputConfiger

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundUserInterface = YES;
    }
    return self;
}

@end
