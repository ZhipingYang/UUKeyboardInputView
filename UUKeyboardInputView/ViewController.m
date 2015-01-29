//
//  ViewController.m
//  UUKeyboardInputView
//
//  Created by shake on 14/12/30.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "ViewController.h"
#import "UUInputAccessoryView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)click:(UIButton *)sender {
    
    UIKeyboardType type = sender.tag == 1 ? UIKeyboardTypeDefault : UIKeyboardTypeNumberPad;
    [UUInputAccessoryView showKeyboardType:type
                                     Block:^(NSString *contentStr) {
                                         if (contentStr.length==0) return ;
                                         [sender setTitle:contentStr forState:UIControlStateNormal];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
