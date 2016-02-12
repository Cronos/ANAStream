//
//  UITableView+ANAExtensions.h
//  ANAStream
//
//  Created by Voropaev Vitali on 12.02.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (ANAExtensions)

- (void)insertCellAtRow:(NSInteger)row section:(NSInteger)section;
- (void)deleteCellAtRow:(NSInteger)row section:(NSInteger)section;

@end
