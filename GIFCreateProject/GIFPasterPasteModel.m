//
//  GIFPasterPasteModel.m
//  GIFCreateProject
//
//  Created by lsy on 16/8/2.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import "GIFPasterPasteModel.h"

@implementation GIFPasterPasteModel

+ (GIFPasterPasteModel *)generateModel:(CGPoint)center
                                height:(CGFloat)height
                                 width:(CGFloat)width
                           imageArrays:(NSArray *)imageArrays
                            imageCount:(NSInteger)imageCount {
    
    GIFPasterPasteModel *model = [[GIFPasterPasteModel alloc] init];
    model.center = center;
    model.height = height;
    model.width = width;
    model.imageArrays = imageArrays;
    model.imageCount = imageCount;
    return model;
}

@end
