//
//  GIFGenerateManager.m
//  GIFCreateProject
//
//  Created by lsy on 16/8/1.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import "GIFGenerateManager.h"

@interface GIFGenerateManager ()



@end

@implementation GIFGenerateManager

+ (GIFGenerateManager *)shareInstance {
    static GIFGenerateManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GIFGenerateManager alloc] init];
    });
    return manager;
}

- (UIImage *)combineTwoImages:(UIImage *)originImage secondImage:(UIImage *)secondImage options:(GIFPasterPasteModel *)model {
    return [self combineTwoImage:originImage secondImage:secondImage options:model];
}

#pragma -mark Private Method
- (NSOperationQueue *)localOperation {
    static NSOperationQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 1;
    });
    return queue;
}

- (UIImage *)combineTwoImage:(UIImage *)firstImage secondImage:(UIImage *)secondImage options:(GIFPasterPasteModel *)model {
    CGSize size = firstImage.size;
    UIGraphicsBeginImageContext(size);
    [firstImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    [secondImage drawInRect:CGRectMake(model.center.x, model.center.y, model.width, model.height)];
    UIImage *combineImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return combineImage;
}



@end
