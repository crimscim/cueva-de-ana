//
//  HostParserModel.m
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 5/12/13.
//  Copyright (c) 2013 Camilo Vera Bezmalinovic. All rights reserved.
//

#import "HostParserModel.h"

typedef enum
{
    HostParserTypeFileBox,
    HostParserTypeBayFiles,
    HostParserTypeMovreel,
    HostParserTypeUpToBox,
    HostParserTypeLimeVideo,
    HostParserTypeDoneVideo,
    HostParserTypeVideoZed
}HostParserType;

//added to type a little less
@interface UIWebView (JS) - (NSString*)js:(NSString*)js; @end
@implementation UIWebView (JS) - (NSString*)js:(NSString*)js{return [self stringByEvaluatingJavaScriptFromString:js];} @end

@interface HostParserModel ()
<UIWebViewDelegate>
@property (nonatomic,assign) HostParserType type;
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

    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];

}
#pragma mark - webView Delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.type == HostParserTypeFileBox)
    {
        [self parseFileBox];
    }
}
- (void)parseFileBox
{
    BOOL isButton = [self.webView js:@"$('#btn_download').length;"].boolValue;
    BOOL isPlayer = [self.webView js:@"$('#player').length;"].boolValue;
    if (isButton)
    {
        [self.webView js:@"setTimeout(\"$('#btn_download').click();\",1000*10);"];
    }
    else if (isPlayer && ![self.webView js:@"player_once;"].boolValue)
    {
        //NSString *url = [self.webView js:@"$('input.b').filter(':button').attr('onclick').slice(19,-1);"];
        NSString *url = [self.webView js:@"$('#player').attr('href');"];
        [self.delegate hostParserModel:self didFinishLoadingFileURL:[NSURL URLWithString:url]];
        
        [self.webView js:@"var player_once = true;"];
    }
}
@end
