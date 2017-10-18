//
//  inputAccessoryView.h
//  InputAccessoryView-WindowLayer
//
//  Created by shake on 14/11/14.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UUInputConfiger;

typedef void(^UUInputViewResultBlock) (NSString * _Nullable contentStr);

typedef void(^UUInputAccessoryConfige) (UUInputConfiger *configer);


@interface UUKeyboardInputView : NSObject

+ (void)dimiss;

+ (void)showBlock:(UUInputViewResultBlock)block;

+ (void)showKeyboardType:(UIKeyboardType)type
                   block:(UUInputViewResultBlock)block;

+ (void)showKeyboardType:(UIKeyboardType)type
                 content:(nullable NSString *)content
                   block:(UUInputViewResultBlock)block;

// more flexible config
+ (void)showKeyboardConfige:(nullable UUInputAccessoryConfige)confige
                      block:(UUInputViewResultBlock)block;

@end


@interface UUInputConfiger : NSObject

// default UIKeyboardTypeDefault
@property (nonatomic) UIKeyboardType keyboardType;
// default nil
@property (copy, nonatomic, nullable) NSString *content;
// default YES
@property (nonatomic) BOOL backgroundUserInterface;
// default clearColor
@property (strong, nonatomic, nullable) UIColor *backgroundColor;

@end

NS_ASSUME_NONNULL_END

