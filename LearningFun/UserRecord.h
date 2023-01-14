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
#import <sqlite3.h>


@interface ProblemRecord : NSObject

@property (nonatomic, assign) int uniqueId;
@property (nonatomic, copy) NSString *problemDescription;
@property (nonatomic, copy) NSString *userAnswer;
@property (nonatomic) BOOL answeredCorrectly;
@property (nonatomic, copy) NSDate *timestamp;

@end



@interface UserRecord : NSObject {
    sqlite3 *_database;
}


@property (nonatomic) BOOL dbLookupDone;


- (id)init;
- (BOOL)prepareNOpenDB;
- (BOOL)addMathProblemToRecord:(NSString *)problemDescription userAnswer:(NSString *)userAnswer answeredCorrectly:(BOOL)answeredCorrectly;
- (void)deleteOutdatedMathProblems:(NSUInteger)numDays2Keep;
- (NSArray*)retrieveAllPastMathProblems:(NSUInteger)numDaysInPast;


@end


#endif /* UserRecord_h */
