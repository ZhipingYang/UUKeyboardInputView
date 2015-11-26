UUKeyboardInputView
---

> **It helps some viewes,like button、cell、segment, which cann't respond those inputView as textField or texeView them do.**

### Simple application
![Flipboard playing multiple GIFs](https://github.com/ZhipingYang/UUKeyboardInputView/raw/master/UUKeyboardInputViewTests/inputView.gif)

## Installation
```
+ (void)showBlock:(UUInputAccessoryBlock)block;


+ (void)showKeyboardType:(UIKeyboardType)type
                   Block:(UUInputAccessoryBlock)block;


+ (void)showKeyboardType:(UIKeyboardType)type
                 content:(NSString *)content
                   Block:(UUInputAccessoryBlock)block;
```

####UIKeyboardType
 - UIKeyboardTypeDefault,              
 - UIKeyboardTypeNumbersAndPunctuation,
 - UIKeyboardTypeNumberPad,            
 - UIKeyboardTypeNamePhonePad ...

## Usage

```
[UUInputAccessoryView showKeyboardType:type
                               content:content
                                 Block:^(NSString *contentStr)
{
     if (contentStr.length == 0) return ;
    //code
}];

[UUInputAccessoryView showBlock:^(NSString *contentStr) {
    //code
}];
```