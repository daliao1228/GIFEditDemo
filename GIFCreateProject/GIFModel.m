//
//  GIfModel.m
//  GIFCreateProject
//
//  Created by lsy on 16/7/26.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import "GIFModel.h"

@implementation GIFModel

+ (GIFModel *)makeGifModelWithDict:(NSDictionary *)dict {
    if (dict == nil) {
        return nil;
    }
    GIFModel *model = [GIFModel new];
    if ([[dict allKeys] containsObject:@"folderName"]) {
        model.folderName = dict[@"folderName"];
    }
    
    if ([[dict allKeys] containsObject:@"frameDuration"]) {
        model.frameDuration = [dict[@"frameDuration"] integerValue];
    }
    
    if ([[dict allKeys] containsObject:@"frames"]) {
        model.totalFrame = [dict[@"frames"] integerValue];
    }
    
    if ([[dict allKeys] containsObject:@"height"]) {
        model.gifHeight = [dict[@"height"] floatValue];
    }
    
    if ([[dict allKeys] containsObject:@"showUtilFinish"]) {
        model.showUntilFinish = [dict[@"showUtilFinish"] boolValue];
    }
    
    [model readImagesFromBundle];
    
    return model;
}

- (void)readImagesFromBundle {
    self.images = [NSMutableArray array];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"gif" ofType:@"bundle"];
    if (bundlePath) {
        NSString *fullImagePath = [NSString stringWithFormat:@"%@/10002/%@", bundlePath, self.folderName];
        for(NSInteger i = 0; i < self.totalFrame; i++) {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@_%ld.png", fullImagePath, self.folderName, i]];
            if (image) {
                [self.images addObject:image];
            }
        }
    }
}

@end
