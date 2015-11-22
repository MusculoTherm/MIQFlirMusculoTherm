//
//  ThermalDataUploader.h
//  MIQFlirMusculoTherm
//
//  Created by XianLi on 21/11/2015.
//  Copyright © 2015 XianLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MuscleGroupPoint.h"
#import "ThermalData.h"


@interface ThermalDataUploader : NSObject

@property (strong, nonatomic) ThermalData *preData;
@property (strong, nonatomic) ThermalData *postData;
@property (nonatomic) NSUInteger timeSpentSeconds;
@property (nonatomic) BOOL demo;

+ (instancetype)sharedInstance;
- (void)postWithSuccess:(void (^)(NSDictionary *resultDict))success failure:(void (^)(NSError *error))fail;

@end
