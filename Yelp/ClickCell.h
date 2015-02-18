//
//  ClickCell.h
//  Yelp
//
//  Created by Sean Dy on 2/17/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClickCell;

@protocol ClickCellDelegate <NSObject>

- (void)ClickCell:(ClickCell *)cell didUpdateValues:(BOOL)value;

@end

@interface ClickCell : UITableViewCell

@property (nonatomic, weak) id<ClickCellDelegate> delegate;
@property (nonatomic, assign) NSInteger option;
@property (weak, nonatomic) IBOutlet UILabel *settingsLabel;
@property (weak, nonatomic) IBOutlet UIButton *clickButton;

@end
