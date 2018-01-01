//
//  UserRecord.h
//  LearningFun
//
//  Created by Charles H. Cheng on 1/4/18.
//  Copyright © 2018 chchench. All rights reserved.
//

#ifndef UserRecord_h
#define UserRecord_h

#import <CoreData/CoreData.h>

@interface UserRecord : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *emailAddress;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, strong) NSDate *creationTimestamp;
@property (nonatomic) BOOL gender;

@property (nonatomic) BOOL dbLookupDone;
@property (nonatomic, strong) NSManagedObject *dbRecord;

- (id)init;
- (id)init:(NSString *)firstName andLastName:(NSString *)lastName andEmail:(NSString *)emailAddress;

- (NSManagedObject *)retrieveUserRecord:(NSString *)firstName andLastName:(NSString *)lastName andEmail:(NSString *)emailAddress;
- (BOOL)userExistsInDB:(NSString *)firstName andLastName:(NSString *)lastName andEmail:(NSString *)emailAddress;

- (BOOL)updatePersistentRecord:(BOOL)createIfNotFound;

- (BOOL)addMathProblemToRecord:(NSString *)problemDescription andCorrectAnswer:(NSString *) correctAnswer
                 andUserAnswer:(NSString *)userAnswer andAnswerCorrect:(BOOL) answerCorrect
                  andTimestamp:(NSDate *) timestamp withDifficultyLevel:(NSInteger)difficultyLevel
                  withSeriesID:(NSString *)seriesID;

- (NSArray *)retrieveAllPastMathProblems;

+ (void)setPersistentStorageInfo:(NSManagedObjectContext *) objContext
                     andObjModel:(NSManagedObjectModel *) objectModel
                   andStoreCoord:(NSPersistentStoreCoordinator *) storeCoordinator;

@end

#endif /* UserRecord_h */
