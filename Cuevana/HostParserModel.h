//
//  HostParserModel.h
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 5/12/13.
//  Copyright (c) 2013 Camilo Vera Bezmalinovic. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HostParserModelDelegate;

@interface HostParserModel : NSObject
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,weak) id <HostParserModelDelegate> delegate;
- (void)getFileURLFromURL:(NSURL*)url;
- (void)cancelAll;
@end

@protocol HostParserModelDelegate <NSObject>
- (void)hostParserModel:(HostParserModel*)model didFinishLoadingFileURL:(NSURL*)url;
@end
