//
//  LearningHistory.m
//  LearningFun
//
//  Created by Charles H. Cheng on 1/1/18.
//  Copyright © 2018 chchench. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LearningHistory.h"

@implementation LearningHistory


NSManagedObjectContext *managedObjectContext;
NSManagedObjectModel *managedObjectModel;
NSPersistentStoreCoordinator *persistentStoreCoordinator;



- (id)init:(NSString *)firstName
{
    return [self init:firstName andLastName:nil andEmail:nil];
}

- (id)init:(NSString *)firstName andLastName:(NSString *)lastName
{
    return [self init:firstName andLastName:lastName andEmail:nil];
}

- (id)init:(NSString *)firstName andLastName:(NSString *)lastName andEmail:(NSString *)emailAddress
{
    if (!firstName || !managedObjectContext || !managedObjectModel || !persistentStoreCoordinator)
        return nil;
    
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
    }
    else {
        NSLog(@"%@", result);
    }
    
    if (result == 0) return nil;
    
    NSManagedObject *user = (NSManagedObject *)[result objectAtIndex:0];
    NSLog(@"%@ %@", [user valueForKey:@"firstName"], [user valueForKey:@"lastName"]);
    
    self.firstName = firstName;
    self.lastName = lastName;
    self.emailAddress = [user valueForKey:@"emailAddress"];
    self.gender = [user valueForKey:@"gender"];
    self.birthday = [user valueForKey:@"birthday"];
    // TBD
    
    return self;
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



