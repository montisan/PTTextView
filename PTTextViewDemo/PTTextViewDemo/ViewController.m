//
//  ViewController.m
//  PTTextViewDemo
//
//  Created by Peter on 16/4/22.
//  Copyright © 2016年 Peter. All rights reserved.
//

#import "ViewController.h"
#import "PTTextView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    PTTextView *textView = [[PTTextView alloc] initWithFrame:CGRectMake(10,100, 100, 20)];
    textView.lineSpace = 6;
    [textView setText:@"aaaa"];
    textView.layer.borderColor = [UIColor blackColor].CGColor;
    textView.layer.borderWidth = 1;
    [self.view addSubview:textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
