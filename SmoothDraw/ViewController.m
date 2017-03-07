//
//  ViewController.m
//  SmoothDraw
//
//  Created by sunshuaikun on 17/3/3.
//  Copyright © 2017年 sunshuaikun. All rights reserved.
//
#import <AssetsLibrary/ALAsset.h>
#import "ViewController.h"
#import "SKSmoothDrawingView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ViewController (){
    SKSmoothDrawingView *_drawingView;
}

@end

@implementation ViewController

- (void)loadView
{
    [super loadView];
    _drawingView = [[SKSmoothDrawingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  [UIScreen mainScreen].bounds.size.height)];
    _drawingView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_drawingView];
    
    UIButton *resetButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, SCREEN_HEIGHT-30, 50, 30)];
    [resetButton setTitle:@"reset" forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [_drawingView addSubview:resetButton];
    
    UIButton *exportButton = [[UIButton alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT-30, 60, 30)];
    [exportButton setTitle:@"export" forState:UIControlStateNormal];
    [exportButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [exportButton addTarget:self action:@selector(exportImage) forControlEvents:UIControlEventTouchUpInside];
    [_drawingView addSubview:exportButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)reset
{
    [_drawingView reset];
}

- (void)exportImage{
    UIImage *image = _drawingView.drawImageView.image;
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    ALAssetsLibraryWriteImageCompletionBlock imageWriteCompletionBlock =
    ^(NSURL *newURL, NSError *error) {
        NSString *message = nil;
        UIAlertAction *alertAction = nil;
        if (error) {
            message = [NSString stringWithFormat:@"Error writing image to Photo Library: %@", error];
            alertAction = [UIAlertAction actionWithTitle:@"done" style:UIAlertActionStyleCancel handler:nil];
        } else {
            message = @"Success writing image to Photo Library";
            alertAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:YES completion:nil];
    };
    
    [library writeImageToSavedPhotosAlbum:[image CGImage]
                                 metadata:nil
                          completionBlock:imageWriteCompletionBlock];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
