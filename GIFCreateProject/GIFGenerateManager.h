//
//  GIFGenerateManager.h
//  GIFCreateProject
//
//  Created by lsy on 16/8/1.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GIFPasterPasteModel.h"

@interface GIFGenerateManager : NSObject

+ (GIFGenerateManager *)shareInstance;

- (UIImage *)combineTwoImages:(UIImage *)originImage secondImage:(UIImage *)secondImage options:(GIFPasterPasteModel *)model;

@end
