//
//  WorkOutTimerViewController.m
//  MIQFlirMusculoTherm
//
//  Created by XianLi on 21/11/2015.
//  Copyright © 2015 XianLi. All rights reserved.
//

#import "WorkOutTimerViewController.h"
#import "ThermalCameraViewController.h"
#import "ThermalDataUploader.h"

@interface WorkOutTimerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSDate *startDate;

@end

@implementation WorkOutTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_nav"]];
    self.navigationItem.titleView = imageView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ThermalDataUploader sharedInstance].timeSpentSeconds = (NSInteger)[[NSDate date] timeIntervalSinceDate:self.startDate];
    [self endTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonTapped:(id)sender {
    ThermalCameraViewController *cameraVC = [[ThermalCameraViewController alloc] init];
    cameraVC.isPost = YES;
    [self.navigationController pushViewController:cameraVC animated:YES];
}

-(void)startTimer
{
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:YES];
    self.startDate = [NSDate date];
}

- (void)endTimer
{
    [self.timer invalidate];
}

-(void)updateTimeLabel
{
    NSDate *curDate = [NSDate date];
    NSTimeInterval interval = [curDate timeIntervalSinceDate:self.startDate];
    NSInteger s = ((NSInteger)interval) % 60;
    NSInteger m = (((NSInteger)interval) / 60) % 60;
    NSInteger h = ((NSInteger)interval) / 60 / 60;
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)h,(long)m,(long)s];
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
