//
//  DemoSelectorViewController.m
//  MIQFlirMusculoTherm
//
//  Created by XianLi on 21/11/2015.
//  Copyright © 2015 XianLi. All rights reserved.
//

#import "DemoSelectorViewController.h"
#import "ThermalCameraViewController.h"
#import "ThermalDataUploader.h"

@interface DemoSelectorViewController ()

@end

@implementation DemoSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_nav"]];
    self.navigationItem.titleView = imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)normalButtonTapped:(id)sender {
    [ThermalDataUploader sharedInstance].demo = NO;
    [self showCameraVC];
}
- (IBAction)demoButtonTapped:(id)sender {
    [ThermalDataUploader sharedInstance].demo = YES;
    [self showCameraVC];
}

- (void)showCameraVC
{
    ThermalCameraViewController *cameraVC = [[ThermalCameraViewController alloc] init];
    cameraVC.workoutType = self.workoutType;
    [self.navigationController pushViewController:cameraVC animated:YES];
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
