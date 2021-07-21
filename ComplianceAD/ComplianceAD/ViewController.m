//
//  ViewController.m
//  ComplianceAD
//
//  Created by 唐天成 on 2021/7/20.
//

#import "ViewController.h"
#import "BUSplashViewController.h"
#import "GdtSplashViewController.h"
#import "BaiduSplashViewController.h"
#import "TTOldIntertitialADViewController.h"
#import "TTNewIntertitialADViewController.h"
#import "GDTIntertitialADViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"广告这样改能合规";
    // Do any additional setup after loading the view.
}
- (IBAction)buSplashClick:(id)sender {
    BUSplashViewController *vc = [[BUSplashViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)gdtSplashClick:(id)sender {
    GdtSplashViewController *vc = [[GdtSplashViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)baiduSplashClick:(id)sender {
    BaiduSplashViewController *vc = [[BaiduSplashViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)buOldPluginClick:(id)sender {
    TTOldIntertitialADViewController *vc = [[TTOldIntertitialADViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)buNewPlugin:(id)sender {
    TTNewIntertitialADViewController *vc = [[TTNewIntertitialADViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)gdtPlugin:(id)sender {
    GDTIntertitialADViewController *vc = [[GDTIntertitialADViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}


@end
