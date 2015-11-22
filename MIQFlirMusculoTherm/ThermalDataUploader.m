//
//  ThermalDataUploader.m
//  MIQFlirMusculoTherm
//
//  Created by XianLi on 21/11/2015.
//  Copyright © 2015 XianLi. All rights reserved.
//

#import "ThermalDataUploader.h"

@interface ThermalDataUploader()

@end

@implementation ThermalDataUploader

static ThermalDataUploader * uploader;
+ (instancetype)sharedInstance
{
    if (!uploader) {
        uploader = [[ThermalDataUploader alloc] initPrivate];
    }
    return uploader;
}

- (instancetype)initPrivate{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)postWithSuccess:(void (^)(NSDictionary *resultDict))success failure:(void (^)(NSError *error))fail
{
    if (self.demo) {
        [self getDemoDataWithSuccess:success failure:fail];
        return;
    }
    [self uploadImg:self.preData.img success:^(NSString *imgURL) {
        self.preData.imgURLString = imgURL;
        [self uploadImg:self.postData.img success:^(NSString *imgURL) {
            self.postData.imgURLString = imgURL;
            // 1
            NSURL *url = [NSURL URLWithString:@"http://52.23.176.27:8080/v0/workouts"];
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
            
            // 2
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
            request.HTTPMethod = @"POST";
            
            // 3
            NSError *error = nil;
            NSData *data = [NSJSONSerialization dataWithJSONObject:[self parameDict]
                                                           options:kNilOptions error:&error];
            if (!error) {
                // 4
                NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                                           fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                                               if (error) {
                                                                                   NSLog(@"Error while posting = %@", error);
                                                                                   if (fail) {
                                                                                       fail(error);
                                                                                   }
                                                                               }
                                                                               NSLog(@"response = %@", response);
                                                                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                                               NSLog(@"data = %@", dict);
                                                                               success(dict);
                                                                           }];
                
                [uploadTask resume];
            } else {
                NSLog(@"error when serializaing json %@", error);
            }
            
            
        } failure:^(NSError *error) {
            return;
        }];
    } failure:^(NSError *error) {
        return;
    }];
    
}

- (void)getDemoDataWithSuccess:(void (^)(NSDictionary *resultDict))success failure:(void (^)(NSError *error))fail
{
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:@"http://52.23.176.27:8080/v0/workouts/17"]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                if (error) {
                    NSLog(@"Error while posting = %@", error);
                    if (fail) {
                        fail(error);
                    }
                }
                NSLog(@"response = %@", response);
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                NSLog(@"data = %@", dict);
                
                NSDictionary *resultDict = dict[@"data"];
                NSURL *preImageURL = [NSURL URLWithString:resultDict[@"preImageUrl"]];
                NSURL *postImageURL = [NSURL URLWithString:resultDict[@"postImageUrl"]];
                NSLog(@"%@, %@", preImageURL, postImageURL);
                [[[NSURLSession sharedSession]
                  downloadTaskWithURL:preImageURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                      if (error) {
                          NSLog(@"error = %@", error);
                          return;
                      }
                      self.preData.img = [UIImage imageWithData:
                                                  [NSData dataWithContentsOfURL:location]];
                      [[[NSURLSession sharedSession]
                        downloadTaskWithURL:postImageURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                            if (error) {
                                NSLog(@"error = %@", error);
                                return;
                            }
                            self.postData.img = [UIImage imageWithData:
                                                [NSData dataWithContentsOfURL:location]];
                            success(dict);
                        }] resume];
                  }] resume];
            }] resume];
}

- (NSMutableDictionary *)parameDict
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *preDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *postDict = [NSMutableDictionary dictionary];
    NSMutableArray *prePointArr = [NSMutableArray array];
    NSMutableArray *postPointArr = [NSMutableArray array];
    
    paramDict[@"workoutId"] = @(1);
    paramDict[@"pre"] = preDict;
    paramDict[@"post"] = postDict;
    paramDict[@"timeSpentSeconds"] = @(self.timeSpentSeconds);
    
    preDict[@"imageURL"] = self.preData.imgURLString;
    preDict[@"tempsK"] = self.preData.dataArr;
    preDict[@"width"] = @(self.preData.size.width);
    preDict[@"height"] = @(self.postData.size.height);
    preDict[@"points"] = prePointArr;
    
    postDict[@"imageURL"] = self.postData.imgURLString;
    postDict[@"tempsK"] = self.postData.dataArr;
    postDict[@"width"] = @(self.postData.size.width);
    postDict[@"height"] = @(self.postData.size.height);
    postDict[@"points"] = postPointArr;
    
    NSLog(@"img url = %@, %@", self.preData.imgURLString, self.postData.imgURLString);
    
    for (MuscleGroupPoint *p in self.preData.musclePoints) {
        [prePointArr addObject:[p dictDesc]];
    }
    for (MuscleGroupPoint *p in self.postData.musclePoints) {
        [postPointArr addObject:[p dictDesc]];
    }
    
    return paramDict;
}

- (void)uploadImg:(UIImage *)img success:(void (^)(NSString *imgURL))success failure:(void (^)(NSError *error))fail
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://52.23.176.27:8080/v0/uploads"]];
    
    NSData *imageData = UIImageJPEGRepresentation(img, 1.0);
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"unique-consistent-string";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add image data
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=thermalImg.jpg\r\n", @"file"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"error while uploading img = %@", error);
            if (fail) {
                fail(error);
            }
            return;
        }
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSDictionary *dataContentDict = dataDict[@"data"];
        success(dataContentDict[@"url"]);
    }];
}

@end
