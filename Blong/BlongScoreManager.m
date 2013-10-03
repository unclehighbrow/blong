//
//  BlongScoreManager.m
//  Blong
//
//  Created by Will Carlough on 10/3/13.
//  Copyright (c) 2013 Will Carlough. All rights reserved.
//

#import "BlongScoreManager.h"

@implementation BlongScoreManager

-(NSMutableArray *)fetchScores {
    if (_managedObjectContext == nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
    }
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Score" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSError *error;
    NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (!mutableFetchResults) {
        NSLog(@"couldn't get fetch results cause fuck it");
    }
    return mutableFetchResults;
}

-(void)addScore:(int)score forName:(NSString *)name {
    Score *scoreEntity = (Score *)[NSEntityDescription insertNewObjectForEntityForName:@"Score" inManagedObjectContext:_managedObjectContext];
    [scoreEntity setScore:[NSNumber numberWithInt:score]];
    [scoreEntity setName:name];
    NSError *error;
    if(![_managedObjectContext save:&error]){
        NSLog(@"couldn't store score wah");
    }
}
@end
