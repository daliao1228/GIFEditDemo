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

@interface GIFEditView ()

@property (strong, nonatomic) IBOutlet GIFView *gifImageView;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *rotateButton;
@property (strong, nonatomic) IBOutlet UIButton *scaleButton;
@property (strong, nonatomic) UIPanGestureRecognizer *panRecognizer;
@property (strong, nonatomic) UIPinchGestureRecognizer *pinchRecognizer;
@property (strong, nonatomic) UIRotationGestureRecognizer *rotationRecognizer;
@property (assign, nonatomic) CGFloat towPointPinchDistance;

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

- (void)initSomeGestures {
    if (!self.panRecognizer) {
        self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:self.panRecognizer];
    }
    if (!self.pinchRecognizer) {
        self.pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [self addGestureRecognizer:self.pinchRecognizer];
    }
}

- (void)initGIFViews {
    [self.gifImageView setModels:self.model];
    [self.gifImageView startAnimating];
}

- (void)setModel:(GIFModel *)model {
    _model = model;
    [self initGIFViews];
}

#pragma -mark UIGestureRecoginzers
- (void)handlePan:(id)sender {
    if (sender == self.panRecognizer) {
        CGPoint translation = [self.panRecognizer translationInView:self.superview];
        self.panRecognizer.view.center = CGPointMake(self.panRecognizer.view.center.x + translation.x,
                                                     self.panRecognizer.view.center.y + translation.y);
        [self.panRecognizer setTranslation:CGPointZero inView:self.superview];
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
    }
}

- (CGFloat )caculateTwoPointDistance:(CGPoint)firstPoint secondPoint:(CGPoint)secondPoint {
    CGFloat XDistance = (firstPoint.x - secondPoint.x) * (firstPoint.x - secondPoint.x);
    CGFloat YDistance = (firstPoint.y - secondPoint.y) * (firstPoint.y - secondPoint.y);
    return sqrt(XDistance + YDistance);
}

- (IBAction)deleteButtonTapped:(id)sender {
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (IBAction)rotateButtonTapped:(id)sender {
    
}

- (IBAction)scaleButtonTapped:(id)sender {
    
}

@end
