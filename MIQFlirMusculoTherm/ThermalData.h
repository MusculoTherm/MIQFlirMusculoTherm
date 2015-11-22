//
//  ThermalData.h
//  MIQFlirMusculoTherm
//
//  Created by XianLi on 21/11/2015.
//  Copyright © 2015 XianLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ThermalData : NSObject

@property (strong, nonatomic) NSData *data;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (nonatomic) CGSize imgViewSize;
@property (nonatomic) CGSize size;
@property (strong, nonatomic) UIImage *img;
@property (strong, nonatomic) NSArray *musclePoints;
@property (nonatomic) NSInteger workoutType;
@property (strong, nonatomic) NSString *imgURLString;

- (void)prepareForUpload;

@end
