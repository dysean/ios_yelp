//
//  switchCell.h
//  Yelp
//
//  Created by Sean Dy on 2/17/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class switchCell;

@protocol SwitchCellDelegate <NSObject>

- (void)switchCell:(switchCell *)cell didUpdateValue:(BOOL)value;


@end

@interface switchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *switchLabel;
@property (nonatomic, weak) id<SwitchCellDelegate> delegate;
@property (nonatomic, assign) BOOL on;


- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
