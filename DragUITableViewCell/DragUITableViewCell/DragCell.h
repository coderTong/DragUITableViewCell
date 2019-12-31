//
//  DragCell.h
//  DragUITableViewCell
//
//  Created by codew on 12/31/19.
//  Copyright © 2019 itmoy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DragCellDelegate <NSObject>

@optional
/**
 拖拽

 @param tap 拖拽的手势
 */
-(void)dragCellWithTap:(UILongPressGestureRecognizer *)tap;

@end

@interface DragCell : UITableViewCell
@property (weak, nonatomic,readonly) IBOutlet UIView *viewColor;

@property (nonatomic, weak) id <DragCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
