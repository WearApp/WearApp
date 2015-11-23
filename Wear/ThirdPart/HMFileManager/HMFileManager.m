//
//  HMFileManager.m
//  HMExtents
//
//  Created by yons on 15/7/9.
//  Copyright (c) 2015年 大兵布莱恩特. All rights reserved.
//

#import "HMFileManager.h"

@implementation HMFileManager

/// 把对象归档存到沙盒里
+(void)saveObject:(id)object byFileName:(NSString*)fileName
{
    NSString *path  = [self appendFilePath:fileName];
    
    [NSKeyedArchiver archiveRootObject:object toFile:path];
    
}
/// 通过文件名从沙盒中找到归档的对象
+(id)getObjectByFileName:(NSString*)fileName
{
    
    NSString *path  = [self appendFilePath:fileName];

    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

// 根据文件名删除沙盒中的 plist 文件
+(void)removeFileByFileName:(NSString*)fileName
{
    NSString *path  = [self appendFilePath:fileName];

    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

// 删除沙盒中所有的 plist 文件
+ (void)removeAllFiles {
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSError *error;
    
    NSArray<NSString *> *dir = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:&error];
    
    if (!dir || error) {
        NSLog(@"filePathError:%@", error.description);
        return;
    }
    
    for (NSString *fileName in dir) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsPath, fileName];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        NSLog(@"已删除文件%@", filePath);
    }
}

// 删除沙盒中除 exceptFile 外所有的 plist 文件
+ (void)removeAllFilesExcept:(NSString *)exceptFile {
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSError *error;
    
    NSArray<NSString *> *dir = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:&error];
    
    if (!dir) {
        NSLog(@"filePathError:%@", error.description);
        return;
    }
    
    for (NSString *fileName in dir) {
        if ([fileName isEqualToString:exceptFile]) {
            continue;
        }
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsPath, fileName];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        NSLog(@"已删除文件%@", filePath);
    }
}

/// 拼接文件路径
+(NSString*)appendFilePath:(NSString*)fileName
{
   
    NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
     NSString *file = [NSString stringWithFormat:@"%@/%@.plist",documentsPath,fileName];

    return file;
}

/// 存储用户偏好设置 到 NSUserDefults
+(void)saveUserData:(id)data forKey:(NSString*)key
{
    if (data)
    {
        [[NSUserDefaults standardUserDefaults]setObject:data forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}
/// 读取用户偏好设置
+(id)readUserDataForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:key];

}
/// 删除用户偏好设置
+(void)removeUserDataForkey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
}


@end
