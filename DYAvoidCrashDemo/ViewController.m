//
//  ViewController.m
//  DYAvoidCrashDemo
//
//  Created by ZDY on 2020/9/10.
//  Copyright © 2020 ZDY. All rights reserved.
//

#import "ViewController.h"
#import "DYAvoidCrashRecord.h"

@interface ViewController () <DYAvoidCrashRecordProtocol>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [DYAvoidCrash registerAvoidCrash];
    [DYAvoidCrash registerRecordHandler:self];
    
    NSMutableString *mStr = @"NSString".mutableCopy;
    [mStr insertString:@"---" atIndex:9];
    [mStr deleteCharactersInRange:(NSRange){5,10}];
}

- (void)recordWithErrorInfo:(NSDictionary *)errorInfo {
    NSLog(@"\n=========================== XXX =============================\n%@", errorInfo);
}


@end
