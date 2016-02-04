//
//  GraphHeadTableViewCell.h
//  Wear
//
//  Created by 孙恺 on 15/12/7.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GraphKit/GraphKit.h>

@interface GraphHeadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet GKLineGraph *graphView;
@end
