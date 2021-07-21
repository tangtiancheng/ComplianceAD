//
//  TTNewIntertitialADViewController.m
//  ComplianceAD
//
//  Created by 唐天成 on 2021/7/21.
//

#import "TTNewIntertitialADViewController.h"
#import <BUAdSDK/BUAdSDK.h>
#import "BUNativeExpressAdView+DDSwizz.h"
#import "NSObject+DDSwizz.h"
#import "MBProgressHUD.h"


@interface TTNewIntertitialADViewController ()<BUNativeExpressFullscreenVideoAdDelegate>

@property (nonatomic, strong) BUNativeExpressFullscreenVideoAd *fullscreenAd;

@property (nonatomic, strong) UITextField *appidTextField;
@property (nonatomic, strong) UITextField *adSoldidTextField;
@property (nonatomic, strong) UIButton *showBtn;

@end

@implementation TTNewIntertitialADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"穿山甲新版插屏广告";
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
    resoultLabel.text = @"请输入Appid和广告位ID用于加载插屏广告";
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
        
        if (self.fullscreenAd) {
            self.fullscreenAd.delegate = nil;
            self.fullscreenAd = nil;
        }
        [BUAdSDKManager setAppID:self.appidTextField.text];
        self.fullscreenAd = [[BUNativeExpressFullscreenVideoAd alloc] initWithSlotID:self.adSoldidTextField.text];
        // 不支持中途更改代理，中途更改代理会导致接收不到广告相关回调，如若存在中途更改代理场景，需自行处理相关逻辑，确保广告相关回调正常执行。
        self.fullscreenAd.delegate = self;
        [self.fullscreenAd loadAdData];
    }
}

- (void)showSplash {
    if(!self.appidTextField.text.length || !self.adSoldidTextField.text.length) {
        [self showToast: @"必须输入appid和广告位ID"];
    } else {
        self.showBtn.hidden = YES;
        [self.fullscreenAd showAdFromRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController];

    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - BUNativeExpressFullscreenVideoAdDelegate

- (void)nativeExpressFullscreenVideoAdDidLoad:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
    
    if (self.fullscreenAd == fullscreenVideoAd) {
        if(![UIApplication sharedApplication].delegate.window.rootViewController.presentedViewController) {
            if(fullscreenVideoAd && [fullscreenVideoAd respondsToSelector:@selector(expressAdView)]) {
                BUNativeExpressAdView *nativeExpressAdView = [fullscreenVideoAd performSelector:@selector(expressAdView)];
                nativeExpressAdView.ddisShowToastTip = YES;
                [BUNativeExpressAdView DDswizzMethod];
            }
        }
    }
    self.showBtn.hidden = NO;
    [self showToast: @"成功加载到广告,点击show按钮可展示"];
    NSLog(@"成功加载到广告,点击show按钮可展示");
}

- (void)nativeExpressFullscreenVideoAd:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
    [self showToast: [NSString stringWithFormat:@"%@",error.localizedDescription]];
    NSLog(@"拉取失败:%@",error.localizedDescription);
}

- (void)nativeExpressFullscreenVideoAdViewRenderSuccess:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd {
    
}

- (void)nativeExpressFullscreenVideoAdViewRenderFail:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error {
}

- (void)nativeExpressFullscreenVideoAdDidDownLoadVideo:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
}

- (void)nativeExpressFullscreenVideoAdWillVisible:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
}

- (void)nativeExpressFullscreenVideoAdDidVisible:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
}

- (void)nativeExpressFullscreenVideoAdDidClick:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {

}

- (void)nativeExpressFullscreenVideoAdDidClickSkip:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
}

- (void)nativeExpressFullscreenVideoAdWillClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {
}

- (void)nativeExpressFullscreenVideoAdDidClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd {

}

- (void)nativeExpressFullscreenVideoAdDidPlayFinish:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error {
}

- (void)nativeExpressFullscreenVideoAdCallback:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd withType:(BUNativeExpressFullScreenAdType) nativeExpressVideoAdType{
}

- (void)nativeExpressFullscreenVideoAdDidCloseOtherController:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd interactionType:(BUInteractionType)interactionType {
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
