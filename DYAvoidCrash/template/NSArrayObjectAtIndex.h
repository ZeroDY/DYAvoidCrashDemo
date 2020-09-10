
if (index >= self.count) {
    NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
    NSString *place = [DYAvoidCrashRecord getMainCallStackSymbolMessageWithCallStackSymbols:callStackSymbolsArr];
    NSString *reason = [NSString stringWithFormat:@"index %@ out of count %@ of array ", @(index), @(self.count)];
    
    NSDictionary *errorInfo = @{
        @"place":place,
        @"target":[self class],
        @"method":DYSEL2Str(@selector(objectAtIndex:)),
        @"reason":reason,
        @"callStackSymbolsArr":callStackSymbolsArr,
    };
    
    [DYAvoidCrashRecord recordErrorWithReason:errorInfo errorType:DYAvoidCrashType_Container];
    
    return nil;
}

return DYHookOrgin(index);
