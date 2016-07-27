//
//  GIFView.h
//  GIFCreateProject
//
//  Created by lsy on 16/7/26.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIFModel.h"

@interface GIFView : UIImageView

- (instancetype)initWithFrame:(CGRect )frame gifModel:(GIFModel *)model;

- (void)setModels:(GIFModel *)model;

@end
