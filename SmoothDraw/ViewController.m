//
//  ViewController.m
//  SmoothDraw
//
//  Created by sunshuaikun on 17/3/3.
//  Copyright © 2017年 sunshuaikun. All rights reserved.
//

#import "ViewController.h"
#import "SKSmoothDrawingView.h"
@interface ViewController (){
    SKSmoothDrawingView *_drawingView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _drawingView = [[SKSmoothDrawingView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height-30)];
    _drawingView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_drawingView];
    
    UIButton *resetButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, 22, 50, 22)];
    [resetButton setTitle:@"reset" forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [_drawingView addSubview:resetButton];
    
   /* UIButton *exportButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 22, 60, 22)];
    [exportButton setTitle:@"export" forState:UIControlStateNormal];
    [exportButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [exportButton addTarget:self action:@selector(exportImage) forControlEvents:UIControlEventTouchUpInside];
    [_drawingView addSubview:exportButton];
    */
}

- (void)reset
{
    [_drawingView reset];
}

- (void)exportImage{
    UIImage *image = _drawingView.drawImageView.image;
    if (image != nil) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didExportWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didExportWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message = @"Image successfully saved to photo album";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    if (error) {
        message = [NSString stringWithFormat:@"Couldn't save image.\n%@", [error localizedDescription]];
        [alert setMessage:message];
        [alert setCancelButtonIndex:[alert addButtonWithTitle:@"Ok"]];
    } else {
        [alert setCancelButtonIndex:[alert addButtonWithTitle:@"Done"]];
    }
    
    [alert show];
    alert = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
