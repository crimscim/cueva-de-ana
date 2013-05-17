//
//  SourcesViewController.m
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 11/1/12.
//  Copyright (c) 2012 Camilo Vera Bezmalinovic. All rights reserved.
//

#import "SourcesViewController.h"
#import "SourceModel.h"
#import "SourceResultObject.h"
#import "HostParserModel.h"
#import "PlayerViewController.h"
@interface SourcesViewController ()
<UITableViewDataSource,UITableViewDelegate,SourceModelDelegate,HostParserModelDelegate,UIActionSheetDelegate>

@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property(nonatomic,strong) IBOutlet UIControl *viewMessage;

@property(nonatomic,strong) SourceModel *model;
@property(nonatomic,strong) HostParserModel *hostParserModel;

@property(nonatomic,strong) PlayerViewController *player;
@property(nonatomic,assign) NSUInteger selectedSub;
@end

@implementation SourcesViewController

- (id)initWithEpisodeResult:(EpisodeResultObject *)resultObject
{
    self = [super init];
    if (self)
    {
        self.hostParserModel = [[HostParserModel alloc] init];
        self.hostParserModel.delegate = self;
        self.model = [[SourceModel alloc] init];
        self.model.delegate = self;
        [self.model getSourcesForEpisodeResultObject:resultObject];

    }
    return self;
}
- (id)initWithSearchResult:(SearchResultObject *)resultObject
{
    self = [super init];
    if (self)
    {
        self.hostParserModel = [[HostParserModel alloc] init];
        self.hostParserModel.delegate = self;
        self.model = [[SourceModel alloc] init];
        self.model.delegate = self;
        [self.model getSourcesForSearchResultObject:resultObject];

    }
    return self;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Sources";
    self.selectedSub = INT16_MAX;
}

#pragma mark - TableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.arraySources.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"source-cell-identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    SourceResultObject *resultObject = [self.model.arraySources objectAtIndex:indexPath.row];
    cell.textLabel.text = resultObject.hostName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Quality: %i - Language: %@",resultObject.quality,resultObject.language];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SourceResultObject *resultObject = [self.model.arraySources objectAtIndex:indexPath.row];

    [self.model getSourceFileForSourceResultObject:resultObject];
    //[self.model getCaptcha:resultObject];
    
}

#pragma mark - SourceModel Delegate
-(void)sourceModel:(SourceModel *)model didFinishLoadingSources:(NSArray *)sources
{
    [self.tableView reloadData];
}
- (void)sourceModel:(SourceModel*)model didFinishLoadingSourceURL:(NSURL*)url
{
    NSLog(@"Will Parse: %@",url);
    
#warning this is added just for testing
    self.hostParserModel.webView.frame = self.view.bounds;
    self.hostParserModel.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.hostParserModel.webView];
    
    self.viewMessage.frame = self.view.bounds;
    [self.view addSubview:self.viewMessage];
    
    [self.hostParserModel getFileURLFromURL:url];
}
-(void)sourceModel:(SourceModel *)model didFinishLoadingSubtitles:(NSArray *)subsArray
{    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Subtitles"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    //get the subtitles language
    NSString *srt = @"ID.srt";
    for (NSString *urlSubs in subsArray)
    {
        NSString *code = [urlSubs substringWithRange:NSMakeRange(urlSubs.length-srt.length, 2)];
        NSString *lang = [[NSLocale currentLocale] displayNameForKey:NSLocaleLanguageCode value:code];
        
        [actionSheet addButtonWithTitle:lang];
    }
    [actionSheet addButtonWithTitle:@"None"];
    
    [actionSheet showInView:self.view];
    
}
#pragma mark - HostParserModel Delegate
-(void)hostParserModel:(HostParserModel *)model didFinishLoadingFileURL:(NSURL *)url
{
    NSLog(@"File URL: %@",url);
    
    [self.viewMessage removeFromSuperview];
    [model.webView removeFromSuperview];
    
    self.player = [[PlayerViewController alloc] initWithContentURL:url];
    [self presentMoviePlayerViewControllerAnimated:self.player];
    [self.player.moviePlayer prepareToPlay];

    //if the user has selected subtitles will use it
    if (self.model.arraySubtitles.count >0 && self.selectedSub < self.model.arraySubtitles.count)
    {
         [self.player loadSubtitlesFromURL:[NSURL URLWithString:self.model.arraySubtitles[self.selectedSub]]];
    }
}

#pragma mark - actionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex < self.model.arraySubtitles.count)
    {
        self.selectedSub = buttonIndex;
    }
    else
    {
        self.selectedSub = INT16_MAX;
    }
}

-(void)dealloc
{
    [self.model cancelAll];
    [self.hostParserModel cancelAll];
}

@end

