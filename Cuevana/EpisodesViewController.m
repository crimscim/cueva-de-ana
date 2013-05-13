//
//  SeasonViewController.m
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 10/31/12.
//  Copyright (c) 2012 Camilo Vera Bezmalinovic. All rights reserved.
//

#import "EpisodesViewController.h"
#import "SourcesViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SearchResultObject.h"
#import "SearchCell.h"
#import "EpisodesModel.h"
#import "EpisodeResultObject.h"
#import "CuevanaConstants.h"

@interface EpisodesViewController ()
<UITableViewDataSource,UITableViewDelegate,EpisodesModelDelegate>

@property (nonatomic,strong) EpisodesModel *model;
@property (nonatomic,strong) SearchResultObject *searchResult;
@property (nonatomic,strong) IBOutlet UIView *viewHeader;
@property (nonatomic,strong) IBOutlet UITableView *tableView;
@end

@implementation EpisodesViewController

-(id)initWithSearchResult:(SearchResultObject*)resultObject;
{
    self = [super init];
    
    if (self)
    {
        self.searchResult = resultObject;
        self.model = [[EpisodesModel alloc] init];
        self.model.delegate = self;
    }
    
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.model getEpisodesForSearchResultObject:self.searchResult];

    self.title = self.searchResult.title;
    self.view.backgroundColor = kCuevanaBackgroundColor;
    
    [self createHeaderView];
    
}
- (void)createHeaderView
{
    SearchCell *cell = [SearchCell cell];
    
    [cell.imageViewThumbnail setImageWithURL:self.searchResult.urlThumbnail];
    
    cell.labelName.text = self.searchResult.title;
    cell.labelType.text = self.searchResult.typeString;
    cell.labelYear.text = [NSString stringWithFormat:@"%i",self.searchResult.year];
    cell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.viewHeader addSubview:cell];
}
#pragma mark - TableView Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.model.arraySeasons.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.model.arraySeasons objectAtIndex:section] count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Season %i",section+1];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"episode-cell-identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    EpisodeResultObject *resultObject = [[self.model.arraySeasons objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = resultObject.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",resultObject.episodeNumber];
        
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EpisodeResultObject *resultObject = [[self.model.arraySeasons objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    SourcesViewController *sourcesView = [[SourcesViewController alloc] initWithEpisodeResult:resultObject];
    [self.navigationController pushViewController:sourcesView animated:YES];

}

#pragma mark - EpisodesModel Delegate
-(void)episodesModel:(EpisodesModel *)model didFinishLoadingSeasons:(NSArray *)seasons
{
    [self.tableView reloadData];
}
@end
