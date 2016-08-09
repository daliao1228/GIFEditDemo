//
//  UIAlertController+Block.m
//  UIAlertController+Block
//
//  Created by lsy on 16/8/5.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import "UIAlertController+Block.h"

@implementation UIAlertController (Block)

+ (void)showAlertViewInViewController:(UIViewController *)viewController
                            WithTitle:(NSString *)title
                              message:(NSString *)message
                       preferredStyle:(UIAlertControllerStyle)style
                      completionBlock:(completionBlock)block
                    cancelButtonTitle:(NSString *)cancelButtonTitle
               destructiveButtonTitle:(NSString *)destructiveButtonTitle
                    otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    NSInteger buttonIndex = 0;
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    if (cancelButtonTitle) {
        buttonIndex ++;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            if (block) {
                block(controller, cancelAction, buttonIndex);
            }
        }];
        [controller addAction:cancelAction];
    }
    
    if (destructiveButtonTitle) {
        buttonIndex ++;
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            if (block) {
                block(controller, destructiveAction, buttonIndex);
            }
        }];
        [controller addAction:destructiveAction];
    }
    
    if (otherButtonTitles) {
        va_list vars;
        va_start(vars, otherButtonTitles);
        for (NSString *buttonTitle; buttonTitle != nil; va_arg(vars, NSString *)) {
            buttonIndex ++;
            UIAlertAction *action = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (block) {
                    block(controller, action, buttonIndex);
                }
            }];
            [controller addAction:action];
        }
    }
    
    [viewController presentViewController:controller animated:YES completion:nil];
    
}

@end
