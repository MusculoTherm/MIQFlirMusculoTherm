//
//  MuscleGroupPoint.h
//  MIQFlirMusculoTherm
//
//  Created by XianLi on 21/11/2015.
//  Copyright © 2015 XianLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MuscleGroupPoint : NSObject

@property (strong, nonatomic) NSString *name;
@property (nonatomic) CGPoint visualLoc;
@property (nonatomic) CGPoint dataLoc;
@property (strong, nonatomic) UIView *view;

+ (NSArray *)createPointArrForWorkOutType:(NSInteger)type visualImgSize:(CGSize)imgSize dataImgSize:(CGSize)dataSize;
+ (NSArray *)createPointArrForTypeLeg;
+ (void)saveLocationForPointArr:(NSArray *)pointArr;
- (NSDictionary *)dictDesc;

@end
