//
//  PhotoChooseViewController.m
//  GIFCreateProject
//
//  Created by lsy on 16/7/26.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import "PhotoChooseViewController.h"
#import "GIFModel.h"
#import "GIFEditView.h"

@interface PhotoChooseViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (strong, nonatomic) UIImage *pickerImage;
@property (strong, nonatomic) GIFEditView *gifView;

@end

@implementation PhotoChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedImageView.hidden = YES;
}

- (IBAction)chooseImageButtonTapped:(id)sender {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
    controller.allowsEditing = NO;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)addGifButtonTapped:(id)sender {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"gif" ofType:@"bundle"];
    if (bundlePath) {
        NSString *configString = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/10002/params.txt", bundlePath] encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [configString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *gifConfig = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        GIFModel *model = [GIFModel makeGifModelWithDict:gifConfig];
        self.gifView = [GIFEditView viewWithFrame:CGRectMake(100, 100, 100, 100) model:model];
        [self.view addSubview:self.gifView];
    }
}

- (IBAction)saveButtonTapped:(id)sender {
    if (self.pickerImage == nil) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择要处理的图片" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:controller animated:YES completion:nil];
        return;
    }
    GIFPasterPasteModel *model = [self.gifView generateGIFModel];
}

#pragma -mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.pickerImage = [image copy];
    self.selectedImageView.image = image;
    self.selectedImageView.hidden = NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
