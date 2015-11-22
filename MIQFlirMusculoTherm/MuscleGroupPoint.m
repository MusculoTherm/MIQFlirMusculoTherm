//
//  MuscleGroupPoint.m
//  MIQFlirMusculoTherm
//
//  Created by XianLi on 21/11/2015.
//  Copyright © 2015 XianLi. All rights reserved.
//

#import "MuscleGroupPoint.h"

@implementation MuscleGroupPoint

+ (instancetype)createPointWithName:(NSString*)name visualLoc:(CGPoint)visualLoc
{
    MuscleGroupPoint *p = [[MuscleGroupPoint alloc] init];
    p.name = name;
    p.visualLoc = visualLoc;
    NSNumber *xn = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@", p.name, @"x"]];
    NSNumber *yn = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@", p.name, @"y"]];
    if (xn && yn) {
        p.visualLoc = CGPointMake([xn floatValue], [yn floatValue]);
    }
    UILabel *ln = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    ln.textColor = [UIColor greenColor];
    ln.text = name;
    ln.textAlignment = NSTextAlignmentCenter;
    UILabel *lp = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 20, 20)];
    lp.textColor = [UIColor greenColor];
    lp.text = @"+";
    lp.textAlignment = NSTextAlignmentCenter;
    p.view = [[UIView alloc] initWithFrame:CGRectMake(p.visualLoc.x, p.visualLoc.y, 20, 40)];
    [p.view addSubview:ln];
    [p.view addSubview:lp];
    [ln sizeToFit];
    [lp sizeToFit];
    return p;
}

//+ (NSArray *)pointArrForWorkOutType:(NSInteger)type visualImgSize:(CGSize)imgSize dataImgSize:(CGSize)dataSize
//{
//    
//}

+ (void)saveLocationForPointArr:(NSArray *)pointArr
{
    for (MuscleGroupPoint *p in pointArr) {
        NSLog(@"%@", NSStringFromCGRect(p.view.frame));
        [[NSUserDefaults standardUserDefaults] setObject:@(p.view.frame.origin.x) forKey:[NSString stringWithFormat:@"%@%@", p.name, @"x"]];
        [[NSUserDefaults standardUserDefaults] setObject:@(p.view.frame.origin.y) forKey:[NSString stringWithFormat:@"%@%@", p.name, @"y"]];
    }
}

+ (NSArray *)createPointArrForTypeLeg
{
    return @[
             [MuscleGroupPoint createPointWithName:@"L0" visualLoc:CGPointMake(100, 100)],
             [MuscleGroupPoint createPointWithName:@"L1" visualLoc:CGPointMake(150, 100)],
             [MuscleGroupPoint createPointWithName:@"L2" visualLoc:CGPointMake(100, 150)],
             [MuscleGroupPoint createPointWithName:@"L3" visualLoc:CGPointMake(150, 150)],
             [MuscleGroupPoint createPointWithName:@"L4" visualLoc:CGPointMake(100, 170)],
             [MuscleGroupPoint createPointWithName:@"L5" visualLoc:CGPointMake(100, 190)],
             [MuscleGroupPoint createPointWithName:@"R1" visualLoc:CGPointMake(200, 100)],
             [MuscleGroupPoint createPointWithName:@"R0" visualLoc:CGPointMake(250, 100)],
             [MuscleGroupPoint createPointWithName:@"R3" visualLoc:CGPointMake(200, 150)],
             [MuscleGroupPoint createPointWithName:@"R2" visualLoc:CGPointMake(250, 150)],
             [MuscleGroupPoint createPointWithName:@"R4" visualLoc:CGPointMake(200, 170)],
             [MuscleGroupPoint createPointWithName:@"R5" visualLoc:CGPointMake(200, 190)],
             ];
}

- (NSDictionary *)dictDesc
{
    return @{
             @"name": self.name,
             @"x": @((NSInteger)self.dataLoc.x),
             @"y": @((NSInteger)self.dataLoc.y),
             @"r": @(10)
             };
}

@end