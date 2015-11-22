//
//  WorkOutResultViewController.m
//  MIQFlirMusculoTherm
//
//  Created by XianLi on 21/11/2015.
//  Copyright © 2015 XianLi. All rights reserved.
//

#import "WorkOutResultViewController.h"

@interface WorkOutResultViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *preIV;
@property (weak, nonatomic) IBOutlet UIImageView *postIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textBox;

@end

@implementation WorkOutResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = self.title;
    self.textBox.text = self.body;
    self.preIV.image = self.preImg;
    self.postIV.image = self.postImg;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_nav"]];
    self.navigationItem.titleView = imageView;
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                    target:self
                                    action:@selector(share:)];
    self.navigationItem.rightBarButtonItem = shareButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)share:(id)sender
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    [sharingItems addObject:@"Check out my workout!!"];
    [sharingItems addObject:[UIImage imageNamed:@"logo"]];
    [sharingItems addObject:[NSURL URLWithString:self.shareURL]];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
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
