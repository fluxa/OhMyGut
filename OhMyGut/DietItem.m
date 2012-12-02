//
//  DietItem.m
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 12/1/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import "DietItem.h"
#import "Data.h"

@implementation DietItem

@synthesize dietID=_dietID;

- (void) setDietID:(NSString *)dietID {
    _dietID = dietID;
    self.nameLabel.text = dietID;
    BOOL isOn = [[[Data shared].diets objectForKey:_dietID] boolValue] || NO;
    self.switchControl.on = isOn;
}

- (IBAction)onValueChanged:(id)sender {
    BOOL isOn = self.switchControl.on;
    
    [[Data shared].diets setObject:[NSNumber numberWithBool:isOn] forKey:self.dietID];
    [[Data shared] save];
    
    if (isOn) {
        NSArray *allfoods = [[Data shared] getFoods];
        for (Food *food in allfoods) {
            if ([food.state intValue] == FOOD_EATING || [food.state intValue] == FOOD_NOT_EATING) {
                NSNumber *foodState = [NSNumber numberWithInt:FOOD_EATING];
                for (NSString *dietID in DIETS_IDS) {
                    if ([[[Data shared].diets objectForKey:dietID] boolValue]) {
                        if (![[food valueForKey:dietID] boolValue]) {
                            foodState = [NSNumber numberWithInt:FOOD_NOT_EATING];
                        }
                    }
                }
                food.state = foodState;
            }
        }
        NSError *error = nil;
        [[Data shared].managedObjectContext save:&error];
    }

}

@end
