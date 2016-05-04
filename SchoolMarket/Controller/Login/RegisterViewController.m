/*
 注册
 */

#import "RegisterViewController.h"

#import "LoginHeader.h"
#import "AFRequest.h"

@interface RegisterViewController () <LRFootViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UITableView *registerTableview;
@property (nonatomic,strong) UIAlertController *alertController;

@property (nonatomic,assign) int isAgree;  //同意条款状态 1为同意 0为不同意

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"用户注册";
    
    //tableview
    UITableView *temptableview = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    self.registerTableview = temptableview;
    self.registerTableview.delegate = self;
    self.registerTableview.dataSource = self;
    [self.registerTableview setSeparatorInset:UIEdgeInsetsMake(0, 30, 0, 30)];
    [self.view addSubview:self.registerTableview];
    
    //获取验证码按钮   添加到手机号cell里面
    UIButton *tempcode = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    self.btnGetCode = tempcode;
    [self.btnGetCode setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [self.btnGetCode addTarget:self action:@selector(getIdentifyingCode) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark tableview代理方法
/** 头视图高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}
/** 脚视图*/
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    LRFootView *lrfootView = [[LRFootView alloc ]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) andSuperVc:self];
    lrfootView.delegate = self;
    [lrfootView.btnLoginOrReg setTitle:@"注册" forState:(UIControlStateNormal)];
    self.isAgree = 1;
    return lrfootView;
}
/** 脚视图高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 300;
}

/** 单元格个数*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
/** 获取单元格*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LRTableviewCell *cell = [[LRTableviewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //cell选择样式
    if (indexPath.row == 0) {
        cell.tfContent.placeholder = @"输入您的手机号码";  //设置提示文本
        self.btnGetCode.frame = CGRectMake(self.view.frame.size.width / 4 * 3, 8, self.view.frame.size.width / 5, 30);
        self.btnGetCode.titleLabel.adjustsFontSizeToFitWidth = true;
        [cell addSubview:self.btnGetCode];
    } else if (indexPath.row == 1) {
        cell.tfContent.placeholder = @"输入您的密码";  //设置提示文本
        cell.tfContent.secureTextEntry = true; //密码输入
    } else if (indexPath.row == 2) {
        cell.tfContent.placeholder = @"请输入短信验证码";  //设置提示文本
    }
    
    return cell;
}

#pragma mark 自定义方法
/**
 *  登录或注册
 */
- (void)LoginOrRegClick {
    NSLog(@"注册");
    
    //判断输入格式是否正确 (主要是字数)
    //获取两个cell的文本
    
    //获取手机号码
    NSIndexPath *phoneIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    NSString *phone = [NSString stringWithString:((LRTableviewCell*)[self.registerTableview cellForRowAtIndexPath:phoneIndex]).tfContent.text];
    //获取密码
    NSIndexPath *passwordIndex = [NSIndexPath indexPathForItem:1 inSection:0];
    NSString *password = [NSString stringWithString:((LRTableviewCell*)[self.registerTableview cellForRowAtIndexPath:passwordIndex]).tfContent.text];
    //获取验证码
    NSIndexPath *codeIndex = [NSIndexPath indexPathForItem:2 inSection:0];
    NSString *code = [NSString stringWithString:((LRTableviewCell*)[self.registerTableview cellForRowAtIndexPath:codeIndex]).tfContent.text];
    
    NSLog(@"%@,%@,%@",phone,password,code);
    //检验输入是否符合要求
    NSString *flag = [self textIsRequirements:phone andPassword:password andCode:code];
    //根据返回的flag 推出alert
    if (![flag  isEqual: @"success"]) {
        //推出alertview
        self.alertController.message = flag;
        [self presentViewController:self.alertController animated:true completion:nil];
    }else { //检验成功 发送数据
        NSLog(@"%@",flag);
        [self doRegister:phone andPassword:password andCode:code];
    }
}
/**
 *  阅读并同意
 */
- (void)ReadAndAgreeClick:(UIButton*)sender {
    NSLog(@"点击同意");
    LRFootView *footview = (LRFootView*)[sender superview];
    //切换状态
    if (self.isAgree == 1) {
        self.isAgree = 0;
        [footview setAgreeImg:[UIImage imageNamed:@"checked_grey"]];
    } else {
        self.isAgree = 1;
        [footview setAgreeImg:[UIImage imageNamed:@"checked_green"]];
    }
}
/**
 *  打开用户服务协议
 */
- (void)UrSerAgreeClick {
    NSLog(@"用户服务协议");
    
}
/**
 *  获取验证码
 */
- (void)getIdentifyingCode {
    NSLog(@"获取验证码");
}
/**
 *  注册并验证
 *
 *  @param userphone 用户手机
 *  @param password  密码
 *  @param code      验证码
 */
- (void)doRegister:(NSString*)userphone andPassword:(NSString*)password andCode:(NSString*)code {
    //url
    NSString *url = @"";
    //参数
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:userphone forKey:@"username"];
    [param setObject:password forKey:@"password"];
    [param setObject:code forKey:@"code"];
    //请求
    [AFRequest postLogin:url andParameter:param andResponse:^(NSString * _Nonnull flag, NSDictionary * _Nullable dic) {
        NSString *messgae = [flag valueForKey:@"message"];
        if ([messgae isEqualToString:@"success"]) {
            //注册成功 修改userdefalut
            NSUserDefaults *userdef = [[NSUserDefaults alloc] init];
            [userdef setObject:@"true" forKey:@"logined"];//登录状态
            [userdef setObject:userphone forKey:@"userphone"];  //登录用户手机
            //获取用户数据
            
            //注册 成功 返回根视图
            [self.navigationController popToRootViewControllerAnimated:true];
        } else {
            //注册 失败 提示失败信息
            self.alertController.message = messgae;
            [self presentViewController:self.alertController animated:true completion:nil];
        }
    }];
}
/**
 *  检测输入的内容有没符合要求
 *
 *  @param phone    手机
 *  @param password 密码
 *  @param code     验证码
 *
 *  @return 返回信息
 */
- (nonnull NSString*)textIsRequirements:(nonnull NSString*)phone andPassword:(nonnull NSString*)password andCode:(nullable NSString*)code {
    if (phone.length != 11) {
        return @"手机号码长度为11位!";
    }
    if (password.length < 6 || password.length > 16) {
        return @"密码长度为6到16位!";
    }
    if (code.length == 0 && code != nil) {
        return @"请输入验证码!";
    }
    if (self.isAgree == 0) {
        return @"请阅读并同意《用户服务协议》";
    }
    return @"success";
}

/**
 *  懒加载 alertController
 */
- (UIAlertController *)alertController {
    if (! _alertController) {
        _alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        //取消按钮
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
        [_alertController addAction:cancel];
    }
    
    return _alertController;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
