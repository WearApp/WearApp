//
//  CityListViewController.m
//
//  Created by Big Watermelon on 11-11-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MLSearchBar.h"
#import "CityListViewController.h"
#import <STPopup/STPopup.h>
#import "CitySelectTableViewController.h"
#import "HotCityTableViewCell.h"

@interface CityListViewController ()<UITableViewDelegate, UITableViewDataSource, CitySelectDelegate, UISearchBarDelegate, UISearchResultsUpdating, HotCityCellDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, retain) UIImageView* checkImgView;

@property (strong,nonatomic) NSMutableArray  *dataList;
@property (strong,nonatomic) NSMutableArray  *searchList;

@property NSUInteger curSection;
@property NSUInteger curRow;
@end

@implementation CityListViewController {
    BOOL _moving;
    CGFloat _movingStartY;
}

#define CHECK_TAG 1110

@synthesize cities, keys, checkImgView, curSection, curRow;

- (instancetype)init
{
    self = [super init];
    if (self) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        self.contentSizeInPopup = CGSizeMake(screenSize.width/5*4, screenSize.height/5*3);
        self.landscapeContentSizeInPopup = CGSizeMake(screenSize.width/5*4, screenSize.height/5*3);
        self.draggable = YES;
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)setupSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width-60, 32);
    [self.searchController.searchBar setBackgroundColor:[UIColor clearColor]];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchController.searchBar];
    [self.navigationItem setRightBarButtonItem:searchItem animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.checkImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
    checkImgView.tag = CHECK_TAG;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSString *path=[[NSBundle mainBundle] pathForResource:@"provincedictionary"
                                                   ofType:@"plist"]; 
    self.cities = [[NSDictionary alloc]   
                        initWithContentsOfFile:path];
    
//    self.keys = [[cities allKeys] sortedArrayUsingSelector:  
//                    @selector(compare:)];
    
    
    
    self.keys = [[cities allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSUInteger len0 = [(NSString *)obj1 length];
        NSUInteger len1 = [(NSString *)obj2 length];
        return len0 > len1 ? NSOrderedAscending : NSOrderedDescending;
    }];
    
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.tableView setSectionIndexColor:[UIColor blackColor]];
    
    [self.popupController.navigationBar setTranslucent:NO];
    
    
    // TODO: search
//    [self setupSearchController];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.keys = nil;
    self.cities = nil;
    self.checkImgView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchController.active) {
        return 1;
    }else {
        // Return the number of sections.
        return [keys count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return self.searchList.count;
    }else {
        // Return the number of rows in the section.
        NSString *key = [keys objectAtIndex:section];  
        NSArray *citySection = [cities objectForKey:key];
        return [citySection count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        HotCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotcityCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HotCityTableViewCell" owner:self options:nil] lastObject];
        }
        cell.delegate = self;
        return cell;
    } else {
    
    
        static NSString *CellIdentifier = @"Cell";
        
        NSString *key = [keys objectAtIndex:indexPath.section];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        } else {
            for (UIView *view in cell.contentView.subviews) {
                if (view.tag == CHECK_TAG) {
                    if (indexPath.section != curSection || indexPath.row != curRow)
                        checkImgView.hidden = true;
                    else
                        checkImgView.hidden = false;
                }
            }
        }
        if (self.searchController.active) {
            [cell.textLabel setText:self.searchList[indexPath.row]];
        } else {
            // Configure the cell...
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:18];
            cell.textLabel.text = [[cities objectForKey:key] objectAtIndex:indexPath.row];
        }
        return cell;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *key = [keys objectAtIndex:section];
    return key;  
}  
 
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView  
//{
//    return keys;  
//}


-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //过滤数据
    self.searchList= [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [self.tableView reloadData];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
//    view.backgroundColor = self.view.backgroundColor;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return tableView.rowHeight/2;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.rowHeight/2)];
//    [headerView setBackgroundColor:self.view.backgroundColor];
//    
//    NSString *key = [keys objectAtIndex:section];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, tableView.rowHeight/2)];
//    label.text = key;
//    label.textColor = [UIColor whiteColor];
//    label.backgroundColor = [UIColor clearColor];
//    [headerView addSubview:label];
//    
//    return headerView;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        return 160;
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    // Navigation logic may go here. Create and push another view controller.
//    /*
//     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     [detailViewController release];
//     */
//    
//    //clear previous selection first
//    [checkImgView removeFromSuperview];
//    
//    //add new check mark
//    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//    
//    //make sure the image size is fit for cell height;
//    
//    CGRect cellRect = cell.bounds;
//    float imgHeight = cellRect.size.height * 2 / 3; // 2/3 cell height
//    float imgWidth = 20.0; //hardcoded
//    
//    
//    checkImgView.frame = CGRectMake(cellRect.origin.x + cellRect.size.width - 100, //shift for index width plus image width 
//                                    cellRect.origin.y + cellRect.size.height / 2 - imgHeight / 2, 
//                                    imgWidth, 
//                                    imgHeight);
//    
//    [cell.contentView addSubview:checkImgView];
//    checkImgView.hidden = false;
//    
//    curSection = indexPath.section;
//    curRow = indexPath.row;
    
    CitySelectTableViewController *tablevc = [[CitySelectTableViewController alloc] init];
    tablevc.provinceName = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    tablevc.delegete = self;
    [self.popupController pushViewController:tablevc animated:YES];
    
//    [self.delegete didSelectCityWithName:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectCityWithName:(NSString *)cityName {
    [self.delegete didSelectCityWithName:cityName];
}

- (void)didSelectHotCity:(NSString *)cityName {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegete didSelectCityWithName:cityName];
    }];
}

@end
