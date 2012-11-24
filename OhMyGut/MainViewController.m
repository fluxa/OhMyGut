//
//  MainViewController.m
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 11/24/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import "MainViewController.h"
#import "Data.h"
#import "SXCell.h"

@interface MainViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *sxsByGroup;

@end

@implementation MainViewController


- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.sxsByGroup = [NSMutableDictionary dictionary];
    for (SXGroup *group in [[Data shared] getGroups]) {
        NSArray *a = [group.sxsbygroup allObjects];
        [self.sxsByGroup setObject:a forKey:group.gid];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[Data shared] getGroups] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SXGroup *group = [[Data shared] groupByID:section];
    return [group.sxsbygroup count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SXGroup *sxgroup = [[Data shared] groupByID:indexPath.section];
    SXs *sx = [[self.sxsByGroup objectForKey:sxgroup.gid] objectAtIndex:indexPath.row];
    
    static NSString *identifier = @"sxcell";
    SXCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    cell.titleLabel.text = sx.text;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    SXGroup *group = [[Data shared] groupByID:section];
    return group.name;
}
@end
