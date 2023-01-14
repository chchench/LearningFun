//
//  SecondViewController.h
//  LearningFun
//
//  Created by Charles H. Cheng on 12/7/17.
//  Copyright © 2017 chchench. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *myTableView;

- (void)refreshPastHistory;

@end

