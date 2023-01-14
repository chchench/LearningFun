//
//  UserRecord.m
//  LearningFun
//
//  Created by Charles H. Cheng on 1/4/18.
//  Copyright © 2018 chchench. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserRecord.h"



@implementation ProblemRecord

@synthesize uniqueId;
@synthesize problemDescription;
@synthesize userAnswer;
@synthesize answeredCorrectly;
@synthesize timestamp;

@end



@implementation UserRecord


- (id)init
{
    _database = nil;
    self.dbLookupDone = FALSE;
    
    [self prepareNOpenDB];
    
    return self;
}


- (BOOL)prepareNOpenDB
{
    // Get the documents directory
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];

    // Build the path to the database file
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"LearningFun.db"]];
    const char *dbpath = [databasePath UTF8String];

    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO) {
        if (sqlite3_open(dbpath, &_database) == SQLITE_OK) {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE problem_records(uniqueID integer primary key autoincrement, problemDescription text, userAnswer text, answeredCorrectly integer, timestamp integer)";
            if (sqlite3_exec(_database, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to create table\"flagged_files\"");
                return FALSE;
            }

            // We're going to just keep the database open
            // sqlite3_close(_database);
        }
        else {
            NSLog(@"Failed to open/create database \"%@\"", databasePath);
                            return FALSE;
        }
    }
    else {
        if (sqlite3_open(dbpath, &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database \"%@\"!", databasePath);
            return FALSE;
        }
    }
    
    return TRUE;
}


- (BOOL)addMathProblemToRecord:(NSString *)problemDescription userAnswer:(NSString *)userAnswer answeredCorrectly:(BOOL)answeredCorrectly
{
    int unixtime = [NSDate date].timeIntervalSince1970;
    
    NSString *query =
    [[NSString alloc] initWithFormat:@"INSERT INTO problem_records (problemDescription, userAnswer, answeredCorrectly, timestamp) VALUES(\'%@\', \'%@\', %lu, %li)", problemDescription, userAnswer, answeredCorrectly, unixtime];
    
    char *errorMsg = NULL;
    if (sqlite3_exec(_database, [query UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        NSLog(@"Error while inserting record with SQL query\"%@\"\n", query);
        return FALSE;
    }
    
    return TRUE;
}


- (void)deleteOutdatedMathProblems:(NSUInteger)numDays2Keep
{
    int unix_time = [NSDate date].timeIntervalSince1970;
    int cutoff_unix_time = unix_time - (numDays2Keep * 24 * 60 * 60);

    NSString *query = [[NSString alloc] initWithFormat:@"DELETE FROM problem_records WHERE timestamp < %i", cutoff_unix_time];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Error while deleting records older than %lu days\n", numDays2Keep);
        }
    }
}


- (NSArray *)retrieveAllPastMathProblems:(NSUInteger)numDaysInPast
{
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    
    int unix_time = [NSDate date].timeIntervalSince1970;
    int cutoff_unix_time = unix_time - (numDaysInPast * 24 * 60 * 60);
    
    NSString *query = [[NSString alloc] initWithFormat:@"SELECT uniqueId, problemDescription, userAnswer, answeredCorrectly, timestamp FROM problem_records WHERE timestamp >= %i ORDER BY uniqueId DESC", cutoff_unix_time];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int uniqueId = sqlite3_column_int(statement, 0);
            
            char *cProblemDescription = (char *) sqlite3_column_text(statement, 1);
            char *cUserAnswer = (char *) sqlite3_column_text(statement, 2);
            int iAnsweredCorrectly = (int) sqlite3_column_int(statement, 3);
            int iTimestamp = (int) sqlite3_column_int(statement, 4);
            
            NSString *problemDescription = [[NSString alloc] initWithUTF8String:cProblemDescription];
            NSString *userAnswer = [[NSString alloc] initWithUTF8String:cUserAnswer];
            
            NSDate *timestamp = [[NSDate alloc] initWithTimeIntervalSince1970:iTimestamp];
            
            ProblemRecord *rec = [[ProblemRecord alloc] init];
            rec.uniqueId = uniqueId;
            rec.problemDescription = problemDescription;
            rec.userAnswer = userAnswer;
            rec.answeredCorrectly = (BOOL)iAnsweredCorrectly;
            rec.timestamp = timestamp;
                                  
            NSLog(@"problemDescription = \"%@\"; userAnswer = \"%@\"; answeredCorrectly = %i, timestamp = \"%@\"", problemDescription, userAnswer, iAnsweredCorrectly, timestamp);
            
            [retval addObject:rec];
        }
        sqlite3_finalize(statement);
    }
        
    return retval;
}


@end
