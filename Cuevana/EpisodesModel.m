//
//  ChaptersModel.m
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 5/12/13.
//  Copyright (c) 2013 Camilo Vera Bezmalinovic. All rights reserved.
//

#import "EpisodesModel.h"
#import "SearchResultObject.h"
#import "CuevanaConstants.h"
#import "SBJson.h"
#import "EpisodeResultObject.h"

@interface EpisodesModel ()
<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) SearchResultObject *searchResultObject;
@end
@implementation EpisodesModel

- (id)init
{
    self = [super init];
    if (self)
    {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        self.webView.delegate = self;
    }
    return self;
}

- (void)getEpisodesForSearchResultObject:(SearchResultObject*)object
{
    self.searchResultObject = nil;
    
    if (object.type != SearchResultObjectTypeSerie) return;
    
    self.searchResultObject = object;
    
    [self.webView stopLoading];
    self.arraySeasons= nil;
    
    NSString *replaced = [object.url.absoluteString stringByReplacingOccurrencesOfString:@"/series" withString:@""];
    replaced = [replaced stringByReplacingOccurrencesOfString:@"/" withString:@"&"];
    NSString *urlString = [NSString stringWithFormat:@"%@/web/series?%@",kCuevanaBaseURL,replaced];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - WebView Delegates
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *parser = @"document.getElementsByTagName('script')[0].innerHTML.replace(/(\\S|\\s)*serieList\\({\\w:/,\"\").replace(/,\\w\\:\\$\\(\\'#episodios'(\\s|\\S)*/,\"\");";
    NSString *seasonsString = [webView stringByEvaluatingJavaScriptFromString:parser];
    
    NSDictionary *seasons = [seasonsString JSONValue];
    
    NSInteger seasonIndex = 1;
    NSArray *episodesRaw = nil;
    
    NSMutableArray *mutableArraySeasons = [NSMutableArray array];
    
    while ( (episodesRaw = [seasons objectForKey:[NSString stringWithFormat:@"%i",seasonIndex]]) )
    {
        NSMutableArray *mutableArrayEpisodes = [NSMutableArray array];
        
        for (NSDictionary *episode in episodesRaw)
        {
            EpisodeResultObject *resultObject = [[EpisodeResultObject alloc] init];
            resultObject.seasonNumber = seasonIndex;
            resultObject.searchResultObject = self.searchResultObject;
            [resultObject fillWithDictionary:episode];
            [mutableArrayEpisodes addObject:resultObject];
        }
        [mutableArraySeasons addObject:mutableArrayEpisodes];
        seasonIndex++;
    }
    self.arraySeasons = mutableArraySeasons;
    
    [self.delegate episodesModel:self didFinishLoadingSeasons:self.arraySeasons];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.arraySeasons = nil;
    [self.delegate episodesModel:self didFinishLoadingSeasons:self.arraySeasons];
}

@end
