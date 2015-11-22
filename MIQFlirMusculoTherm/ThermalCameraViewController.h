//
//  ThermalCameraViewController.h
//  MIQFlirMusculoTherm
//
//  Created by XianLi on 21/11/2015.
//  Copyright © 2015 XianLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThermalData.h"

@interface ThermalCameraViewController : UIViewController

@property (strong, nonatomic) ThermalData *thermalData;
@property (nonatomic) NSInteger workoutType;

@property (nonatomic) BOOL isPost;

@end
