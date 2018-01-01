//
//  LearningHistory.h
//  LearningFun
//
//  Created by Charles H. Cheng on 1/1/18.
//  Copyright © 2018 chchench. All rights reserved.
//

#ifndef LearningHistory_h
#define LearningHistory_h

#import <CoreData/CoreData.h>

@interface LearningHistory : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *emailAddress;
@property (nonatomic) BOOL gender;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, strong) NSDate *creationTimestamp;

- (id)init:(NSString *)firstName;
- (id)init:(NSString *)firstName andLastName:(NSString *)lastName;
- (id)init:(NSString *)firstName andLastName:(NSString *)lastName andEmail:(NSString *)emailAddress;

+ (void)setPersistentStorageInfo:(NSManagedObjectContext *) objContext
                     andObjModel:(NSManagedObjectModel *) objectModel
                   andStoreCoord:(NSPersistentStoreCoordinator *) storeCoordinator;

@end

#endif /* LearningHistory_h */
