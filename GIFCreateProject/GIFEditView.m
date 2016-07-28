//
//  GIFEditView.m
//  GIFCreateProject
//
//  Created by lsy on 16/7/26.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import "GIFEditView.h"
#import "GIFView.h"

@interface GIFEditView ()

@property (strong, nonatomic) IBOutlet GIFView *gifImageView;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *rotateButton;
@property (strong, nonatomic) IBOutlet UIButton *scaleButton;

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
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:panRecognizer];
    UIPinchGestureRecognizer *pinchRecogizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self addGestureRecognizer:pinchRecogizer];
}

- (void)initGIFViews {
    [self.gifImageView setModels:self.model];
    [self.gifImageView startAnimating];
}

- (void)setModel:(GIFModel *)model {
    _model = model;
    [self initGIFViews];
}

#pragma -mark UIGestureRecoginzer
- (void)handlePan:(id)sender {
    if ([sender isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)sender;
        CGPoint translation = [recognizer translationInView:self.superview];
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
        [recognizer setTranslation:CGPointZero inView:self.superview];
    }
}

- (void)handlePinch:(id)sender {
    if ([sender isKindOfClass:[UIPinchGestureRecognizer class]]) {
        UIPinchGestureRecognizer *recognizer = (UIPinchGestureRecognizer *)sender;
        recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
        recognizer.scale = 1;
    }
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
