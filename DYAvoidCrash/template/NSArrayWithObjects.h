NSInteger newObjsIndex = 0;
id  _Nonnull __unsafe_unretained newObjects[cnt];
for (int i = 0; i < cnt; i++) {
    
    id objc = objects[i];
    if (objc == nil) {
        NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
        
        NSString *reason = @"Array constructor appear nil.";
        
        NSDictionary *errorInfo = @{
            @"target":[self class],
            @"method":DYSEL2Str(@selector(arrayWithObjects:count:)),
            @"reason":reason,
            @"callStackSymbolsArr":callStackSymbolsArr,
        };
        
        [DYAvoidCrashRecord recordErrorWithReason:errorInfo errorType:DYAvoidCrashType_Container];
        continue;
    }
    newObjects[newObjsIndex++] = objc;
    
}
return DYHookOrgin(newObjects, newObjsIndex);
