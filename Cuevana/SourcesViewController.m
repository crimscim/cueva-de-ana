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
@interface SourcesViewController ()
<UITableViewDataSource,UITableViewDelegate,SourceModelDelegate>

@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property(nonatomic,strong) SourceModel *model;
@end


@implementation SourcesViewController

- (id)initWithEpisodeResult:(EpisodeResultObject *)resultObject
{
    self = [super init];
    if (self)
    {
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
    
    [self createButtonBack];

}
- (void)createButtonBack
{
    UIImage *backImage = [UIImage imageNamed:@"button-back.png"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0, 0, backImage.size.width, backImage.size.height)];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
}
- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
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

    [self.model getCaptchaForSourceResultObject:resultObject];
    //[self.model getCaptcha:resultObject];
    
}

#pragma mark - SourceModel Delegate
-(void)sourceModel:(SourceModel *)model didFinishLoadingSources:(NSArray *)sources
{
    [self.tableView reloadData];
}
- (void)sourceModel:(SourceModel*)model didFinishLoadingSourceURL:(NSURL*)url;
{

}

//- (void)cuevanaCaptchaNotification:(NSNotification*)notification
//{
//    [self.view addSubview:self.model.webView];
//    
//    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
//        CGRect frame = self.model.webView.frame;
//        frame.origin.y = 0;
//        self.model.webView.frame = frame;
//        [self.tableView setContentInset:UIEdgeInsetsMake(frame.size.height, 0, 0, 0)];
//        [self.tableView setScrollIndicatorInsets:self.tableView.contentInset];
//        [self.tableView scrollToRowAtIndexPath:self.tableView.indexPathForSelectedRow atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//
//    } completion:^(BOOL finished) {
//        
//    }];
//    
//}
//- (void)cuevanaSourceURLNotification:(NSNotification*)notification
//{
////    NSURL *url = notification.userInfo[@"URL"];
////    MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
////    [self.navigationController presentMoviePlayerViewControllerAnimated:moviePlayer];
////    self.moviePlayer = moviePlayer;
//}
//- (void)keyboardWillShow:(NSNotification*)notification
//{
//    [self performSelector:@selector(readjustWebviewScroller) withObject:nil afterDelay:0];
//}
//- (void)readjustWebviewScroller {
//    self.model.webView.scrollView.bounds = self.model.webView.bounds;
//}
@end
