//
//  GIFEditView.h
//  GIFCreateProject
//
//  Created by lsy on 16/7/26.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIFModel.h"
#import "GIFPasterPasteModel.h"

@interface GIFEditView : UIView

@property (strong, nonatomic) GIFModel *model;

+ (GIFEditView *)viewWithFrame:(CGRect )frame model:(GIFModel *)model;

- (GIFPasterPasteModel *)generateGIFModel;

@end
