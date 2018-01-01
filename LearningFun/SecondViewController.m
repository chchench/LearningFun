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


@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *app = ((AppDelegate*)[[UIApplication sharedApplication]delegate]);
                        
    NSDate *today = [NSDate date];
    myData = [[NSMutableArray alloc] init];
                        
    NSArray *problems = [app.defaultUser retrieveAllPastMathProblems];
    for (int i = 0; i < problems.count; i++) {
        NSManagedObject *obj = [problems objectAtIndex:i];
        
        BOOL answerCorrectly = [obj valueForKey:@"answerCorrect"];
        NSString *timestamp = [obj valueForKey:@"timestamp"];
        NSString *prob = [obj valueForKey:@"problemDescription"];
        NSString *correctAnswer = [obj valueForKey:@"correctAnswer"];
//        NSString *userAnswer = [obj valueForKey:@"userAnswer"];
        
#if 0
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss'Z'";
        NSDate *utc = [fmt dateFromString:timestamp];
        fmt.timeZone = [NSTimeZone systemTimeZone];
        timestamp = [fmt stringFromDate:utc];
#endif
        
        NSString *probDescription;
        if (answerCorrectly) {
            probDescription = [NSString stringWithFormat:@"%@      %@ = %@", timestamp, prob, correctAnswer];
        }
        else {
            probDescription = [NSString stringWithFormat:@"%@      %@ = %@ [Incorrect]", timestamp, prob, correctAnswer];
        }
        
        NSLog(probDescription);
        
        [myData insertObject:probDescription atIndex:0];
        
        if (i >= 1000) break; // We only show up to 1000 past math problems
    }
    
#if 1
    // table view data is being set here
    myData = [[NSMutableArray alloc]initWithObjects:
              @"Data 1 in array",@"Data 2 in array",@"Data 3 in array",
              @"Data 4 in array",@"Data 5 in array",@"Data 6 in array",
              @"Data 7 in array",@"Data 8 in array",@"Data 9 in array",
              @"Data 10 in array", @"Data 11 in array", @"Data 12 in array",
              @"Data 13 in array", @"Data 14 in array", @"Data 15 in array",
              @"Data 16 in array", @"Data 17 in array", @"Data 18 in array",
              @"Data 19 in array", @"Data 20 in array", @"Data 21 in array", nil];
#endif
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


///////////////////////////////////////////////////////////////////////////

#pragma mark - Table View Data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return [myData count];
    else
        return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    
    
    
    NSString *stringForCell;
    
#if 1
    if (indexPath.section == 0) {
        stringForCell= [myData objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        stringForCell= [myData objectAtIndex:indexPath.row+ [myData count]/2];
    }
    
#if 0
    [cell.textLabel setText:stringForCell];
#else
    
    
    cell.textLabel.text = stringForCell;
    cell.detailTextLabel.text = @"Hello";
    cell.imageView.image = [UIImage imageNamed:@"creme_brelee.jpg"];
#endif

#endif
    
    return cell;
}




#if 0 // TBD TBD TBD
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *item = (NSDictionary *)[self.content objectAtIndex:indexPath.row];
    cell.textLabel.text = [item objectForKey:@"mainTitleKey"];
    cell.detailTextLabel.text = [item objectForKey:@"secondaryTitleKey"];
    NSString *path = [[NSBundle mainBundle] pathForResource:[item objectForKey:@"imageKey"] ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    cell.imageView.image = theImage;
    return cell;
}
#endif // TBD TBD TBD




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Section 1 for today's practice problems and Section 2 for past practice problems.
    return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *headerTitle;
    
    if (section != 0) {
        headerTitle = @"Practice History from Today";
    }
    else {
        headerTitle = @"Practice History in the Past";
    }
    
    return headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:
(NSInteger)section
{
    return nil;
}


#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Section:%d Row:%d selected and its data is %@",
          indexPath.section,indexPath.row,cell.textLabel.text);
}


@end
