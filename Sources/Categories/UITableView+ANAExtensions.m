//
//  UITableView+ANAExtensions.m
//  ANAStream
//
//  Created by Voropaev Vitali on 12.02.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import "UITableView+ANAExtensions.h"

@implementation UITableView (ANAExtensions)

- (void)insertCellAtRow:(NSInteger)row section:(NSInteger)section {
    [self updateWithBlock:^{
        [self insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

- (void)deleteCellAtRow:(NSInteger)row section:(NSInteger)section {
    [self updateWithBlock:^{
        [self deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

- (void)updateWithBlock:(void (^)(void))block {
    [self beginUpdates];
    if (block) {
        block();
    }
    
    [self endUpdates];
}

@end
