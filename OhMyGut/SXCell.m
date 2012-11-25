//
//  SXCell.m
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 11/24/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import "SXCell.h"
#import "Data.h"
#import "DaySX.h"

@implementation SXCell

@synthesize sx=_sx;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setSx:(SXs *)sx {
    _sx = sx;
    self.titleLabel.text = sx.text;
    DaySX *daysx = [[Data shared] getLatestDaySX:sx];
    if (daysx) {
        self.buttons.selectedSegmentIndex = [daysx.value intValue];
    } else {
        self.buttons.selected = NO;
    }
}

- (void) prepareForReuse {
    [super prepareForReuse];
    self.sx = nil;
    self.titleLabel.text = @"";
    self.buttons.selectedSegmentIndex = 0;
}

- (IBAction)onValueChanged:(id)sender {
    
    NSDate *date = [Data TodayMidnight];
    UISegmentedControl *control = (UISegmentedControl*)sender;
    DaySX *daysx = [[Data shared] getDaySX:self.sx date:date];
    if (daysx == nil) {
        daysx = [NSEntityDescription insertNewObjectForEntityForName:@"DaySX"
                                              inManagedObjectContext:[Data shared].managedObjectContext];
        daysx.date = date;
    }
    daysx.sx = self.sx;
    daysx.value = [NSNumber numberWithInt:control.selectedSegmentIndex];
    NSError *error = nil;
    [[Data shared].managedObjectContext save:&error];
    if (error) {
        Alert(@"Data", [error description]);
    }
}

@end
