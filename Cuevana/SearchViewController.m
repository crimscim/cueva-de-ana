//
//  ViewController.m
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 10/30/12.
//  Copyright (c) 2012 Camilo Vera Bezmalinovic. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultObject.h"
#import "SearchCell.h"
#import "SearchModel.h"
#import "CuevanaConstants.h"

#import "UIImageView+AFNetworking.h"
#import "EpisodesViewController.h"
#import "SourcesViewController.h"

@interface SearchViewController ()
<SearchModelDelegate,UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate>

@property(nonatomic,strong) SearchModel *model;
@property(nonatomic,strong) IBOutlet UITableView *tableView;
@end

@implementation SearchViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"La cueva de Ana";
    
    self.model = [[SearchModel alloc] init];
    self.model.delegate = self;
    
    self.view.backgroundColor = kCuevanaBackgroundColor;
    
    UITableView *tableViewResults = self.searchDisplayController.searchResultsTableView;
    tableViewResults.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViewResults.backgroundColor = self.view.backgroundColor;
    
}

#pragma mark - TableView Delegates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SearchCell cellHeight];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.arraySearchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:[SearchCell cellIdentifier]];
    
    if (cell == nil)cell = [SearchCell cell];
    
    SearchResultObject *resultObject = [self.model.arraySearchResults objectAtIndex:indexPath.row];
    
    cell.labelName.text = resultObject.title;
    cell.labelType.text = resultObject.typeString;
    cell.labelYear.text =  [NSString stringWithFormat:@"%i",resultObject.year];
    
    if (resultObject.isPlayable || resultObject.type == SearchResultObjectTypeSerie)
    {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    [cell.imageViewThumbnail setImageWithURL:resultObject.urlThumbnail];
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultObject *resultObject = [self.model.arraySearchResults objectAtIndex:indexPath.row];
    
    if (resultObject.type == SearchResultObjectTypeSerie)
    {
        EpisodesViewController *episodesView = [[EpisodesViewController alloc] initWithSearchResult:resultObject];
        [self.navigationController pushViewController:episodesView animated:YES];
    }
    else if (resultObject.type == SearchResultObjectTypeMovie && resultObject.isPlayable)
    {
        SourcesViewController *sourcesView = [[SourcesViewController alloc] initWithSearchResult:resultObject];
        [self.navigationController pushViewController:sourcesView animated:YES];
    }
}

#pragma mark - SearchDisplayController Delegate

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self.model search:searchString];
    controller.searchResultsTableView.backgroundColor = self.view.backgroundColor;
    controller.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return YES;
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self.model search:controller.searchBar.text];
    controller.searchResultsTableView.backgroundColor = self.view.backgroundColor;
    controller.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    return YES;
}

#pragma mark - SearchModel Delegate
-(void)searchModel:(SearchModel *)model didFinishLoading:(NSArray *)results
{
    [self.tableView reloadData];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

@end
