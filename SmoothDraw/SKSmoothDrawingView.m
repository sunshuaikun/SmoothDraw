//
//  SKSmoothDrawingView.m
//  SmoothDraw
//
//  Created by sunshuaikun on 17/3/3.
//  Copyright © 2017年 sunshuaikun. All rights reserved.
//

#import "SKSmoothDrawingView.h"

#define KminThickness 0.15
#define KthicknessFactor 0.15

#define KsmoothingFactor 0.3
#define KthicknessSmoothingFactor 0.3

#define KdotRadius 1
#define KtipTaperFactor 0.1

@interface SKSmoothDrawingView (){
    int startX;
    int startY;
    
    int lastMouseX;
    int lastMouseY;
    
    int smoothedMouseX;
    int smoothedMouseY;
    
    int lastSmoothedMouseX;
    int lastSmoothedMouseY;
    
    int mouseChangeVectorX;
    int mouseChangeVectorY;
    
    int dx;
    int dy;
    
    float dist;
    
    float lastThickness;
    float lastRotation;
    
    float lastMouseChangeVectorX;
    float lastMouseChangeVectorY;
    
    float lineRotation;
    float targetLineThickness;
    float lineThickness;
    
    float L0Sin0;
    float L0Cos0;
    float L1Sin1;
    float L1Cos1;
    float sin0;
    float cos0;
    float sin1;
    float cos1;
    
    float controlVecX, controlVecY;
    float controlX1, controlY1;
    float controlX2, controlY2;
    
    CGPoint startPoint;
}
@property (nonatomic,strong)NSMutableArray *points;
@property (nonatomic,strong)NSMutableArray *pointsPool;
@end

@implementation SKSmoothDrawingView

#pragma mark - init
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _pointsPool = [[NSMutableArray alloc] init];
        self.drawImageView = [[UIImageView alloc] initWithFrame:frame];
        self.drawImageView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.drawImageView];
    }
    return self;
    
}

#pragma mark - touch event

//触摸开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _points = [[NSMutableArray alloc] init];
    [_pointsPool addObject:_points];
    UITouch* touch=[touches anyObject];
    startPoint = [touch locationInView:self];
    [self addPoint:startPoint];
    [self startDrawWithX:startPoint.x y:startPoint.y];
}
//触摸移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray* MovePointArray=[touches allObjects];
    [self addPoint:[[MovePointArray objectAtIndex:0] locationInView:self]];
  
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    UIGraphicsBeginImageContext(self.drawImageView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor darkTextColor] setStroke];
    
    [self.drawImageView.image drawInRect:CGRectMake(0, 0, self.drawImageView.frame.size.width, self.drawImageView.frame.size.height)];

    [self drawGraphyWithX:currentPoint.x y:currentPoint.y red:220/255.0
                    green:91/255.0
                     blue:44/255.0 drawTip:NO];
    
    CGContextStrokePath(context);
    self.drawImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    UIGraphicsBeginImageContext(self.drawImageView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor darkTextColor] setStroke];
    
    [self.drawImageView.image drawInRect:CGRectMake(0, 0, self.drawImageView.frame.size.width, self.drawImageView.frame.size.height)];
    
    [self drawGraphyWithX:currentPoint.x y:currentPoint.y red:220/255.0
                    green:91/255.0
                     blue:44/255.0 drawTip:YES];
    
    CGContextStrokePath(context);
    self.drawImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)addPoint:(CGPoint)point
{
    [self.points addObject:[NSValue valueWithCGPoint:point]];
}

- (void)startDrawWithX:(int)x y:(int)y
{
    startX = lastMouseX = smoothedMouseX = lastSmoothedMouseX = x;
    startY = lastMouseY = smoothedMouseY = lastSmoothedMouseY = y;
    lastThickness = 0;
    lastRotation = M_PI/2;
    
    lastMouseChangeVectorX = 0;
    lastMouseChangeVectorY = 0;
}

- (void)drawGraphyWithX:(int) x y:(int)y red:(float)red green:(float)green blue:(float)blue drawTip:(BOOL)drawTip
{
    mouseChangeVectorX = x - lastMouseX;
    mouseChangeVectorY = y - lastMouseY;
    
    if (mouseChangeVectorX*lastMouseChangeVectorX + mouseChangeVectorY*lastMouseChangeVectorY < 0) {
        smoothedMouseX = lastSmoothedMouseX = lastMouseX;
        smoothedMouseY = lastSmoothedMouseY = lastMouseY;
        lastRotation += M_PI;
        lastThickness = KtipTaperFactor*lastThickness;
    }
    
    smoothedMouseX = smoothedMouseX + KsmoothingFactor*(x - smoothedMouseX);
    smoothedMouseY = smoothedMouseY + KsmoothingFactor*(y - smoothedMouseY);
    
    dx = smoothedMouseX - lastSmoothedMouseX;
    dy = smoothedMouseY - lastSmoothedMouseY;
    
    dist = sqrt (dx*dx + dy*dy);
    
    if (dist != 0) {
        lineRotation = M_PI/2 + atan2(dy, dx);
    }
    else {
        lineRotation = 0;
    }
    //速度越快，两点间距离越长，则lineThickness越大
    targetLineThickness = KminThickness+KthicknessFactor*dist;
    lineThickness = lastThickness + KthicknessSmoothingFactor*(targetLineThickness - lastThickness);
    
    sin0 = sin(lastRotation);
    cos0 = cos(lastRotation);
    sin1 = sin(lineRotation);
    cos1 = cos(lineRotation);
    L0Sin0 = lastThickness*sin0;
    L0Cos0 = lastThickness*cos0;
    L1Sin1 = lineThickness*sin1;
    L1Cos1 = lineThickness*cos1;
    
    controlVecX = 0.33*dist*sin0;
    controlVecY = -0.33*dist*cos0;
    controlX1 = lastSmoothedMouseX + L0Cos0 + controlVecX;
    controlY1 = lastSmoothedMouseY + L0Sin0 + controlVecY;
    controlX2 = lastSmoothedMouseX - L0Cos0 + controlVecX;
    controlY2 = lastSmoothedMouseY - L0Sin0 + controlVecY;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, lastSmoothedMouseX + L0Cos0, lastSmoothedMouseY + L0Sin0);
    CGContextAddQuadCurveToPoint(context, controlX1,controlY1,smoothedMouseX + L1Cos1, smoothedMouseY + L1Sin1);
    CGContextAddLineToPoint(context,smoothedMouseX - L1Cos1, smoothedMouseY - L1Sin1);
    CGContextAddQuadCurveToPoint(context, controlX2, controlY2, lastSmoothedMouseX - L0Cos0, lastSmoothedMouseY - L0Sin0);
    CGContextAddLineToPoint(context,lastSmoothedMouseX + L0Cos0, lastSmoothedMouseY + L0Sin0);
    
    //画笔锋部分
    if (drawTip) {
        CGContextMoveToPoint(context, smoothedMouseX + L1Cos1, smoothedMouseY + L1Sin1);
        CGContextAddLineToPoint(context, x + KtipTaperFactor*L1Cos1, y + KtipTaperFactor*L1Sin1);
        CGContextAddLineToPoint(context, x - KtipTaperFactor*L1Cos1, y - KtipTaperFactor*L1Sin1);
        CGContextAddLineToPoint(context, smoothedMouseX - L1Cos1, smoothedMouseY - L1Sin1);
        CGContextAddLineToPoint(context, smoothedMouseX + L1Cos1, smoothedMouseY + L1Sin1);
    }
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0f].CGColor);
    CGContextFillPath(context);
    
    lastSmoothedMouseX = smoothedMouseX;
    lastSmoothedMouseY = smoothedMouseY;
    lastRotation = lineRotation;
    lastThickness = lineThickness;
    lastMouseChangeVectorX = mouseChangeVectorX;
    lastMouseChangeVectorY = mouseChangeVectorY;
    lastMouseX = x;
    lastMouseY = y;
}

- (void)reset
{
    [self.drawImageView setImage:nil];
}

/*
 - (void)undo
 {
 if (_graphicArr.count > 0) {
 [_graphicArr removeLastObject];
 [self setNeedsDisplay];
 }
 }
 
 - (void)clear
 {
 if (_graphicArr.count > 0) {
 [_graphicArr removeAllObjects];
 }
 [self setNeedsDisplay];
 }
 */

@end
