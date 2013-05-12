//
//  SourceResultObject.h
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 11/1/12.
//  Copyright (c) 2012 Camilo Vera Bezmalinovic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SourceResultObject : NSObject

@property(nonatomic,strong) NSNumber *sourceId;
@property(nonatomic,strong) NSString *sourceType;
@property(nonatomic,strong) NSString *hostName;
@property(nonatomic,strong) NSString *language;
@property(nonatomic,assign) NSInteger languageIndex;
@property(nonatomic,assign) NSInteger quality;


@end
