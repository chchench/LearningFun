//
//  SecondViewController.m
//  LearningFun
//
//  Created by Charles H. Cheng on 12/7/17.
//  Copyright © 2017 chchench. All rights reserved.
//

#import "SecondViewController.h"
#import "AppDelegate.h"
#import "MathProblemGenerator.h"
#import "UserRecord.h"


@interface SecondViewController ()

@property (nonatomic, strong) NSMutableArray *todaysRecs;
@property (nonatomic, strong) NSMutableArray *pastRecs;
@property (nonatomic, strong) UIImage *rightIcon, *wrongIcon;

@end


@implementation SecondViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rightIcon = [UIImage imageNamed:@"Right100x100"];
    self.wrongIcon = [UIImage imageNamed:@"Wrong100x100"];

    [self refreshPastHistory];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"SecondViewController - viewWillAppear");
    [self refreshPastHistory];
    [self.myTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshPastHistory
{
    AppDelegate *app = ((AppDelegate*)[[UIApplication sharedApplication]delegate]);
    NSArray *pastProblems = [app.problemRecords retrieveAllPastMathProblems:28 /* 4 weeks */];
 
    self.todaysRecs = [[NSMutableArray alloc] init];
    self.pastRecs = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < pastProblems.count; i++) {
        ProblemRecord *rec = pastProblems[i];
        if ([[NSCalendar currentCalendar] isDateInToday:rec.timestamp]) {
            [self.todaysRecs addObject:rec];
        }
        else {
            [self.pastRecs addObject:rec];
        }
    }
}


#pragma mark - Table View Data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"INVOKED:  - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section");
    if ((self.todaysRecs.count > 0) && (self.pastRecs.count > 0)) {
        switch (section) {
            case 0:
                return self.todaysRecs.count;
            case 1:
                return self.pastRecs.count;
        }
    }
    else if (self.todaysRecs.count > 0)
        return self.todaysRecs.count;

    return self.pastRecs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"INVOKED:  - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath");
    
    static NSString *cellIdentifier = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    ProblemRecord *rec = nil;
    
    if ((self.todaysRecs.count > 0) && (self.pastRecs.count > 0)) {
        if (indexPath.section == 0) {
            rec = self.todaysRecs[indexPath.row];
        }
        else if (indexPath.section == 1) {
            rec = self.pastRecs[indexPath.row];
        }
    }
    else if (self.todaysRecs.count > 0) {
        rec = self.todaysRecs[indexPath.row];
    }
    else if (self.pastRecs.count > 0) {
        rec = self.pastRecs[indexPath.row];
    }
    
    NSString *stringForCell = nil;
    if (rec.answeredCorrectly)
        stringForCell = rec.problemDescription;
    else
        stringForCell = [NSString stringWithFormat:@"%@; answer given was %@", rec.problemDescription, rec.userAnswer];

    cell.textLabel.font = [UIFont fontWithName: @"Arial" size: 24.0 ];
    [cell.textLabel setText:stringForCell];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy HH:mm"];
    cell.detailTextLabel.text = [formatter stringFromDate:rec.timestamp];
    
    if (rec.answeredCorrectly)
        cell.imageView.image = self.rightIcon;
    else
        cell.imageView.image = self.wrongIcon;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"INVOKED:  - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView");
    // Section #0 for today's practice problems and Section #1 for past practice problems.
    NSInteger totalSections = 0;
    if (self.todaysRecs.count > 0)
        totalSections++;
    if (self.pastRecs.count > 0)
        totalSections++;
    return totalSections;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSLog(@"INVOKED:  - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section");
    NSString *headerTitle;
    if ((self.todaysRecs.count > 0) && (self.pastRecs.count > 0)) {
        switch (section) {
            case 0:
                headerTitle = @"Practice History from Today";
                break;
            case 1:
                headerTitle = @"Practice History in the Past";
                break;
                
        }
    }
    else if (self.todaysRecs.count > 0)
        headerTitle = @"Practice History from Today";
    else
        headerTitle = @"Practice History in the Past";
    return headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSLog(@"INVOKED:  - (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section");
    
    return nil;
}

#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"INVOKED:  -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath");
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Section:%d Row:%d selected and its data is %@",
          indexPath.section,indexPath.row,cell.textLabel.text);
}


@end
