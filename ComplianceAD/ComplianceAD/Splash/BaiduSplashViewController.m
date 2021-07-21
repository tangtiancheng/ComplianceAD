//
//  BaiduSplashViewController.m
//  ComplianceAD
//
//  Created by 唐天成 on 2021/7/21.
//

#import "BaiduSplashViewController.h"
#import "Masonry.h"
#import "WPSplashAdCoverView.h"
#import "MBProgressHUD.h"
#import <BaiduMobAdSDK/BaiduMobAdView.h>
#import "BaiduMobAdSdk/BaiduMobAdSplashDelegate.h"
#import "BaiduMobAdSdk/BaiduMobAdSplash.h"

@interface BaiduSplashViewController ()<BaiduMobAdSplashDelegate>

@property (nonatomic, strong) UITextField *appidTextField;
@property (nonatomic, strong) UITextField *adSoldidTextField;
@property (nonatomic, strong) UIButton *showBtn;

@property (nonatomic, strong) BaiduMobAdSplash* baiduSplash;
@property (nonatomic, strong) UIView*     customSplashView;

@end

@implementation BaiduSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"百度开屏广告";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, [UIScreen mainScreen].bounds.size.width, 50)];
    tipLabel.text = @"注意:测试之前要把本demo的bundleID改成你自己的,否则bundleID和广告位不匹配没法测试";
    tipLabel.numberOfLines = 0;
    tipLabel.font = [UIFont systemFontOfSize:15];
    tipLabel.textColor = [UIColor blackColor];
    [self.view addSubview:tipLabel];
    
    UILabel *appidLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 200, 33)];
    appidLabel.text = @"输入你的百度appid:";
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
    adSoldidLabel.text = @"输入你的百度广告位ID:";
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
        
        _baiduSplash = [[BaiduMobAdSplash alloc] init];
        _baiduSplash.delegate = self;
        _baiduSplash.AdUnitTag = self.adSoldidTextField.text;
        _baiduSplash.canSplashClick  = YES;
        CGRect splash_frame;
        _baiduSplash.adSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 2033.0 / 2436.0);
        [_baiduSplash load];
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
        CGRect splash_frame;
        splash_frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 2033.0 / 2436.0);
        
        UIView* _baiduSplashContainer = [[UIView alloc] initWithFrame:splash_frame];
        _baiduSplashContainer.tag = 9999;
        _baiduSplashContainer.backgroundColor = [UIColor whiteColor];
        [_customSplashView addSubview:_baiduSplashContainer];
        [_baiduSplash showInContainerView:_baiduSplashContainer];
        
        
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)removeSplash {
    self.baiduSplash.delegate = nil;
    self.baiduSplash = nil;
    [_customSplashView removeFromSuperview];
    _customSplashView = nil;
}


#pragma mark - BaiduMobAdSplashDelegate百度

/**
 *  启动位置信息
 */
- (BOOL)enableLocation {
    return NO;
}

/**
 *  广告加载完成
 *  adType:广告类型 BaiduMobMaterialType
 *  videoDuration:视频时长，仅广告为视频时出现。非视频类广告默认0。 单位ms
 */
- (void)splashDidReady:(BaiduMobAdSplash *)splash
             AndAdType:(NSString *)adType
         VideoDuration:(NSInteger)videoDuration {

}

/**
 * 开屏广告请求成功
 *
 * @param splash 开屏广告对象
 */
- (void)splashAdLoadSuccess:(BaiduMobAdSplash *)splash {
    self.showBtn.hidden = NO;
    [self showToast: @"成功加载到广告,点击show按钮可展示"];
    NSLog(@"成功加载到广告,点击show按钮可展示");
}

/**
 * 开屏广告请求失败
 *
 * @param splash 开屏广告对象
 */
- (void)splashAdLoadFail:(BaiduMobAdSplash *)splash {
    if(self. baiduSplash) {
        [self removeSplash];
    }
    [self showToast: [NSString stringWithFormat:@"失败"]];
    NSLog(@"拉取失败");
}

/**
 *  百度广告展示成功
 */
- (void)splashSuccessPresentScreen:(BaiduMobAdSplash *)splash{
    UIView *containView = [self.customSplashView viewWithTag:9999];
    if(containView.subviews.count > 0) {
        if(containView.subviews.count == 1) {
            containView = containView.subviews.lastObject;
        }
        if (containView.subviews.count > 0 && [containView.subviews.lastObject isKindOfClass:[UIButton class]]) {
            UIButton *btn = containView.subviews.lastObject;
            WPSplashAdCoverView *coverView = [[WPSplashAdCoverView alloc] initWithFrame:containView.bounds];
            coverView.show_click_tip = SplashBtnClickType;
            [containView insertSubview:coverView belowSubview:btn];
        }
    }
    
}
/**
 *  百度广告展示失败
 */
- (void)splashlFailPresentScreen:(BaiduMobAdSplash *)splash withError:(BaiduMobFailReason)reason{
    if(self. baiduSplash) {
        [self removeSplash];
    }
}

/**
 *  应用的APPID
 */
- (NSString *)publisherId{
    return self.appidTextField.text;
}


//百度广告点击
- (void)splashDidClicked:(BaiduMobAdSplash *)splash{
    if(self. baiduSplash) {
        [self removeSplash];
    }
}
//百度广告展示结束
- (void)splashDidDismissScreen:(BaiduMobAdSplash *)splash{
   
    if(self. baiduSplash) {
        [self removeSplash];
    }
}
/**
 *  广告详情页消失,这个方法就没调用过
 */
- (void)splashDidDismissLp:(BaiduMobAdSplash *)splash {
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
