//
//  GuideCardViewController.m
//  Wear
//
//  Created by 孙恺 on 15/11/28.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import "GuideCardViewController.h"
#import <STPopup/STPopup.h>

@interface GuideCardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cardBigLabel;
@property (weak, nonatomic) IBOutlet UILabel *descritpionLabel;

@end

@implementation GuideCardViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @" ";
        //        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextBtnDidTap)];
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        self.contentSizeInPopup = CGSizeMake(screenSize.width/5*4, screenSize.height/5*3);
        self.landscapeContentSizeInPopup = CGSizeMake(screenSize.height/5*4, screenSize.width/5*3);
        self.draggable = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.popupController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    self.popupController.navigationBar.barStyle = UIBarStyleBlack;
    self.popupController.navigationBar.translucent = NO;
    [self.popupController.navigationBar setShadowImage:[UIImage new]];
}

- (void)setBigText:(NSString *)bigtext description:(NSString *)descriptionText {
    [self.cardBigLabel setText:bigtext];
    [self.descritpionLabel setText:descriptionText];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:self.popupController.navigationBar.barTintColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
