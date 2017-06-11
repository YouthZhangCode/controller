//
//  CompetitorModel.m
//  LiveControl
//
//  Created by fy on 2017/6/8.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "CompetitorModel.h"

@implementation CompetitorModel

- (void)setName:(NSString *)name {
    _name = name;
    NSMutableString *mStr = [[NSMutableString alloc] initWithString:name];
    if (CFStringTransform((__bridge CFMutableStringRef)mStr, 0, kCFStringTransformMandarinLatin, NO)) {
        NSLog(@"pinyin:-- %@", mStr);
    }
    if (CFStringTransform((__bridge CFMutableStringRef)mStr, 0, kCFStringTransformStripDiacritics, NO)) {
        NSString *bigStr = [mStr uppercaseString];
        NSString *cha = [bigStr substringToIndex:1];
        self.firstLetter = cha;
    }else {
        self.firstLetter = [name substringToIndex:1];
    }
}

@end
