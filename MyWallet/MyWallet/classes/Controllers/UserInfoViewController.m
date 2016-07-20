//
//  UserInfoViewController.m
//  MyWallet
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,CPAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *pictureImageVIew;
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UITextField *txtBalance;

@property (nonatomic, assign) CGRect oFrame;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"编辑资料";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"save"] style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
    self.nameTextfield.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"uName"];
    UIImage *img = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserHeader"]];
    self.imgHeader.image = img;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeHeaderDetail:)];
    self.imgHeader.userInteractionEnabled = YES;
    [self.imgHeader addGestureRecognizer:tap];
    self.imgHeader.layer.masksToBounds = YES;
    self.imgHeader.layer.cornerRadius = 20;
    self.txtBalance.text = [NSString stringWithFormat:@"%.2f", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Money"] doubleValue]];
    
}

// 查看大图头像
- (void)seeHeaderDetail:(UITapGestureRecognizer *)sender{
    UIImageView *view = (UIImageView *)sender.view;
    if (view.image == nil) {
        return;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
    CGRect oldframe = [view convertRect:view.bounds toView:window];
    self.oFrame = oldframe;
    backgroudView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.6];
    backgroudView.alpha = 1;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:oldframe];
    imgView.tag = 150;
    imgView.image = view.image;
    imgView.contentMode = UIViewContentModeScaleToFill;
    view.clipsToBounds = YES;
    [backgroudView addSubview:imgView];
    [window addSubview:backgroudView];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroudView addGestureRecognizer: tap];
    [UIView animateWithDuration:0.3 animations:^{
        imgView.frame = CGRectMake(0,([UIScreen mainScreen].bounds.size.height - imgView.image.size.height*[UIScreen mainScreen].bounds.size.width/ imgView.image.size.width)/2, [UIScreen mainScreen].bounds.size.width, imgView.image.size.height * [UIScreen mainScreen].bounds.size.width/imgView.image.size.width);
        backgroudView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

// 隐藏大图头像
- (void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:150];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = self.oFrame;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

// 保存修改
- (void)saveClick{
    if ([[UserManager manager] editUserWithPic:self.imgHeader.image UnickName:self.nameTextfield.text]) {
        [[NSUserDefaults standardUserDefaults] setObject:self.txtBalance.text forKey:@"Money"];
        [[NSUserDefaults standardUserDefaults] setObject:self.nameTextfield.text forKey:@"uName"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDrawData" object:nil];
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"修改成功!" delegate:self style:(CPAlertViewStyleDefault) buttons:@"好的", nil];
        [alert show];
        return;
    } else{
        CPAlertView *alert = [[CPAlertView alloc] initWithTitle:@"提示" message:@"修改失败!" delegate:self style:(CPAlertViewStyleDefault) buttons:@"知道了", nil];
        [alert show];
        return;
    }
}

// 更新数据
- (void)reloadData{
    self.nameTextfield.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"uName"];
    UIImage *img = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserHeader"]];
    self.imgHeader.image = img;
    self.txtBalance.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"Money"];
}

// 修改头像
- (IBAction)action2UpHeader:(UIButton *)sender {
    
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
    [self presentViewController:alert animated:YES completion:nil];
    
}

// 打开相册
- (void)openAlbum{
    UIImagePickerController *pic = [UIImagePickerController new];
    // 设置资源类型为相册
    pic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pic.delegate = self;
    pic.allowsEditing = YES;
    [self presentViewController:pic animated:YES completion:nil];
}

// 打开相机
- (void)openCamera{
    UIImagePickerController *pic = [UIImagePickerController new];
    // 设置资源类型为照相机
    pic.sourceType = UIImagePickerControllerSourceTypeCamera;
    pic.delegate = self;
    pic.allowsEditing = YES;
    [self presentViewController:pic animated:YES completion:nil];
}

#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.imgHeader.image = img;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
