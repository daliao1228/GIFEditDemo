//
//  GIFPasterPasteModel.h
//  GIFCreateProject
//
//  Created by lsy on 16/8/2.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GIFPasterPasteModel : NSObject

@property (assign, nonatomic) CGPoint center;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGFloat width;
@property (strong, nonatomic) NSArray *imageArrays;
@property (assign, nonatomic) NSInteger imageCount;

+ (GIFPasterPasteModel *)generateModel:(CGPoint)center
                                height:(CGFloat)height
                                 width:(CGFloat)width
                           imageArrays:(NSArray *)imageArrays
                            imageCount:(NSInteger)imageCount;

@end
