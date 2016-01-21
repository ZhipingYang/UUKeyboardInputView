UUKeyboardInputView
---

> **It helps some viewes,like button、cell、segment, which cann't respond those inputView as textField or texeView them do.**

### Simple application

![Flipboard playing multiple GIFs](https://github.com/ZhipingYang/UUKeyboardInputView/raw/master/UUKeyboardInputViewTests/inputView.gif)

**apply with scrollview**

![Flipboard playing multiple GIFs](https://github.com/ZhipingYang/UUKeyboardInputView/raw/master/UUKeyboardInputViewTests/inputView2.gif)

## Installation
```
+ (void)showBlock:(UUInputAccessoryBlock _Nullable)block;

+ (void)showKeyboardType:(UIKeyboardType)type
                   Block:(UUInputAccessoryBlock _Nullable)block;

+ (void)showKeyboardType:(UIKeyboardType)type
                 content:(NSString * _Nullable)content
                   Block:(UUInputAccessoryBlock _Nullable)block;

// more flexible config
+ (void)showKeyboardConfige:(UUInputAccessoryConfige _Nullable)confige
                      block:(UUInputAccessoryBlock _Nullable)block;
```

####UIKeyboardType
 - UIKeyboardTypeDefault,              
 - UIKeyboardTypeNumbersAndPunctuation,
 - UIKeyboardTypeNumberPad,            
 - UIKeyboardTypeNamePhonePad ...

## Usage

```
    [UUInputAccessoryView showKeyboardConfige:^(UUInputConfiger * _Nonnull configer) {
        configer.keyboardType = UIKeyboardTypeNumberPad;
        configer.content = @"content";
        configer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
    }block:^(NSString * _Nonnull contentStr) {
        // code
        if (contentStr.length == 0) return ;
        
    }];
```