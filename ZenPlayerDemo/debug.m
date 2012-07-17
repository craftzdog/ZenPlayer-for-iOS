//
//  debug.m
//  walknote
//
//  Created by noradaiko on 2/9/12.
//  Copyright (c) 2012 noradaiko. All rights reserved.
//

#include "debug.h"

void uncaughtExceptionHandler(NSException *exception)
{    
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}
