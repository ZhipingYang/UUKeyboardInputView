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
#define UUIAV_Edge_Hori 5
#define UUIAV_Edge_Vert 7
#define UUIAV_Btn_W    40
#define UUIAV_Btn_H    35


@interface UUKeyboardInputView ()<UITextViewDelegate>

@property (nonatomic, copy) UUInputViewResultBlock inputBlock;
@property (nonatomic, strong) UIButton *btnBack;
@property (nonatomic, strong) UITextView *inputView;
@property (nonatomic, strong) UITextField *assistView;
@property (nonatomic, strong) UIButton *btnSave;
@property (nonatomic, strong) UIView *toolbar;

@end

@implementation UUKeyboardInputView

+ (UUKeyboardInputView*)sharedView {
    static dispatch_once_t once;
    static UUKeyboardInputView *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[UUKeyboardInputView alloc] init];
        
        UIButton *backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backgroundBtn addTarget:sharedView action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *toolbar = [[UIView alloc] init];
        toolbar.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1000, 0.5)];
        line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        [toolbar addSubview:line];
        
        UITextView *textView = [[UITextView alloc] init];
        textView.returnKeyType = UIReturnKeyDone;
        textView.enablesReturnKeyAutomatically = YES;
        textView.delegate = sharedView;
        textView.font = [UIFont systemFontOfSize:15];
        textView.layer.cornerRadius = 5;
        textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textView.layer.borderWidth = 1/[UIScreen mainScreen].scale;
        [toolbar addSubview:textView];
        
        UITextField *assistTxf = [UITextField new];
        assistTxf.returnKeyType = UIReturnKeyDone;
        assistTxf.enablesReturnKeyAutomatically = YES;
        [backgroundBtn addSubview:assistTxf];
        assistTxf.inputAccessoryView = toolbar;
        
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.backgroundColor = [UIColor clearColor];
        [saveBtn setTitle:@"确定" forState:UIControlStateNormal];
        [saveBtn setTitle:@"取消" forState:UIControlStateSelected];
        [saveBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [saveBtn addTarget:sharedView action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [toolbar addSubview:saveBtn];
        
        sharedView.toolbar = toolbar;
        sharedView.btnBack = backgroundBtn;
        sharedView.inputView = textView;
        sharedView.assistView = assistTxf;
        sharedView.btnSave = saveBtn;
    });
    return sharedView;
}

+ (void)dimiss
{
    [[UUKeyboardInputView sharedView] dismiss];
}

+ (void)showBlock:(UUInputViewResultBlock)block
{
    UUInputConfiger *configer = [UUInputConfiger new];
    [[UUKeyboardInputView sharedView] show:block configer:configer];
}

+ (void)showKeyboardType:(UIKeyboardType)type block:(UUInputViewResultBlock)block
{
    UUInputConfiger *configer = [UUInputConfiger new];
    configer.keyboardType = type;
    [[UUKeyboardInputView sharedView] show:block configer:configer];
}

+ (void)showKeyboardType:(UIKeyboardType)type content:(NSString *)content block:(UUInputViewResultBlock)block
{
    UUInputConfiger *configer = [UUInputConfiger new];
    configer.keyboardType = type;
    configer.content = content;
    [[UUKeyboardInputView sharedView] show:block configer:configer];
}

+ (void)showKeyboardConfige:(UUInputAccessoryConfige)confige block:(UUInputViewResultBlock)block
{
    UUInputConfiger *configer = [UUInputConfiger new];
    !confige?:confige(configer);
    [[UUKeyboardInputView sharedView] show:block configer:configer];
}

- (void)show:(UUInputViewResultBlock)block configer:(UUInputConfiger *_Nullable)configer
{
    UIWindow *window=[UIApplication sharedApplication].delegate.window;
    self.btnBack.frame = window.bounds;
    self.btnBack.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [window addSubview:self.btnBack];
    
    [self updateLayoutAtBegin:YES];
    
    self.inputBlock = block;
    self.inputView.text = configer.content;
    self.assistView.text = configer.content;
    self.inputView.keyboardType = configer.keyboardType;
    self.assistView.keyboardType = configer.keyboardType;
    self.btnSave.selected = configer.content.length==0;
    self.btnBack.userInteractionEnabled = configer.backgroundUserInterface;
    self.btnBack.backgroundColor = configer.backgroundColor ?: [UIColor clearColor];
    [self.assistView becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidShowNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      if (self.btnBack.window && self.assistView.isFirstResponder) {
                                                          [self.inputView becomeFirstResponder];
                                                          [self updateLayoutAtBegin:NO];
                                                      }
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
    height = atBeigin ? 40:height;
    [UIView animateWithDuration:atBeigin ? 0:0.2 animations:^{
        _btnSave.frame = CGRectMake(UUIAV_SCREEN_WIDTH-saveButtonWidth, (height-40)/2.0, saveButtonWidth, 40);
        _toolbar.frame = CGRectMake(0, 40-height, UUIAV_SCREEN_WIDTH, height);
        _inputView.frame = CGRectMake(edge, edge, UUIAV_SCREEN_WIDTH-saveButtonWidth-edge, height-edge*2);
    }];
}

- (void)btnClick
{
    [self.inputView resignFirstResponder];
    if (!self.btnSave.selected) {
        !self.inputBlock ?: self.inputBlock(self.inputView.text ?: @"");
    }
    [self dismiss];
}

- (void)dismiss
{
    [self.inputView resignFirstResponder];
    [self.btnBack removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// textView's delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self btnClick];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self updateLayoutAtBegin:NO];
    self.btnSave.selected = textView.text.length==0;
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
