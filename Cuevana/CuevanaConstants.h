//
//  CuevanaConstants.h
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 5/12/13.
//  Copyright (c) 2013 Camilo Vera Bezmalinovic. All rights reserved.
//

#ifndef Cuevana_CuevanaConstants_h
#define Cuevana_CuevanaConstants_h

#define kCuevanaBaseURL      @"http://www.cuevana.tv"
#define kCuevanaThumbnailURL @"http://sc.cuevana.tv/box/%@.jpg"

#define kCuevanaSearchPath          @"ajax/search"
#define kCuevanaPlayerGetSourcePath @"player/source_get"
#define kCuevanaPlayerSourcesPath   @"player/sources"

//TODO: Move this to another class.. without using #define
#define kCuevanaBackgroundColor [UIColor colorWithPatternImage:[UIImage imageNamed:@"view-background.png"]]


#endif
