//
//  PERViewController.h
//  Performance
//
//  Created by xianwen-zhu on 03/25/2022.
//  Copyright (c) 2022 xianwen-zhu. All rights reserved.
//
#import "XWPerformanceDetailView.h"

static CGFloat horPadding = 10;
static CGFloat gapPadding = 10;
static CGFloat cellHeight = 18;
static CGFloat textFont = 14;

@interface XWPerformanceDetailView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSLayoutConstraint *tableViewHeight;

@end

@implementation XWPerformanceDetailView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialUI];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)initialUI {
    self.FpsLbl = [self createLbl];
    self.CpuLbl = [self createLbl];
    self.MemoryLbl = [self createLbl];
    self.StartTimeLbl = [self createLbl];
    self.BatteryLbl = [self createLbl];
    self.pageInitialLbl = [self createLbl];
    
    [self addSubview:self.FpsLbl];
    [self addSubview:self.CpuLbl];
    [self addSubview:self.MemoryLbl];
    [self addSubview:self.StartTimeLbl];
    [self addSubview:self.BatteryLbl];
    [self addSubview:self.pageInitialLbl];
    [self addSubview:self.tableView];
    self.FpsLbl.translatesAutoresizingMaskIntoConstraints = NO;
    self.CpuLbl.translatesAutoresizingMaskIntoConstraints = NO;
    self.MemoryLbl.translatesAutoresizingMaskIntoConstraints = NO;
    self.StartTimeLbl.translatesAutoresizingMaskIntoConstraints = NO;
    self.BatteryLbl.translatesAutoresizingMaskIntoConstraints = NO;
    self.pageInitialLbl.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.FpsLbl.topAnchor constraintEqualToAnchor:self.topAnchor constant:108].active = YES;
    [self.FpsLbl.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:horPadding].active = YES;
    [self.FpsLbl.heightAnchor constraintGreaterThanOrEqualToConstant:cellHeight].active = YES;
    [self.CpuLbl.topAnchor constraintEqualToAnchor:self.FpsLbl.bottomAnchor constant:gapPadding].active = YES;
    [self.CpuLbl.leftAnchor constraintEqualToAnchor:self.FpsLbl.leftAnchor constant:0].active = YES;
    [self.CpuLbl.heightAnchor constraintEqualToAnchor:self.FpsLbl.heightAnchor].active = YES;
    [self.MemoryLbl.topAnchor constraintEqualToAnchor:self.CpuLbl.bottomAnchor constant:gapPadding].active = YES;
    [self.MemoryLbl.leftAnchor constraintEqualToAnchor:self.FpsLbl.leftAnchor constant:0].active = YES;
    [self.MemoryLbl.heightAnchor constraintEqualToAnchor:self.FpsLbl.heightAnchor].active = YES;
    [self.pageInitialLbl.topAnchor constraintEqualToAnchor:self.FpsLbl.topAnchor constant:0].active = YES;
    [self.pageInitialLbl.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-horPadding].active = YES;
    [self.pageInitialLbl.heightAnchor constraintEqualToAnchor:self.FpsLbl.heightAnchor].active = YES;
    [self.BatteryLbl.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-83].active = YES;
    [self.BatteryLbl.rightAnchor constraintEqualToAnchor:self.pageInitialLbl.rightAnchor constant:0].active = YES;
    [self.BatteryLbl.heightAnchor constraintEqualToAnchor:self.FpsLbl.heightAnchor].active = YES;
    [self.StartTimeLbl.bottomAnchor constraintEqualToAnchor:self.BatteryLbl.topAnchor constant:-gapPadding].active = YES;
    [self.StartTimeLbl.rightAnchor constraintEqualToAnchor:self.BatteryLbl.rightAnchor constant:0].active = YES;
    [self.StartTimeLbl.heightAnchor constraintEqualToAnchor:self.FpsLbl.heightAnchor].active = YES;
    [self.tableView.leftAnchor constraintEqualToAnchor:self.FpsLbl.leftAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.BatteryLbl.bottomAnchor].active = YES;
    [self.tableView.rightAnchor constraintEqualToAnchor:self.StartTimeLbl.leftAnchor constant:-5].active = YES;
    self.tableViewHeight = [self.tableView.heightAnchor constraintEqualToConstant:0];
    self.tableViewHeight.active = YES;
}

#pragma mark - UITableViewDelegate&&UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.anrList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = self.anrList[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.font = [UIFont systemFontOfSize:textFont];
    cell.textLabel.textColor = [UIColor colorWithRed:227/255.0 green:23/255.0 blue:13/255.0 alpha:1];
    return cell;
}

#pragma mark - 设置不响应点击事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitTestView = [super hitTest:point withEvent:event];
    if (hitTestView == self || hitTestView == self.tableView) {
        hitTestView = nil;
    }
    return hitTestView;
}

#pragma mark - 创建label
- (UILabel *)createLbl {
    UILabel *lbl = [[UILabel alloc] init];
    lbl.textColor = [UIColor blackColor];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont systemFontOfSize:textFont];
    lbl.textColor = [UIColor colorWithRed:0/255.0 green:199/255.0 blue:140/255.0 alpha:1];
    return lbl;
}

#pragma mark - setter&&getter
- (void)setAnrList:(NSArray *)anrList {
    self.tableViewHeight.constant = anrList.count*cellHeight;
    _anrList = anrList;
    [self.tableView reloadData];
    [self layoutIfNeeded];
}

- (void)setFps:(NSInteger)fps {
    _fps = fps;
    self.FpsLbl.text = [NSString stringWithFormat:@"FPS:%ld", (long)fps];
    if (fps < 50) {
        self.FpsLbl.textColor = [UIColor colorWithRed:227/255.0 green:23/255.0 blue:13/255.0 alpha:1];
    }
    else if (fps < 55) {
        self.FpsLbl.textColor = [UIColor colorWithRed:255/255.0 green:215/255.0 blue:0/255.0 alpha:1];
    }
    else {
        self.FpsLbl.textColor = [UIColor colorWithRed:0/255.0 green:199/255.0 blue:140/255.0 alpha:1];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.userInteractionEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
