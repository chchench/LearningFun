//
//  AppDelegate.h
//  LearningFun
//
//  Created by Charles H. Cheng on 1/1/18.
//  Copyright © 2018 chchench. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "UserRecord.h"


#define DELEGATE ((AppDelegate*)[[UIApplication sharedApplication]delegate])


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (nonatomic, retain) UserRecord *problemRecords;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

