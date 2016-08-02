//
//  GIFEditView.m
//  GIFCreateProject
//
//  Created by lsy on 16/7/26.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import "GIFEditView.h"
#import "GIFView.h"

#define MAXSCALE ([UIScreen mainScreen].bounds.size.width - 10) / 100
#define MINSCALE 0.25f

@interface GIFEditView () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet GIFView *gifImageView;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *rotateAndScaleButton;
@property (strong, nonatomic) IBOutlet UIButton *flipButton;
@property (strong, nonatomic) IBOutlet UIView *topLines;
@property (strong, nonatomic) IBOutlet UIView *leftLines;
@property (strong, nonatomic) IBOutlet UIView *bottomLines;
@property (strong, nonatomic) IBOutlet UIView *rightLines;

@property (strong, nonatomic) UIPanGestureRecognizer *panRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer *rotateButtonPanRecognizer;
@property (strong, nonatomic) UIPinchGestureRecognizer *pinchRecognizer;
@property (strong, nonatomic) UIRotationGestureRecognizer *rotationRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (assign, nonatomic) BOOL isEditing;
@property (assign, nonatomic) CGFloat towPointPinchDistance;
@property (assign, nonatomic) CGPoint lastPointPosition;
@property (assign, nonatomic) CGFloat originCenterDistance;
@property (strong, nonatomic) NSArray *array;
@property (weak, nonatomic) NSTimer *editTimer;

@end

@implementation GIFEditView

+ (GIFEditView *)view {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:[self description] owner:self options:nil];
    for (id nib in nibs) {
        if ([nib isKindOfClass:self]) {
            return nib;
        }
    }
    return nil;
}

+ (GIFEditView *)viewWithFrame:(CGRect )frame model:(GIFModel *)model {
    GIFEditView *view = [GIFEditView view];
    view.frame = frame;
    view.model = model;
    return view;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSomeGestures];
}

- (void)dealloc {
    _editTimer = nil;
}

- (void)initSomeGestures {
    if (!self.panRecognizer) {
        self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        self.panRecognizer.delegate = self;
        [self addGestureRecognizer:self.panRecognizer];
    }
    if (!self.pinchRecognizer) {
        self.pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        self.panRecognizer.delegate = self;
        [self addGestureRecognizer:self.pinchRecognizer];
    }
    if (!self.rotationRecognizer) {
        self.rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
        self.panRecognizer.delegate = self;
        [self addGestureRecognizer:self.rotationRecognizer];
    }
    
    if (!self.rotateButtonPanRecognizer) {
        self.rotateButtonPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotatePan:)];
        self.panRecognizer.delegate = self;
        [self.rotateAndScaleButton addGestureRecognizer:self.rotateButtonPanRecognizer];
    }
    
    if (!self.tapRecognizer) {
        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        self.tapRecognizer.delegate = self;
        [self addGestureRecognizer:self.tapRecognizer];
    }
    
}

- (void)initGIFViews {
    [self.gifImageView setModels:self.model];
    [self.gifImageView startAnimating];
    CGPoint rightBottomPoint = CGPointMake(self.center.x + self.bounds.size.width / 2, self.center.y + self.bounds.size.height / 2);
    self.originCenterDistance = [self caculateTwoPointDistance:self.center secondPoint:rightBottomPoint];
}

#pragma -mark Actions
- (IBAction)deleteButtonTapped:(id)sender {
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (IBAction)flipButtonClicked:(id)sender {
    self.model.isFlipped = !self.model.isFlipped;
    if (self.model.isFlipped) {
        self.gifImageView.transform = CGAffineTransformMakeScale(-1.f, 1.f);
    } else {
        self.gifImageView.transform = CGAffineTransformMakeScale(1.f, 1.f);
    }
}

#pragma -mark OverrideMethod
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(self.deleteButton.frame, point)) {
        return self.deleteButton;
    } else if (CGRectContainsPoint(self.rotateAndScaleButton.frame, point)) {
        return self.rotateAndScaleButton;
    } else if (CGRectContainsPoint(self.flipButton.frame, point)) {
        return self.flipButton;
    }
    
    return [super hitTest:point withEvent:event];
}

#pragma -mark AboutTimer
- (void)startEditTimer {
    if ([self.editTimer isValid] && self.editTimer != nil) {
        [self.editTimer invalidate];
        self.editTimer = nil;
    }
    self.editTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(endEdit) userInfo:nil repeats:NO];
}

- (void)stopEditTimer {
    [self.editTimer invalidate];
    self.editTimer = nil;
}

- (void)showEditButtons {
    self.deleteButton.hidden = NO;
    self.flipButton.hidden = NO;
    self.rotateAndScaleButton.hidden = NO;
    self.topLines.hidden = NO;
    self.leftLines.hidden = NO;
    self.bottomLines.hidden = NO;
    self.rightLines.hidden = NO;
}

- (void)hideEditButtons {
    self.deleteButton.hidden = YES;
    self.flipButton.hidden = YES;
    self.rotateAndScaleButton.hidden = YES;
    self.topLines.hidden = YES;
    self.leftLines.hidden = YES;
    self.bottomLines.hidden = YES;
    self.rightLines.hidden = YES;
}

- (void)beginEdit {
    if (!self.isEditing) {
        [self showEditButtons];
        [self startEditTimer];
        self.isEditing = YES;
    }
}

- (void)endEdit {
    if (self.isEditing) {
        self.isEditing = NO;
        [self hideEditButtons];
        [self stopEditTimer];
    }
}

#pragma -mark UIGestureRecoginzers

- (void)handleTap:(id)sender {
    if (sender == self.tapRecognizer) {
        [self beginEdit];
    }
}

- (void)handlePan:(id)sender {
    if (sender == self.panRecognizer) {
        CGPoint translation = [self.panRecognizer translationInView:self.superview];
        self.panRecognizer.view.center = CGPointMake(self.panRecognizer.view.center.x + translation.x,
                                                     self.panRecognizer.view.center.y + translation.y);
        [self.panRecognizer setTranslation:CGPointZero inView:self.superview];
        [self beginEdit];
    }
}

- (void)handlePinch:(id)sender {
    if (sender == self.pinchRecognizer) {
        if (self.pinchRecognizer.numberOfTouches != 2) {
            return;
        }
        CGPoint pointOne = [self.pinchRecognizer locationOfTouch:0 inView:self];
        CGPoint pointTwo = [self.pinchRecognizer locationOfTouch:1 inView:self];
        CGFloat distance = [self caculateTwoPointDistance:pointOne secondPoint:pointTwo];
        if (self.pinchRecognizer.state == UIGestureRecognizerStateBegan) {
            self.towPointPinchDistance = distance;
        } else if (self.pinchRecognizer.state == UIGestureRecognizerStateChanged) {
            CGFloat scale = distance / self.towPointPinchDistance;
            self.towPointPinchDistance = distance;
            
            CGRect bounds = self.pinchRecognizer.view.bounds;
            CGFloat currentScale = self.bounds.size.width * scale / 100;
            
            CGFloat finalScale = MAX(MIN(MAXSCALE, currentScale), MINSCALE);
            bounds.size.width = 100 * finalScale;
            bounds.size.height = 100 * finalScale;
            self.bounds = bounds;
        }
        [self beginEdit];
    }
}

- (void)handleRotate:(id)sender {
    if(sender == self.rotationRecognizer) {
        CGFloat rotatation = self.rotationRecognizer.rotation;
        self.transform = CGAffineTransformRotate(self.transform, rotatation);
        self.rotationRecognizer.rotation = 0;
        [self beginEdit];
    }
}

- (void)handleRotatePan:(id)sender {
    if (sender == self.rotateButtonPanRecognizer) {
        CGPoint currentTouchPosition = [self.rotateButtonPanRecognizer locationInView:self.superview];
        if (self.rotateButtonPanRecognizer.state == UIGestureRecognizerStateBegan) {
            self.lastPointPosition = currentTouchPosition;
        } else if (self.rotateButtonPanRecognizer.state == UIGestureRecognizerStateChanged) {
            
            CGPoint center = self.center;
            CGRect bounds = self.bounds;
            
            CGFloat rotation = [self angleWithPoint:center pointA:self.lastPointPosition pointB:currentTouchPosition];
            self.transform = CGAffineTransformRotate(self.transform, rotation);
            self.lastPointPosition = currentTouchPosition;
            
            CGFloat distance = [self caculateTwoPointDistance:center secondPoint:currentTouchPosition];
            CGFloat scale = distance / self.originCenterDistance;
            bounds.size.width = 100 * scale;
            bounds.size.height = 100 * scale;
            
            self.bounds = bounds;
            [self beginEdit];
        }
    }
}

#pragma -mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ((gestureRecognizer == self.pinchRecognizer && otherGestureRecognizer == self.rotationRecognizer) ||
        (gestureRecognizer == self.rotationRecognizer && otherGestureRecognizer == self.pinchRecognizer)) {
        return YES;
    }
    return NO;
}

#pragma -mark Setter & Getter
- (void)setModel:(GIFModel *)model {
    _model = model;
    [self initGIFViews];
}

#pragma -mark PrivateMethod
/**
 * 计算从A点到B点的距离
 */
- (CGFloat)caculateTwoPointDistance:(CGPoint)firstPoint secondPoint:(CGPoint)secondPoint {
    CGFloat XDistance = (firstPoint.x - secondPoint.x) * (firstPoint.x - secondPoint.x);
    CGFloat YDistance = (firstPoint.y - secondPoint.y) * (firstPoint.y - secondPoint.y);
    return sqrt(XDistance + YDistance);
}

/**
 * 计算从line(p0, pointA) 到 line(p0, pointB) 之间的夹角
 */
- (CGFloat)angleWithPoint:(CGPoint)p0 pointA:(CGPoint)pointA pointB:(CGPoint)pointB {
    return atan2f(pointB.y - p0.y, pointB.x - p0.x) - atan2f(pointA.y - p0.y, pointA.x - p0.x);
}

@end
