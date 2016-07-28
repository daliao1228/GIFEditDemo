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
}

- (void)setModel:(GIFModel *)model {
    _model = model;
    [self initGIFViews];
}

- (void)initGIFViews {
    [self.gifImageView setModels:self.model];
    [self.gifImageView startAnimating];
}

@end
