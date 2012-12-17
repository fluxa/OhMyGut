//
//  SXsViewController.m
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 11/24/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import "SXsViewController.h"
#import "Data.h"
#import "SXCell.h"
#import "AppDelegate.h"

@interface SXsViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *sxsByGroup;

@end

@implementation SXsViewController


- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.sxsByGroup = [NSMutableDictionary dictionary];
    for (SXGroup *group in [[Data shared] getGroups]) {
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"text" ascending:YES];
        NSArray *a = [[group.sxsbygroup allObjects] sortedArrayUsingDescriptors:@[sort]];
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

- (IBAction)onLeftButton:(id)sender {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app toggleLeftPanel];
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

    [cell setSx:sx];
    
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
