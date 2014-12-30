UUKeyboardInputView
===================

It helps some view who isn't have textField or texeView to input words

###apply in my app
![Flipboard playing multiple GIFs](https://github.com/ZhipingYang/UUKeyboardInputView/raw/master/UUKeyboardInputViewTests/inputView.gif)

## Installation

  + (void)showBlock:(UUInputAccessoryBlock)block;
  + (void)showKeyboardType:(UIKeyboardType)type Block:(UUInputAccessoryBlock)block;

####UIKeyboardType
 - UIKeyboardTypeDefault,              
 - UIKeyboardTypeNumbersAndPunctuation,
 - UIKeyboardTypeNumberPad,            
 - UIKeyboardTypeNamePhonePad ...

## Usage

    [UUInputAccessoryView showKeyboardType:UIKeyboardTypeNamePhonePad
                                     Block:^(NSString *contentStr) {
            if (contentStr.length==0) return ;
            //code
       }];
    
    [UUInputAccessoryView showBlock:^(NSString *contentStr) {
          //code
      }];
