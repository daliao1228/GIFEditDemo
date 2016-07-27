//
//  GIFView.m
//  GIFCreateProject
//
//  Created by lsy on 16/7/26.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import "GIFView.h"

@interface GIFView ()

@property (strong, nonatomic) GIFModel *model;

@end

@implementation GIFView

- (instancetype)initWithFrame:(CGRect )frame gifModel:(GIFModel *)model {
    self = [super initWithFrame:frame];
    if (self) {
        _model = model;
        [self makeAnimationsConfig];
    }
    return self;
}

- (void)setModels:(GIFModel *)model {
    self.model = model;
    [self makeAnimationsConfig];
}

- (void)makeAnimationsConfig {
    if (self.isAnimating) {
        [self stopAnimating];
        self.animationImages = nil;
    }
    self.animationRepeatCount = 0;
    self.animationDuration = 0.3;
    self.animationImages = [self.model.images copy];
}

@end
