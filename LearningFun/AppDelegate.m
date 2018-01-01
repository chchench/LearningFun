//
//  AppDelegate.m
//  LearningFun
//
//  Created by Charles H. Cheng on 1/1/18.
//  Copyright © 2018 chchench. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


@synthesize defaultUser;


#pragma mark - Xcode generated default methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"Standard User Defaults pointer = [%@]", standardUserDefaults);
    
    /* TBD
     BOOL incAddition =       [standardUserDefaults boolForKey:@"include_addition"];
     BOOL incSubtraction =    [standardUserDefaults boolForKey:@"include_subtraction"];
     BOOL incMultiplication = [standardUserDefaults boolForKey:@"include_multiplication"];
     BOOL incDivision =       [standardUserDefaults boolForKey:@"include_division"];
     */
    
    NSInteger numProblems = (int) [standardUserDefaults integerForKey:@"num_problems"];
    if (!numProblems) {
        [self registerDefaultsFromSettingsBundle];
    }
    
    
#if 0 // TBD
    NSString *temp;
    temp = [standardUserDefaults stringForKey:@"num_problems"];
    NSLog(@"B ======> %@", temp);
    
    NSInteger tempInt = [standardUserDefaults integerForKey:@"num_problems"];
    NSLog(@"C ======> %u", tempInt);
#endif
    
    
    [UserRecord setPersistentStorageInfo:self.managedObjectContext
                                  andObjModel:self.managedObjectModel
                                andStoreCoord:self.persistentStoreCoordinator];
    
    self.defaultUser = [[UserRecord alloc] init];
    
    BOOL userFound = [self.defaultUser userExistsInDB:@"Audrey" andLastName:@"Cheng" andEmail:nil];
    if (userFound) {
        NSLog(@"Firstname = [%@]", self.defaultUser.firstName);
        NSLog(@"Lastname = [%@]", self.defaultUser.lastName);
        NSLog(@"Email = [%@]", self.defaultUser.emailAddress);
        NSLog(@"Birthday = [%@]", self.defaultUser.birthday);
        NSLog(@"Creation Date = [%@]", self.defaultUser.creationTimestamp);
    }
    else {
        self.defaultUser.firstName = @"Audrey";
        self.defaultUser.lastName = @"Cheng";
        self.defaultUser.gender = NO;
        self.defaultUser.emailAddress = @"audreyhcheng@gmail.com";
        [self.defaultUser updatePersistentRecord:YES];
    }
    
#if 0 // TBD
    if (userFound) {
        NSLog(@"Firstname = [%@]", user.firstName);
        NSLog(@"Lastname = [%@]", user.lastName);
        NSLog(@"Email = [%@]", user.emailAddress);
        NSLog(@"Birthday = [%@]", user.birthday);
        NSLog(@"Creation Date = [%@]", user.creationTimestamp);
    
        NSDate *current = [NSDate date];
        
        [user addMathProblemToRecord:@"1 + 2 =" andCorrectAnswer:@"5" andUserAnswer:@"4" andAnswerCorrect:NO andTimestamp:current withDifficultyLevel:1 withSeriesID:@"1/100"];
        [user addMathProblemToRecord:@"5 + 7 =" andCorrectAnswer:@"7" andUserAnswer:@"7" andAnswerCorrect:YES andTimestamp:current withDifficultyLevel:1 withSeriesID:@"2/100"];
        
        NSArray *problems = [user retrieveAllPastMathProblems];
        for (int i = 0; i < problems.count; i++) {
            NSManagedObject *obj = [problems objectAtIndex:i];
            NSLog(@"Math Problem #%i %@ %@", i,
                  [obj valueForKey:@"problemDescription"],
                  [obj valueForKey:@"correctAnswer"]);
            
        }
    }
    
    for (int i = 0; i < 10; i++) {
        SInt16 op1, op2, answer;
        UInt8 operator;
        MathProblemGenerator *generator = [[MathProblemGenerator alloc] init:YES andIncSubtraction:YES andIncMultiplication:YES andIncDivision:YES andMaxNumValue:100];
        [generator generateNewProblem:&op1 andOperand2:&op2 andOperator:&operator andAnswer:&answer];
    
        NSLog(@"%i %i %i = %i", op1, operator, op2, answer);
    }
#endif
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Preference settings

- (void)registerDefaultsFromSettingsBundle {
    // this function writes default settings as settings
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    for(NSDictionary *prefSpecification in preferences) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key) {
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
            NSLog(@"writing as default %@ to the key %@",[prefSpecification objectForKey:@"DefaultValue"],key);
        }
    }
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.chchench.LearningFun" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LearningFun" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LearningFun.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
