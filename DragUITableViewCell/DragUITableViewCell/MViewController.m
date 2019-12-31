//
//  MViewController.m
//  DragUITableViewCell
//
//  Created by codew on 12/31/19.
//  Copyright © 2019 itmoy. All rights reserved.
//

#import "MViewController.h"
#import "DragCell.h"

#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define WTARTRandomColor RGBA(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255),1)


@interface MViewController ()<UITableViewDelegate, UITableViewDataSource,DragCellDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, assign) NSInteger page;

//正在拖拽的indexpath
@property (nonatomic,strong) NSIndexPath *dragingIndexPath;
//目标位置
@property (nonatomic,strong) NSIndexPath *targetIndexPath;

@end

static NSString * DragCellIdentifier = @"DragCell";

@implementation MViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpMainUI];
}
- (IBAction)btnRefreshClick:(id)sender {
    
    NSLog(@"%s %@", __func__, self.dataArray);
    [self.tableView reloadData];
    
    
}

- (void)setUpMainUI
{
    self.dataArray = [NSMutableArray array];

    for (int i = 0; i<6; i++) {
        
        NSString * title = [NSString stringWithFormat:@"cell-%d", i];
        [self.dataArray addObject:title];
    }
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView reloadData];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DragCell  * cell = [tableView dequeueReusableCellWithIdentifier:DragCellIdentifier];
    
    if (!cell) {
        
        [tableView registerNib:[UINib nibWithNibName:DragCellIdentifier bundle:nil] forCellReuseIdentifier:DragCellIdentifier];
        
        cell = [tableView dequeueReusableCellWithIdentifier:DragCellIdentifier];
    }
    
    
//    cell.viewColor.backgroundColor = WTARTRandomColor;
    NSString * title = self.dataArray[indexPath.row];
    cell.textLabel.text =  title;
    cell.delegate = self;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - DragCellDelegate
-(void)dragCellWithTap:(UILongPressGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self.tableView];
    switch (tap.state) {
        case UIGestureRecognizerStateBegan:
            [self dragBegin:point];
            break;
        case UIGestureRecognizerStateChanged:
            [self dragChanged:point];
            break;
        case UIGestureRecognizerStateEnded:
            [self dragEnd];
            break;
        default:
            break;
    }
}

//拖拽开始 找到被拖拽的item
-(void)dragBegin:(CGPoint)point
{
    //通过点击的点来获得indexpath
    self.dragingIndexPath = [self.tableView indexPathForRowAtPoint:point];
    if (!_dragingIndexPath)
    {
        return;
    }
    //触发长按手势的cell
    DragCell * cell = (DragCell*)[self.tableView cellForRowAtIndexPath:self.dragingIndexPath];
    cell.backgroundColor = [UIColor colorWithRed:53/255.f green:115/255.f blue:250/255.f alpha:0.3];
//    cell.isMoving = YES;
    
}

//正在被拖拽ing
-(void)dragChanged:(CGPoint)startPoint
{
    if (!_dragingIndexPath )
    {
        return;
    }
    _targetIndexPath = [self.tableView indexPathForRowAtPoint:startPoint];
    //交换位置 如果没有找到_targetIndexPath则不交换位置
    if (_dragingIndexPath && _targetIndexPath &&(_dragingIndexPath.row != _targetIndexPath.row)) {
        //更新数据源
        [self updateSortDatas];
        //更新item位置
        [self.tableView moveRowAtIndexPath:_dragingIndexPath toIndexPath:_targetIndexPath];
        _dragingIndexPath = _targetIndexPath;
    }
}

//拖拽结束
-(void)dragEnd{
    if (!_dragingIndexPath)
    {
        return;
    }
    DragCell *cell = (DragCell*)[self.tableView cellForRowAtIndexPath:self.dragingIndexPath];
    cell.backgroundColor = [UIColor clearColor];
//    cell.isMoving = NO;
    [self.tableView reloadData];
    
}



#pragma mark 刷新方法
//拖拽排序后需要重新排序数据源
-(void)updateSortDatas
{
    NSString *text = self.dataArray[_dragingIndexPath.row];
    [self.dataArray removeObjectAtIndex:_dragingIndexPath.row];
    [self.dataArray insertObject:text atIndex:_targetIndexPath.row];
    
}
@end
