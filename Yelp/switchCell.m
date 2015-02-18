//
//  switchCell.m
//  Yelp
//
//  Created by Sean Dy on 2/17/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "switchCell.h"

@interface switchCell()

@property (weak, nonatomic) IBOutlet UISwitch *switchToggle;

@end

@implementation switchCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)switchValueChanged:(id)sender {
    NSLog(@"toggle");
    [self.delegate switchCell:self didUpdateValue:self.switchToggle.on];
    
}

- (void)setOn:(BOOL)on {
    NSLog(@"setON");
    [self setOn:on animated:NO];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
    _on = on;
    [self.switchToggle setOn:on animated:animated];
    
}

@end
