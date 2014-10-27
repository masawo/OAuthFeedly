//
//  ViewController.h
//  OAuthFeedly
//
//  Created by Masao S on 2014/10/24.
//  Copyright (c) 2014年 masawo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end

