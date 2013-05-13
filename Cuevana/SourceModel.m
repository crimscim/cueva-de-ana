//
//  SourceModel.m
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 5/12/13.
//  Copyright (c) 2013 Camilo Vera Bezmalinovic. All rights reserved.
//

#import "SourceModel.h"
#import "AFNetworking.h"
#import "CuevanaConstants.h"
#import "SBJson.h"
#import "SourceResultObject.h"
#import "EpisodeResultObject.h"
#import "SearchResultObject.h"
@interface SourceModel ()
<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) AFHTTPClient *httpClient;
@end

@implementation SourceModel

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kCuevanaBaseURL]];
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        self.webView.delegate = self;
    }
    return self;
}

- (void)getSourcesForEpisodeResultObject:(EpisodeResultObject*)object
{
    if (object.searchResultObject.type == SearchResultObjectTypeSerie)
    {
        [self getSourcesWithID:object.resultId andType:@"serie"];
    }
}
- (void)getSourcesForSearchResultObject:(SearchResultObject*)object
{
    if (object.type == SearchResultObjectTypeMovie)
    {
        [self getSourcesWithID:object.resultId andType:@"pelicula"];
    }
}
- (void)getCaptchaForSourceResultObject:(SourceResultObject*)object
{
    NSDictionary *params = @{@"def":@(object.quality),
                             @"audio":@(object.languageIndex),
                             @"host":object.hostName,
                             @"id":object.sourceId,
                             @"tipo":object.sourceType};
    
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"GET"
                                                                 path:kCuevanaPlayerGetSourcePath
                                                           parameters:params];
    
    [self.webView loadRequest:request];
}

- (void)getSourcesWithID:(NSNumber*)ID andType:(NSString*)type
{
    //NSString *urlString = @"http://www.cuevana.tv/player/sources?id=1533&tipo=serie";
    //NSString *urlString = @"http://www.cuevana.tv/player/source_get?def=720&audio=2&host=bayfiles&id=1533&tipo=serie";
    
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"GET"
                                                                 path:kCuevanaPlayerSourcesPath
                                                           parameters:@{@"id":ID,@"tipo":type}];
    
    AFHTTPRequestOperation *requestOp = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [requestOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSRange rangeOne = [operation.responseString rangeOfString:@"var sources = "];
         NSRange rangeTwo = [operation.responseString rangeOfString:@", sel_source = 0;"];
         
         NSRange find;
         find.location = rangeOne.location+rangeOne.length;
         find.length = rangeTwo.location - find.location;
         
         NSString *sources = [operation.responseString substringWithRange:find];
    
         NSDictionary *dictionarySources = [sources JSONValue];
         
         NSMutableArray *mutableArraySources = [NSMutableArray array];
         for (NSString *langKey in dictionarySources)
         {
             NSDictionary *dictionarylanguages = [dictionarySources objectForKey:langKey];
             for (NSString *quialityKey in dictionarylanguages)
             {
                 NSArray *arraySources = [dictionarylanguages objectForKey:quialityKey];
                 for (NSString *source in arraySources)
                 {
                     SourceResultObject *resultObject = [[SourceResultObject alloc] init];
                     
                     resultObject.hostName      = source;
                     resultObject.languageIndex = [langKey integerValue];
                     resultObject.quality       = [quialityKey integerValue];
                     resultObject.sourceId      = ID;
                     resultObject.sourceType    = type;
                     
                     [mutableArraySources addObject:resultObject];
                 }
             }
         }
         
         self.arraySources = mutableArraySources;
        
         [self.delegate sourceModel:self didFinishLoadingSources:self.arraySources];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         self.arraySources = nil;
         [self.delegate sourceModel:self didFinishLoadingSources:self.arraySources];
     }];
    [self.httpClient enqueueHTTPRequestOperation:requestOp];
    
    
}

#pragma mark UIWebView Delegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    
    if (urlString &&
        ([urlString rangeOfString:@"player/linkto"].location!=NSNotFound ||
         [urlString rangeOfString:@"player/play_new"].location!=NSNotFound ))
    {
        NSRange urlRange = [urlString rangeOfString:@"url="];

        NSString *urlRaw = [urlString substringFromIndex:urlRange.location+urlRange.length];

        NSString *urlDecoded = [urlRaw stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        NSArray *split = [urlDecoded componentsSeparatedByString:@"&id"];
        
        if (split.count > 0) {
            urlDecoded = split[0];
        }
        
        [self.delegate sourceModel:self didFinishLoadingSourceURL:[NSURL URLWithString:urlDecoded]];
        
        return NO;
    }
    
    return YES;
}
@end
