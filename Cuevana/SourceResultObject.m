//
//  SourceResultObject.m
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 11/1/12.
//  Copyright (c) 2012 Camilo Vera Bezmalinovic. All rights reserved.
//

#import "SourceResultObject.h"

@implementation SourceResultObject

- (NSString*)languageForIndex:(NSInteger)index
{
//     {"1":"Espa\u00f1ol","2":"Ingl\u00e9s","3":"Portugu\u00e9s","4":"Alem\u00e1n","5":"Franc\u00e9s","6":"Coreano","7":"Italiano","8":"Tailand\u00e9s","9":"Ruso","10":"Mongol","11":"Polaco","12":"Esloveno","13":"Sueco","14":"Griego","15":"Canton\u00e9s","16":"Japon\u00e9s","17":"Dan\u00e9s","18":"Neerland\u00e9s","19":"Hebreo","20":"Serbio","21":"\u00c1rabe","22":"Hindi","23":"Noruego","24":"Turco","26":"Mandar\u00edn","27":"Nepal\u00e9s","28":"Rumano","29":"Iran\u00ed","30":"Est\u00f3n","31":"Bosnio","32":"Checo","33":"Croata","34":"Fin\u00e9s","35":"H\u00fanagro","36":"Persa","38":"Indonesio"};
    
    switch (index) {
        case 1: return @"Spanish";
        case 2: return @"English";
        case 3: return @"Portuguese";
        case 4: return @"German";
        case 5: return @"French";
        case 6: return @"Korean";
        case 7: return @"Italian";
        case 8: return @"Thai";
        case 9: return @"Russian";
        case 16: return @"Japanese";
        default: return [NSString stringWithFormat:@"%i",index];
    }
}
-(void)setLanguageIndex:(NSInteger)languageIndex
{
    _languageIndex = languageIndex;
    
    self.language = [self languageForIndex:languageIndex];
}


@end
