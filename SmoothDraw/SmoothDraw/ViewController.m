//
//  ViewController.m
//  SmoothDraw
//
//  Created by sunshuaikun on 17/3/3.
//  Copyright © 2017年 sunshuaikun. All rights reserved.
//

#import "ViewController.h"
#import "SKSmoothDrawingView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    SKSmoothDrawingView *drawingView = [[SKSmoothDrawingView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height-30)];
    drawingView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:drawingView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
