//
//  UIWebView+JS.m
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 5/15/13.
//  Copyright (c) 2013 Camilo Vera Bezmalinovic. All rights reserved.
//

#import "UIWebView+JS.h"

@implementation UIWebView (JS)
- (NSString*)js:(NSString*)js
{
    return [self stringByEvaluatingJavaScriptFromString:js];
}
@end
