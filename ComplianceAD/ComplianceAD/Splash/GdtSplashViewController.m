//
//  GDTSplashViewController.m
//  ComplianceAD
//
//  Created by 唐天成 on 2021/7/21.
//

#import "GdtSplashViewController.h"
#import "Masonry.h"
#import "WPSplashAdCoverView.h"
#import "MBProgressHUD.h"
#import "GDTSplashAd.h"
#import "GDTSDKConfig.h"


@interface GdtSplashViewController ()<GDTSplashAdDelegate>

@property (nonatomic, strong) GDTSplashAd* splash;

@property (nonatomic, strong) UITextField *appidTextField;
@property (nonatomic, strong) UITextField *adSoldidTextField;
@property (nonatomic, strong) UIButton *showBtn;


@end

@implementation GdtSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"广点通开屏广告";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, [UIScreen mainScreen].bounds.size.width, 50)];
    tipLabel.text = @"注意:测试之前要把本demo的bundleID改成你自己的,否则bundleID和广告位不匹配没法测试";
    tipLabel.numberOfLines = 0;
    tipLabel.font = [UIFont systemFontOfSize:15];
    tipLabel.textColor = [UIColor blackColor];
    [self.view addSubview:tipLabel];
    
    UILabel *appidLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 200, 33)];
    appidLabel.text = @"输入你的广点通appid:";
    appidLabel.font = [UIFont systemFontOfSize:15];
    appidLabel.textColor = [UIColor blackColor];
    [self.view addSubview:appidLabel];
    
    UITextField *appidTextField = [[UITextField alloc] initWithFrame:CGRectMake(200, 200, 200, 33)];
    self.appidTextField = appidTextField;
    appidTextField.backgroundColor = [UIColor grayColor];
    appidTextField.font = [UIFont systemFontOfSize:15];
    appidTextField.textColor = [UIColor blackColor];
    appidTextField.placeholder = @"appid";
    [self.view addSubview:appidTextField];
    //appidTextField.text = @"这里输入你的appid";

    UILabel *adSoldidLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 260, 200, 33)];
    adSoldidLabel.text = @"输入你的广点通广告位ID:";
    adSoldidLabel.font = [UIFont systemFontOfSize:15];
    adSoldidLabel.textColor = [UIColor blackColor];
    [self.view addSubview:adSoldidLabel];
    
    UITextField *adSoldidTextField = [[UITextField alloc] initWithFrame:CGRectMake(200, 260, 200, 33)];
    self.adSoldidTextField = adSoldidTextField;
    adSoldidTextField.backgroundColor = [UIColor grayColor];
    adSoldidTextField.font = [UIFont systemFontOfSize:15];
    adSoldidTextField.textColor = [UIColor blackColor];
    adSoldidTextField.placeholder = @"广告位ID";
    [self.view addSubview:adSoldidTextField];
    //adSoldidTextField.text = @"这里输入你的广告位ID";
    
    UILabel *resoultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, 600, 33)];
    resoultLabel.text = @"请输入Appid和广告位ID用于加载开屏广告";
    resoultLabel.font = [UIFont systemFontOfSize:15];
    resoultLabel.textColor = [UIColor blackColor];
    [self.view addSubview:resoultLabel];
    
    UIButton *loadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 350, 50, 50)];
    [loadBtn addTarget:self action:@selector(loadSplash) forControlEvents:UIControlEventTouchUpInside];
    [loadBtn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:loadBtn];
    [loadBtn setTitle:@"load" forState:UIControlStateNormal];
    loadBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    
    UIButton *showBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 350, 50, 50)];
    [showBtn addTarget:self action:@selector(showSplash) forControlEvents:UIControlEventTouchUpInside];
    self.showBtn = showBtn;
    showBtn.hidden = YES;
    [showBtn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:showBtn];
    [showBtn setTitle:@"show" forState:UIControlStateNormal];
    showBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    
    
}

- (void)loadSplash {
    self.showBtn.hidden = YES;
    if(!self.appidTextField.text.length || !self.adSoldidTextField.text.length) {
        [self showToast: @"必须输入appid和广告位ID"];
    } else {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.label.text = @"正在拉取广告";
        
        [GDTSDKConfig registerAppId:self.appidTextField.text];
        GDTSplashAd* splash = [[GDTSplashAd alloc] initWithPlacementId:self.adSoldidTextField.text];
        splash.delegate = self;
        splash.backgroundColor = [UIColor whiteColor];
        self.splash = splash;
        [self.splash loadAd];
    }
}

- (void)showSplash {
    if(!self.appidTextField.text.length || !self.adSoldidTextField.text.length) {
        [self showToast: @"必须输入appid和广告位ID"];
    } else {
        
        
        self.showBtn.hidden = YES;
        UIView *backBottmView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height * 2033.0/2436, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 403.0/2436)];
        backBottmView.backgroundColor = [UIColor whiteColor];
        UIImageView *back_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"launchiPhone_Bottom_LOGO"]];
        back_image.contentMode = UIViewContentModeScaleAspectFit;
        [backBottmView addSubview:back_image];
        [back_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(backBottmView);
            make.height.equalTo(backBottmView).multipliedBy(175.0/403);
            make.width.equalTo(back_image.mas_height).multipliedBy(92.0/19);
        }];
        [self.splash showAdInWindow:[UIApplication sharedApplication].delegate.window withBottomView:backBottmView skipView:nil];
        
        

        
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



#pragma mark ----- 广点通开屏广告delegate


/**
 *  开屏广告素材加载成功
 */
- (void)splashAdDidLoad:(GDTSplashAd *)splashAd {
    self.showBtn.hidden = NO;
    [self showToast: @"成功加载到广告,点击show按钮可展示"];
    NSLog(@"成功加载到广告,点击show按钮可展示");
}


/**
 *  开屏广告展示失败
 */
- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error {
    [self showToast: [NSString stringWithFormat:@"%@",error.localizedDescription]];
    NSLog(@"拉取失败:%@",error.localizedDescription);
    
}



//GDT开屏广告成功展示
-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd{
    
    /*
     //这里你自己根据后台配置
     if(type == SplashNoShowBtnType) {
     SplashNoShowBtnType = 0,//不显示按钮
     } else if(type == SplashAllClickType) {
     SplashAllClickType = 1,//显示按钮，全屏可点
     } else if(type == SplashBtnClickType) {
     SplashBtnClickType = 2,//显示按钮，按钮可点
     }
     */
    if([splashAd respondsToSelector:@selector(mediator)]) {
        id _mediator = [splashAd performSelector:@selector(mediator)];
        if([_mediator respondsToSelector:@selector(splashImageVC)]) {
            UIViewController *_splashViewController = [_mediator performSelector:@selector(splashImageVC)];
            if([_splashViewController respondsToSelector:@selector(splashView)]) {
                UIView *_splashView = [_splashViewController performSelector:@selector(splashView)];
                if(_splashView) {
                    WPSplashAdCoverView *coverView = [[WPSplashAdCoverView alloc] initWithFrame:_splashView.bounds];
                    coverView.show_click_tip = SplashBtnClickType;
                    [_splashView addSubview:coverView];
                }
            }
        }
    }
   
    
    
}



//开屏广告点击回调
- (void)splashAdClicked:(GDTSplashAd *)splashAd{
}
/**
 *  开屏广告将要关闭回调
 */
- (void)splashAdWillClosed:(GDTSplashAd *)splashAd{
}
/**
 *  开屏广告关闭回调
 */
- (void)splashAdClosed:(GDTSplashAd *)splashAd {
    self.splash = nil;
}
/**
 *  点击以后全屏广告页将要关闭
 */
- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd {
}

/**
 *  点击以后全屏广告页已经关闭
 */
- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd {
}



- (void)showToast:(NSString *)toast {
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = toast;
    // Move to bottm center.
    [hud hideAnimated:YES afterDelay:1.f];
}





@end
