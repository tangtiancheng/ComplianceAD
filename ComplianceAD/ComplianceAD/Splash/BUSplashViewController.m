//
//  BUSplashViewController.m
//  ComplianceAD
//
//  Created by 唐天成 on 2021/7/20.
//

#import "BUSplashViewController.h"
#import <BUAdSDK/BUSplashAdView.h>
#import <BUAdSDK/BUNativeExpressSplashView.h>
#import <BUAdSDK/BUAdSDKManager.h>
#import "Masonry.h"
#import "WPSplashAdCoverView.h"
#import "MBProgressHUD.h"

@interface BUSplashViewController ()<BUSplashAdDelegate>

@property (nonatomic, strong) UITextField *appidTextField;
@property (nonatomic, strong) UITextField *adSoldidTextField;
@property (nonatomic, strong) UIButton *showBtn;

@property (nonatomic, strong) BUSplashAdView *splashView;
@property (nonatomic, strong) UIView *customSplashView;


@end

@implementation BUSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"穿山甲开屏广告";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, [UIScreen mainScreen].bounds.size.width, 50)];
    tipLabel.text = @"注意:测试之前要把本demo的bundleID改成你自己的,否则bundleID和广告位不匹配没法测试";
    tipLabel.numberOfLines = 0;
    tipLabel.font = [UIFont systemFontOfSize:15];
    tipLabel.textColor = [UIColor blackColor];
    [self.view addSubview:tipLabel];
    
    UILabel *appidLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 200, 33)];
    appidLabel.text = @"输入你的穿山甲appid:";
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
    adSoldidLabel.text = @"输入你的穿山甲广告位ID:";
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
        
        [BUAdSDKManager setAppID:self.appidTextField.text];
        CGRect splash_frame;
        splash_frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 2033.0 / 2436.0);
        BUSplashAdView *splashView = [[BUSplashAdView alloc] initWithSlotID:self.adSoldidTextField.text frame:splash_frame];
        splashView.delegate = self;
        splashView.rootViewController = self;
        [splashView loadAdData];
        self.splashView = splashView;
    }
}

- (void)showSplash {
    if(!self.appidTextField.text.length || !self.adSoldidTextField.text.length) {
        [self showToast: @"必须输入appid和广告位ID"];
    } else {
        self.showBtn.hidden = YES;
        _customSplashView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _customSplashView.backgroundColor = [UIColor whiteColor];
        [[UIApplication sharedApplication].delegate.window addSubview:_customSplashView];
        
        UIView *backBottmView = [[UIView alloc] init];
        backBottmView.backgroundColor = [UIColor whiteColor];
        [_customSplashView addSubview:backBottmView];
        [backBottmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.with.offset(0);
            make.height.equalTo(_customSplashView).multipliedBy(403.0/2436);
        }];
        UIImageView *back_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"launchiPhone_Bottom_LOGO"]];
        back_image.contentMode = UIViewContentModeScaleAspectFit;
        [backBottmView addSubview:back_image];
        [back_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(backBottmView);
            make.height.equalTo(backBottmView).multipliedBy(175.0/403);
            make.width.equalTo(back_image.mas_height).multipliedBy(92.0/19);
        }];
        [_customSplashView addSubview:self.splashView];
        
        
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
        
        //如果是SplashAllClickType或SplashBtnClickType
        if([self.splashView respondsToSelector:@selector(nativeExpressSplashView)]) {
            BUNativeExpressSplashView *splashView = [self.splashView performSelector:@selector(nativeExpressSplashView)];
            if([splashView respondsToSelector:@selector(skipButton)]) {
                UIButton *skipButton = [splashView performSelector:@selector(skipButton)];
                if(skipButton) {
                    WPSplashAdCoverView *coverView = [[WPSplashAdCoverView alloc] initWithFrame:splashView.bounds];
                    coverView.show_click_tip = SplashBtnClickType;
                    [splashView insertSubview:coverView belowSubview:skipButton];
                }
            }
        }
        
        
    }
      
}
- (void)removeSplashAdView {
    if (self.splashView) {
        [self.splashView removeFromSuperview];
        self.splashView = nil;
    }
    if (self.customSplashView) {
        [self.customSplashView removeFromSuperview];
        self.customSplashView = nil;
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



#pragma mark - BUSplashAdDelegate

//当成功加载时调用此方法。
- (void)splashAdDidLoad:(BUSplashAdView *)splashAd {
    self.showBtn.hidden = NO;
    [self showToast: @"成功加载到广告,点击show按钮可展示"];
    NSLog(@"成功加载到广告,点击show按钮可展示");
    
}
//穿山甲开屏点击
- (void)splashAdDidClick:(BUSplashAdView *)splashAd {
    [self removeSplashAdView];
}

//穿山甲开屏点击跳过按钮
- (void)splashAdDidClickSkip:(BUSplashAdView *)splashAd {
    [self removeSplashAdView];
}

//SDK渲染开屏广告关闭回调，当用户点击广告时会直接触发此回调，建议在此回调方法中直接进行广告对象的移除操作
- (void)splashAdDidClose:(BUSplashAdView *)splashAd {
    [self removeSplashAdView];
}

//开屏广告加载失败
- (void)splashAd:(BUSplashAdView *)splashAd didFailWithError:(NSError *)error {
    [self removeSplashAdView];
    [self showToast: [NSString stringWithFormat:@"%@",error.localizedDescription]];
    NSLog(@"拉取失败:%@",error.localizedDescription);

}

//开屏广告将要成功展示
- (void)splashAdWillVisible:(BUSplashAdView *)splashAd {
}

//开屏广告将要关闭
- (void)splashAdWillClose:(BUSplashAdView *)splashAd {
}

//倒计时为0时会触发此回调，如果客户端使用了此回调方法，建议在此回调方法中进行广告的移除操作
- (void)splashAdCountdownToZero:(BUSplashAdView *)splashAd {
    [self removeSplashAdView];
}
//此回调在广告跳转到其他控制器时，该控制器被关闭时调用。interactionType：此参数可区分是打开的appstore/网页/视频广告详情页面
- (void)splashAdDidCloseOtherController:(BUSplashAdView *)splashAd interactionType:(BUInteractionType)interactionType {
    [self removeSplashAdView];
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
