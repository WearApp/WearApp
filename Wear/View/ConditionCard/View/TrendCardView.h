//
//  TrendCardView.h
//  Wear
//
//  Created by 孙恺 on 15/12/5.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GraphKit/GraphKit.h>

@interface TrendCardView : UIView

+ (instancetype)viewFromNIB;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
