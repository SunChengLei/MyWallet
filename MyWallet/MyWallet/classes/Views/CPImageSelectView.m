//
//  CPImageSelectView.m
//  MyWallet
//
//  Created by 美鑫科技 on 16/6/24.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import "CPImageSelectView.h"

@interface CPImageSelectView ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation CPImageSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = frame.size.width / 2.0;
        self.userInteractionEnabled = YES;
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selPic"]];
        img.userInteractionEnabled = YES;
        img.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        img.layer.masksToBounds = YES;
        img.layer.cornerRadius = frame.size.width / 2.0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [img addGestureRecognizer:tap];
        [self addSubview:img];
        self.image = [UIImage imageNamed:@"moren.jpeg"];
    }
    return self;
}

- (void)tapClick:(UIGestureRecognizer *)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择头像" message:@"选择头像资源" preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"相册选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self openAlbum];
    }];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }];
    [alert addAction:cancel];
    [alert addAction:album];
    [alert addAction:camera];
    [[self viewController:self] presentViewController:alert animated:YES completion:nil];
}

// 打开相册
- (void)openAlbum{
    UIImagePickerController *pic = [UIImagePickerController new];
    // 设置资源类型为相册
    pic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pic.delegate = self;
    pic.allowsEditing = YES;
    [[self viewController:self] presentViewController:pic animated:YES completion:nil];
}

// 打开相机
- (void)openCamera{
    UIImagePickerController *pic = [UIImagePickerController new];
    // 设置资源类型为照相机
    pic.sourceType = UIImagePickerControllerSourceTypeCamera;
    pic.delegate = self;
    pic.allowsEditing = YES;
    [[self viewController:self] presentViewController:pic animated:YES completion:nil];
}

// 获取view所在的控制器
- (UIViewController*)viewController:(UIView *)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.image = img;
    [[self viewController:self] dismissViewControllerAnimated:YES completion:nil];
}

@end
