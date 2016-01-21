//
//  TableViewController.m
//  UUKeyboardInputView
//
//  Created by XcodeYang on 11/26/15.
//  Copyright © 2015 uyiuyao. All rights reserved.
//

#import "TableViewController.h"
#import "UUInputAccessoryView.h"

static NSString *cellIdentifier = @"CellID";

@interface TableViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *colorTableView;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.colorTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    self.colorTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.contentView.backgroundColor = [UIColor colorWithRed:[self randomFloat] green:[self randomFloat] blue:[self randomFloat] alpha:1];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    __weak typeof(cell) weakCell = cell;

    [UUInputAccessoryView showKeyboardConfige:^(UUInputConfiger * _Nonnull configer) {
        configer.backgroundUserInterface = NO;
        configer.content = weakCell.textLabel.text;
    } block:^(NSString * _Nonnull contentStr) {
        weakCell.textLabel.text = contentStr;
    }];
}

- (CGFloat)randomFloat
{
    CGFloat num = arc4random()%40+50;
    return num/100.f;
}

@end
