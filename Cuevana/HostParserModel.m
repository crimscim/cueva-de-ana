//
//  HostParserModel.m
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 5/12/13.
//  Copyright (c) 2013 Camilo Vera Bezmalinovic. All rights reserved.
//

#import "HostParserModel.h"
#import "UIWebView+JS.h"
typedef enum
{
    HostParserTypeNone,
    HostParserTypeFileBox,
    HostParserTypeBayFiles,
    HostParserTypeMovreel,
    HostParserTypeUpToBox,
    HostParserTypeLimeVideo,
    HostParserTypeDoneVideo,
    HostParserTypeVideoZed,
    HostParserTypeBillionUploads
}HostParserType;

@interface HostParserModel ()
<UIWebViewDelegate>
@property (nonatomic,assign) HostParserType type;
@property (nonatomic,assign) HostParserType currentParser;
@property (nonatomic,strong) NSString *parsingString;
@end
@implementation HostParserModel

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768-20-44)];
        self.webView.delegate = self;
    }
    
    return self;
}
- (void)cancelAll
{
    [self.webView stopLoading];
}
- (void)getFileURLFromURL:(NSURL*)url
{
    NSString *urlString = url.absoluteString;
    
    if ([urlString rangeOfString:@"filebox.com"].location!=NSNotFound)
    {
        self.type = HostParserTypeFileBox;
    }
    else if ([urlString rangeOfString:@"bayfiles.net"].location!=NSNotFound)
    {
        self.type = HostParserTypeBayFiles;
    }
    else if ([urlString rangeOfString:@"movreel.com"].location!=NSNotFound)
    {
        self.type = HostParserTypeMovreel;
    }
    else if ([urlString rangeOfString:@"uptobox.com"].location!=NSNotFound)
    {
        self.type = HostParserTypeUpToBox;
    }
    else if ([urlString rangeOfString:@"limevideo.net"].location!=NSNotFound)
    {
        self.type = HostParserTypeLimeVideo;
    }
    else if ([urlString rangeOfString:@"donevideo.com"].location!=NSNotFound)
    {
        self.type = HostParserTypeDoneVideo;
    }
    else if ([urlString rangeOfString:@"videozed"].location!=NSNotFound)
    {
        self.type = HostParserTypeVideoZed;
    }
    else if ([urlString rangeOfString:@"billionuploads.com"].location !=NSNotFound)
    {
        self.type = HostParserTypeBillionUploads;
    }

    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];

}
#pragma mark - webView Delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.type == HostParserTypeFileBox)
    {
        [self parseHost:HostParserTypeFileBox fromResource:@"filebox"];
    }
    else if(self.type == HostParserTypeBillionUploads)
    {
        [self parseHost:HostParserTypeBillionUploads fromResource:@"billionUploads"];
    }
    else if (self.type == HostParserTypeMovreel)
    {
        [self parseHost:HostParserTypeMovreel fromResource:@"movreel"];
    }
    else if (self.type == HostParserTypeUpToBox)
    {
        [self parseHost:HostParserTypeUpToBox fromResource:@"uptobox"];
    }
    else if (self.type == HostParserTypeLimeVideo)
    {
        [self parseHost:HostParserTypeLimeVideo fromResource:@"limevideo"];
    }
    else if (self.type == HostParserTypeBayFiles)
    {
        [self parseHost:HostParserTypeBayFiles fromResource:@"bayfiles"];
    }
    else
    {
        return;
    }
    NSString *response = [webView js:self.parsingString];
    
    //why 12?... mm I don't know :D.. http:// .mp4
    if ([response isKindOfClass:[NSString class]] && response.length > 12)
    {
        [self.delegate hostParserModel:self didFinishLoadingFileURL:[NSURL URLWithString:response]];
    }

}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    if ([urlString rangeOfString:@"fhserve"].location!=NSNotFound ||
        [urlString rangeOfString:@"yieldmanager"].location!=NSNotFound ||
        [urlString rangeOfString:@"propellerads"].location!=NSNotFound ||
        [urlString rangeOfString:@"facebook"].location!=NSNotFound)
    {
        return NO;
    }//special case for bayfiles.. hate this shit
    else if (self.type == HostParserTypeBayFiles &&
             [urlString rangeOfString:@"bayfiles.net"].location == NSNotFound &&
             [urlString hasSuffix:@".mp4"])
    {
        [self.delegate hostParserModel:self didFinishLoadingFileURL:[NSURL URLWithString:urlString]];
        return NO;
    }
    
    return YES;
}
- (void)parseHost:(HostParserType)type fromResource:(NSString*)resource
{
    if (self.parsingString == nil || self.currentParser != type)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:@"js"];
        self.parsingString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        self.currentParser = type;
    }
}

@end
