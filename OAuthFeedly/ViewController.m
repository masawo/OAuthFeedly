//
//  ViewController.m
//  OAuthFeedly
//
//  Created by Masao S on 2014/10/24.
//  Copyright (c) 2014年 masawo. All rights reserved.
//

#import "ViewController.h"
#import "NXOAuth2Account.h"
#import "NXOAuth2AccountStore.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (IBAction)editAction:(id)sender {
    if (_tableView.editing) {
        [_tableView setEditing:NO animated:YES];
        _editButton.title = @"Edit";

    } else {
        [_tableView setEditing:YES animated:YES];
        _editButton.title = @"Done";
    }
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"accountViewCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    NXOAuth2Account *account = [[[NXOAuth2AccountStore sharedStore] accounts] objectAtIndex:indexPath.row];
    NSDictionary *userData = (id)account.userData;
    NSString *name = [NSString stringWithFormat:@"%@:%d", [userData objectForKey:@"fullName"], indexPath.row ];
    cell.textLabel.text = name;

    cell.detailTextLabel.text = account.identifier;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //number of account
    return [[[NXOAuth2AccountStore sharedStore] accounts] count];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray *accounts = [[NXOAuth2AccountStore sharedStore] accounts];
    for (NXOAuth2Account *account in accounts) {
        if ([account.identifier isEqualToString:cell.detailTextLabel.text]) {
            //delete account
            [[NXOAuth2AccountStore sharedStore] removeAccount:account];
            break;
        }
    }

    //delete tableview cell
    NSArray *deleteIndexs = [NSArray arrayWithObject:indexPath];
    [tableView deleteRowsAtIndexPaths:deleteIndexs withRowAnimation:UITableViewRowAnimationFade];
}

@end
