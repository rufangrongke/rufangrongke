//
//  WXZPersonalPhoneVC.m
//  rufangrongke
//
//  Created by 儒房融科 on 15/10/26.
//  Copyright (c) 2015年 王晓植. All rights reserved.
//

#import "WXZPersonalPhoneVC.h"
#import "WXZPersonalPhoneCell.h"
#import "AFNetworking.h"
#import "WXZDetermineString.h"

@interface WXZPersonalPhoneVC () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) IBOutlet UIView *tipsHeaderView;
@property (strong, nonatomic) IBOutlet UIView *warningHeaderView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UILabel *currentPhoneNumLabel;

@property (nonatomic,strong) UITextField *PhoneTextField;
@property (nonatomic,strong) UITextField *renewPhoneTextField;

@end

@implementation WXZPersonalPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 视图整体背景色
    self.view.backgroundColor = WXZRGBColor(246, 246, 246);
    // 添加标题，设置标题的颜色和字号
    self.navigationItem.title = @"修改绑定手机";
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
    self.PhoneTextField.delegate = self;
    self.renewPhoneTextField.delegate = self;
}

// 修改手机号请求
- (void)modifyRequestWithParameter1:(NSString *)parm1 parameter:(NSString *)parm2 isCode:(BOOL)iscode;
{
    NSString *url;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (iscode)
    {
        url = [OutNetBaseURL stringByAppendingString:yanzhengma];
        [param setObject:parm1 forKey:@"Act"]; // 验证码类型
        [param setObject:parm2 forKey:@"Mobile"]; // 手机号
    }
    else
    {
        url = [OutNetBaseURL stringByAppendingString:jinjirenxiugaishoujihao];
        [param setObject:parm1 forKey:@"yzm"]; // 旧手机号发送的验证码
        [param setObject:parm2 forKey:@"mob"]; // 新手机号
    }
    
    [[AFHTTPSessionManager manager] POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject)
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

#pragma mark - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXZPersonalPhoneCell *phoneCell = [tableView dequeueReusableCellWithIdentifier:@"ModifyPhoneCell"];
    if (!phoneCell)
    {
        phoneCell = [WXZPersonalPhoneCell initPersonalPhoneCell];
    }
    
    self.PhoneTextField = phoneCell.phoneTextField;
    [phoneCell phoneInfo:indexPath];
    [phoneCell.codeBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return phoneCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 62;
    }
    else
    {
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 64;
    }
    else
    {
        return 0.1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        self.currentPhoneNumLabel.text = self.phone;
        return self.tipsHeaderView;
    }
    else
    {
        return self.warningHeaderView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        return self.footerView;
    }
    return nil;
}

// 确定按钮事件
- (IBAction)confirmBtnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 100009)
    {
        NSLog(@"验证码");
        [self modifyRequestWithParameter1:@"ChageMobile" parameter:self.currentPhoneNumLabel.text isCode:YES];
    }
    else
    {
        NSLog(@"确定");
        [self modifyRequestWithParameter1:self.currentPhoneNumLabel.text parameter:self.currentPhoneNumLabel.text isCode:YES];
    }
    
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
