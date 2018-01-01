//
//  UserRecord.m
//  LearningFun
//
//  Created by Charles H. Cheng on 1/4/18.
//  Copyright © 2018 chchench. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserRecord.h"


@implementation UserRecord

NSManagedObjectContext *managedObjectContext;
NSManagedObjectModel *managedObjectModel;
NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (id)init
{
    self.dbRecord = nil;
    self.dbLookupDone = NO;
    
    return self;
}


- (id)init:(NSString *)firstName andLastName:(NSString *)lastName andEmail:(NSString *)emailAddress
{
    self.firstName = firstName;
    self.lastName = lastName;
    self.emailAddress = emailAddress;
    
    self.dbRecord = [self retrieveUserRecord:firstName andLastName:lastName andEmail:emailAddress];
    self.dbLookupDone = YES;
    
    return self;
}


- (NSManagedObject *)retrieveUserRecord:(NSString *)firstName andLastName:(NSString *)lastName andEmail:(NSString *)emailAddress
{
    if (!firstName || !managedObjectContext || !managedObjectModel || !persistentStoreCoordinator) {
        NSLog(@"Incorrect invocation of retrieveUserRecord");
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = nil;
    
    if (lastName && emailAddress)
        predicate = [NSPredicate predicateWithFormat:@"(firstName == %@) AND (lastName == %@) AND (emailAddress == %@)",
                     firstName, lastName, emailAddress];
    else if (lastName)
        predicate = [NSPredicate predicateWithFormat:@"(firstName == %@) AND (lastName == %@)",
                     firstName, lastName];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
        self.dbLookupDone = NO;
    }
    else {
        NSLog(@"%@", result);
    }
    
    if (result == 0 || result.count == 0) {
        self.dbRecord = nil;
        self.dbLookupDone = YES;
        
        return nil;
    }
    
    NSManagedObject *userRec = (NSManagedObject *)[result objectAtIndex:0];
    
    self.firstName = [userRec valueForKey:@"firstName"];
    self.lastName = [userRec valueForKey:@"lastName"];
    self.emailAddress = [userRec valueForKey:@"emailAddress"];
    self.gender = [userRec valueForKey:@"gender"];
    self.birthday = [userRec valueForKey:@"birthday"];
    self.creationTimestamp = [userRec valueForKey:@"creationDate"];
    
    self.dbRecord = userRec;
    self.dbLookupDone = YES;
    
    return userRec;
}


- (BOOL)userExistsInDB:(NSString *)firstName andLastName:(NSString *)lastName andEmail:(NSString *)emailAddress
{
    if (self.dbLookupDone)
        return (self.dbRecord != nil);
    
    return ([self retrieveUserRecord:firstName andLastName:lastName andEmail:emailAddress] != nil);
}


- (BOOL)updatePersistentRecord:(BOOL)createIfNotFound
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"User" inManagedObjectContext:managedObjectContext];

    NSManagedObject *userRec = nil;
    if (self.dbRecord)
        userRec = self.dbRecord;
    else if (createIfNotFound)
        userRec = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:managedObjectContext];
    else
        return NO;
    
    [userRec setValue:self.firstName forKey:@"firstName"];
    
    if (self.lastName) [userRec setValue:self.lastName forKey:@"lastName"];
    
    if (self.emailAddress) [userRec setValue:self.emailAddress forKey:@"emailAddress"];
    
    [userRec setValue:(self.gender ? @YES : @NO) forKey:@"gender"];
    
    if (self.birthday) [userRec setValue:self.birthday forKey:@"birthday"];
    
    if (!self.creationTimestamp) {
        NSDate *currentDateTime = [NSDate date];
        self.creationTimestamp = currentDateTime;
        [userRec setValue:self.creationTimestamp forKey:@"creationDate"];
    }
    
    NSError *error = nil;
    if (![userRec.managedObjectContext save:&error]) {
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@ %@", error, error.localizedDescription);
        
        return NO;
    }

    return YES;
}


- (BOOL)addMathProblemToRecord:(NSString *)problemDescription andCorrectAnswer:(NSString *) correctAnswer
                 andUserAnswer:(NSString *)userAnswer andAnswerCorrect:(BOOL) answerCorrect
                  andTimestamp:(NSDate *) timestamp withDifficultyLevel:(NSInteger)difficultyLevel
                  withSeriesID:(NSString *)seriesID
{
    NSEntityDescription *entityMathProblem = [NSEntityDescription entityForName:@"MathProblem" inManagedObjectContext:managedObjectContext];
    NSManagedObject *newProblem = [[NSManagedObject alloc] initWithEntity:entityMathProblem insertIntoManagedObjectContext:managedObjectContext];

    [newProblem setValue:problemDescription forKey:@"problemDescription"];
    [newProblem setValue:correctAnswer forKey:@"correctAnswer"];
    [newProblem setValue:userAnswer forKey:@"userAnswer"];
    [newProblem setValue:(answerCorrect ? @1 : @0) forKey:@"answerCorrect"];
    [newProblem setValue:timestamp forKey:@"timestamp"];
    NSNumber *level = @(difficultyLevel);
    [newProblem setPrimitiveValue:level forKey:@"difficultyLevel"];
    [newProblem setValue:seriesID forKey:@"seriesID"];
 
    NSMutableSet *problems = [self.dbRecord mutableSetValueForKey:@"mathProblems"];
    if (problems.count > 0)
        [problems addObject:newProblem];
    else
        [self.dbRecord setValue:[NSSet setWithObject:newProblem] forKey:@"mathProblems"];
    
    NSError *error = nil;
    if (![self.dbRecord.managedObjectContext save:&error]) {
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
        return NO;
    }
    
    return YES;
}


- (NSArray *)retrieveAllPastMathProblems
{
    if (!self.dbLookupDone || !self.dbRecord) return nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MathProblem" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];

#if 0
    // TBD
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user == 2"]; //////// TBD ////////
    
    [fetchRequest setPredicate:predicate];
#endif
                              
    NSError *error = nil;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
        self.dbLookupDone = NO;
    }
    else {
        NSLog(@"%@", result);
    }
    
    if (result == 0 || result.count == 0) {
        self.dbRecord = nil;
        self.dbLookupDone = YES;
        
        return nil;
    }
    
    NSLog(@"Number of math problems retrieved from DB = %i", result.count);
    NSManagedObject *problem = (NSManagedObject *)[result objectAtIndex:0];
                              
    return result;
}


+ (void)setPersistentStorageInfo:(NSManagedObjectContext *) objContext
                     andObjModel:(NSManagedObjectModel *) objectModel
                   andStoreCoord:(NSPersistentStoreCoordinator *) storeCoordinator
{
    managedObjectContext = objContext;
    managedObjectModel = objectModel;
    persistentStoreCoordinator = storeCoordinator;
}


@end
