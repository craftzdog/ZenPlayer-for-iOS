//
//  debug.h
//  walknote
//
//  Created by noradaiko on 7/19/11.
//  Copyright 2012 noradaiko. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef walknote_debug_h
#define walknote_debug_h


#define  __FILENAME__  [[NSString stringWithCString:__FILE__ encoding:NSStringEncodingConversionAllowLossy] lastPathComponent]

#ifdef DEBUG
#  define LOG(...) NSLog(@"%@:%d@%@/%@ %@", __FILENAME__, __LINE__, NSStringFromClass([self class]), NSStringFromSelector(_cmd), [NSString stringWithFormat:__VA_ARGS__])
#  define LOG_ERR(...) NSLog(@"%@:%d@%@/%@ [ERROR] %@", __FILENAME__, __LINE__, NSStringFromClass([self class]), NSStringFromSelector(_cmd), [NSString stringWithFormat:__VA_ARGS__])
#  define LOG_CURRENT_METHOD NSLog(@"%@:%d@%@/%@", __FILENAME__, __LINE__, NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#else
#  define LOG(...) 
#  define LOG_ERR(...) 
#  define LOG_CURRENT_METHOD {}
#endif


#endif


#define MAMAMA LOG


void uncaughtExceptionHandler(NSException *exception);

