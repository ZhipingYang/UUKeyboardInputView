UUKeyboardInputView
---

> **It helps some viewes,like button、cell、segment, which cann't respond those inputView as textField or texeView them do.**

### Simple application

![Flipboard playing multiple GIFs](https://github.com/ZhipingYang/UUKeyboardInputView/raw/master/Demo/UUKeyboardInputViewTests/inputView.gif)

**apply with scrollview**

![Flipboard playing multiple GIFs](https://github.com/ZhipingYang/UUKeyboardInputView/raw/master/Demo/UUKeyboardInputViewTests/inputView2.gif)

## API
```objective-c

+ (void)showBlock:(UUInputViewResultBlock)block;

+ (void)showKeyboardType:(UIKeyboardType)type
                   block:(UUInputViewResultBlock)block;

+ (void)showKeyboardType:(UIKeyboardType)type
                 content:(nullable NSString *)content
                   block:(UUInputViewResultBlock)block;

// more flexible config
+ (void)showKeyboardConfige:(nullable UUInputAccessoryConfige)confige
                      block:(UUInputViewResultBlock)block;
```

#### UIKeyboardType
 - UIKeyboardTypeDefault,
 - UIKeyboardTypeNumbersAndPunctuation,
 - UIKeyboardTypeNumberPad,
 - UIKeyboardTypeNamePhonePad ...

## Usage

```objective-c
    [UUInputAccessoryView showKeyboardConfige:^(UUInputConfiger * _Nonnull configer) {
        configer.keyboardType = UIKeyboardTypeNumberPad;
        configer.content = @"content";
        configer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];

    } block:^(NSString * _Nonnull contentStr) {
        // code
        if (contentStr.length == 0) return ;
        
    }];
```

## Installation

UUKeyboardInputView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "UUKeyboardInputView"
```

## Author

XcodeYang, xcodeyang@gmail.com

## License

UUKeyboardInputView is available under the MIT license. See the LICENSE file for more info.
