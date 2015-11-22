//
//  ThermalData.m
//  MIQFlirMusculoTherm
//
//  Created by XianLi on 21/11/2015.
//  Copyright © 2015 XianLi. All rights reserved.
//

#import "ThermalData.h"
#import "MuscleGroupPoint.h"

@implementation ThermalData

- (void)prepareForUpload
{
    [self convertRawData];
    [self calMusclePointsLocInDataImg];
}

- (void)convertRawData
{
    uint16_t *tempData = (uint16_t *)[self.data bytes];
    uint16_t temp = tempData[0];
    self.dataArr = [NSMutableArray array];
    for(int i=0;i<self.size.width*self.size.height;i++) {
        temp = tempData[i];
        [self.dataArr addObject:@((NSInteger)(temp/100.0))];
        printf("%ld ", (long)(temp/100.0));
    }
    printf("\n");
}

- (void)calMusclePointsLocInDataImg
{
    for (MuscleGroupPoint *p in self.musclePoints) {
        UIView *pv = p.view.subviews[1];
        UIView *iv = pv.superview.superview;
        CGRect frameInImgView = [pv convertRect:pv.frame toView:iv];
        CGFloat x = CGRectGetMidX(frameInImgView);
        CGFloat y = CGRectGetMidY(frameInImgView);
        CGFloat wIV = self.imgViewSize.width;
        CGFloat hIV = self.imgViewSize.height;
        
        CGFloat xData = (x / wIV) * self.size.width;
        CGFloat yData = (y / hIV) * self.size.height;
        p.dataLoc = CGPointMake(xData, yData);
        NSLog(@"dataLoc = %@", NSStringFromCGPoint(p.dataLoc));
    }
}

@end
