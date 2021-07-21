//
//  GDTIntertitialADViewController.m
//  ComplianceAD
//
//  Created by 唐天成 on 2021/7/21.
//

#import "GDTIntertitialADViewController.h"
#import "NSObject+DDSwizz.h"
#import "GDTUnifiedInterstitialAd.h"
#import "MBProgressHUD.h"
#import "GDTSDKConfig.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface GDTIntertitialADViewController ()<GDTUnifiedInterstitialAdDelegate>

@property (nonatomic, strong) GDTUnifiedInterstitialAd *interstitial;
@property (nonatomic, strong) UITextField *appidTextField;
@property (nonatomic, strong) UITextField *adSoldidTextField;
@property (nonatomic, strong) UIButton *showBtn;

@end

@implementation GDTIntertitialADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"广点通插屏广告";
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
        
        if (self.interstitial) {
            self.interstitial.delegate = nil;
            self.interstitial = nil;
        }
        [GDTSDKConfig registerAppId:self.appidTextField.text];
      
        self.interstitial = [[GDTUnifiedInterstitialAd alloc] initWithPlacementId:self.adSoldidTextField.text];
        self.interstitial.delegate = self;
        self.interstitial.videoMuted = YES;
        self.interstitial.detailPageVideoMuted = YES;
        self.interstitial.videoAutoPlayOnWWAN = YES;

        [self.interstitial loadAd];
    }
}

- (void)showSplash {
    if(!self.appidTextField.text.length || !self.adSoldidTextField.text.length) {
        [self showToast: @"必须输入appid和广告位ID"];
    } else {
        self.showBtn.hidden = YES;
        [self.interstitial presentAdFromRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - GDTUnifiedInterstitialAdDelegate

/**
 *  插屏2.0广告预加载成功回调
 *  当接收服务器返回的广告数据成功后调用该函数
 */
- (void)unifiedInterstitialSuccessToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    if(self.interstitial && self.interstitial == unifiedInterstitial) {
        if(![UIApplication sharedApplication].delegate.window.rootViewController.presentedViewController) {
            if([self.interstitial respondsToSelector:@selector(mediator)]) {
                id media = [self.interstitial performSelector:@selector(mediator)];
                if([media respondsToSelector:@selector(templateView)]) {
                    NSObject *templateView = [media performSelector:@selector(templateView)];
                    if(templateView && [templateView isKindOfClass:NSClassFromString(@"GDTUnifiedTemplateView")]) {
                        templateView.ddisShowToastTip = YES;
                        [GDTIntertitialADViewController DDswizzMethod];
                    }
                }
            }
        }
    }
    self.showBtn.hidden = NO;
    [self showToast: @"成功加载到广告,点击show按钮可展示"];
    NSLog(@"成功加载到广告,点击show按钮可展示");
}


+ (void)DDswizzMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"GDTUnifiedTemplateView");
        IMP imp = imp_implementationWithBlock(^(NSObject * this, id args1){
            if (class_respondsToSelector([this class], @selector(swiz_click:))) {
                if(this.ddisShowToastTip) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
                    // Set the text mode to show only text.
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = @"即将跳转详情页面或第三方应用";
                    // Move to bottm center.
                    hud.offset = CGPointMake(0, ([UIScreen mainScreen].bounds.size.height - 58)/2 - 64);
                    [hud hideAnimated:YES afterDelay:1.3f];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        ((id (*) (id, SEL, id args1)) objc_msgSend)(this, @selector(swiz_click:), args1);

                    });
                } else {
                    ((id (*) (id, SEL, id args1)) objc_msgSend)(this, @selector(swiz_click:), args1);
                }
                
            }
        });
        Method originMethod = class_getInstanceMethod(class, @selector(click:));
        if(!originMethod) {
            return;
        }
        SEL swizzleSel = sel_registerName("swiz_click:");
        BOOL suc = class_addMethod(class, swizzleSel, imp, "v@:@");
        if(!suc) {
            return;
        }
        Method swizzledMethod = class_getInstanceMethod(class, swizzleSel);
        method_exchangeImplementations(originMethod, swizzledMethod);
    });

}



/**
 *  插屏2.0广告预加载失败回调
 *  当接收服务器返回的广告数据失败后调用该函数
 */
- (void)unifiedInterstitialFailToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error
{
    [self showToast: [NSString stringWithFormat:@"%@",error.localizedDescription]];
    NSLog(@"拉取失败:%@",error.localizedDescription);
}

/**
 *  插屏2.0广告将要展示回调
 *  插屏2.0广告即将展示回调该函数
 */
- (void)unifiedInterstitialWillPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
}

- (void)unifiedInterstitialFailToPresent:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error {
}

/**
 *  插屏2.0广告视图展示成功回调
 *  插屏2.0广告展示成功回调该函数
 */
- (void)unifiedInterstitialDidPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
}

/**
 *  插屏2.0广告展示结束回调
 *  插屏2.0广告展示结束回调该函数
 */
- (void)unifiedInterstitialDidDismissScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
}

/**
 *  当点击下载应用时会调用系统程序打开
 */
- (void)unifiedInterstitialWillLeaveApplication:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
}

/**
 *  插屏2.0广告曝光回调
 */
- (void)unifiedInterstitialWillExposure:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
}

/**
 *  插屏2.0广告点击回调
 */
- (void)unifiedInterstitialClicked:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
}
/**
 *  点击插屏2.0广告以后即将弹出全屏广告页
 */
- (void)unifiedInterstitialAdWillPresentFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
}

/**
 *  点击插屏2.0广告以后弹出全屏广告页
 */
- (void)unifiedInterstitialAdDidPresentFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
}

/**
 *  全屏广告页将要关闭
 */
- (void)unifiedInterstitialAdWillDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
}

/**
 *  全屏广告页被关闭
 */
- (void)unifiedInterstitialAdDidDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
}
/**
 * 插屏2.0视频广告 player 播放状态更新回调
 */
- (void)unifiedInterstitialAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial playerStatusChanged:(GDTMediaPlayerStatus)status
{
}
/**
 * 插屏2.0视频广告详情页 WillPresent 回调
 */
- (void)unifiedInterstitialAdViewWillPresentVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
}
/**
 * 插屏2.0视频广告详情页 DidPresent 回调
 */
- (void)unifiedInterstitialAdViewDidPresentVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
}

/**
 * 插屏2.0视频广告详情页 WillDismiss 回调
 */
- (void)unifiedInterstitialAdViewWillDismissVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
}

/**
 * 插屏2.0视频广告详情页 DidDismiss 回调
 */
- (void)unifiedInterstitialAdViewDidDismissVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
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
