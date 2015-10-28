//
//  WXZPersonalCertificationVC.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/26.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPersonalCertificationVC.h"
#import "AFNetworking.h"

@interface WXZPersonalCertificationVC () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idCardTextField;
@property (weak, nonatomic) IBOutlet UIImageView *idCardImgView;
@property (weak, nonatomic) IBOutlet UIProgressView *uploadProgress;
@end

@implementation WXZPersonalCertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    // 添加标题，设置标题的颜色和字号
    self.navigationItem.title = @"实名认证";
    
    self.nameTextField.text = self.certificationTitle;
}

- (IBAction)idCardAction:(id)sender
{
    NSLog(@"身份证照");
    UIActionSheet *photosSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [photosSheet showInView:self.view];
}

// 修改手机号请求
- (void)modifyRequestWithParameter1:(NSString *)param1 parameter:(NSString *)param2
{
    NSString *nameUrlStr = [OutNetBaseURL stringByAppendingString:jinjirenxiugaishoujihao];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:param1 forKey:@"yzm"]; // 就手机号发送的验证码
    [param setObject:param2 forKey:@"mob"]; // 新手机号
    
    [[AFHTTPSessionManager manager] POST:nameUrlStr parameters:param success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if ([responseObject[@"ok"] integerValue] == 1)
         {
             NSLog(@"%@",responseObject[@"msg"]);
             // 发送通知
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePersonalDataPage" object:nil];
             [self.navigationController popViewControllerAnimated:YES]; // 修改成功返回上一页面
         }
         else
         {
             NSLog(@"%@",responseObject[@"msg"]);
         }
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
