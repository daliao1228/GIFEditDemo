//
//  UIAlertController+Block.h
//  UIAlertController+Block
//
//  Created by lsy on 16/8/5.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Block)

typedef void (^completionBlock) (UIAlertController *controller, UIAlertAction *action, NSInteger ButtonIndex);

+ (void)showAlertViewInViewController:(UIViewController *)viewController
                            WithTitle:(NSString *)title
                              message:(NSString *)message
                       preferredStyle:(UIAlertControllerStyle)style
                      completionBlock:(completionBlock)block
                    cancelButtonTitle:(NSString *)cancelButtonTitle
               destructiveButtonTitle:(NSString *)destructiveButtonTitle
                    otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
