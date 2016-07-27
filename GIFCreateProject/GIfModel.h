//
//  GIfModel.h
//  GIFCreateProject
//
//  Created by lsy on 16/7/26.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GIFModel : NSObject

@property (strong, nonatomic) NSString *folderName;
@property (assign, nonatomic) NSInteger frameDuration;
@property (assign, nonatomic) NSInteger totalFrame;
@property (assign, nonatomic) float gifHeight;
@property (assign, nonatomic) BOOL showUntilFinish;
@property (strong, nonatomic) NSMutableArray <UIImage *> *images;

+ (GIFModel *)makeGifModelWithDict:(NSDictionary *)dict;

@end
