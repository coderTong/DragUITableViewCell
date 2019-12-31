//
//  DragCell.m
//  DragUITableViewCell
//
//  Created by codew on 12/31/19.
//  Copyright © 2019 itmoy. All rights reserved.
//

#import "DragCell.h"

@interface DragCell ()

@property (weak, nonatomic) IBOutlet UIView *viewColor;
@property (weak, nonatomic) IBOutlet UIImageView *dragImgView;

@end

@implementation DragCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(dragTapClicked:)];
    [_dragImgView addGestureRecognizer:longPress];
    
    [self addGestureRecognizer:longPress];
}
-(void)dragTapClicked:(UILongPressGestureRecognizer *)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragCellWithTap:)]) {
        [self.delegate dragCellWithTap:tap];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
