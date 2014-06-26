//
//  CommonDeal.h
//  TestFolderAndFile
//
//  Created by user on 13-7-26.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonDeal : NSObject

/*!
 @method
 @abstract     获取文件管理器
 @discussion
 @param
 @result       返回一个文件管理器
 */
+ (NSFileManager *)getFileManagement;

/*!
 @method
 @abstract     获取根目录路径
 @discussion
 @param        
 @result       返回根目录的路径
 */
+ (NSString *)getHomePath;

/*!
 @method
 @abstract     获取Document目录路径
 @discussion
 @param        
 @result       返回Document目录的路径
 */
+ (NSString *)getDocumentPath;

/*!
 @method
 @abstract     获取Library目录路径
 @discussion
 @param        
 @result       返回Library目录的路径
 */
+ (NSString *)getLibraryPath;

/*!
 @method
 @abstract     获取Tmp目录路径
 @discussion
 @param        
 @result       返回Tmp目录的路径
 */
+ (NSString *)getTmpPath;

/*!
 @method
 @abstract     获取Cache目录路径
 @discussion
 @param
 @result       返回Cache目录的路径
 */
+ (NSString *)getCachePath;

/*!
 @method
 @abstract     获取某个路径下的所有文件（包括文件夹与文件）
 @discussion
 @param        path_:需要获取哪个路径下的文件
 @result       返回传入路径下的所有文件
 */
+ (NSArray *)getAllFileWithPath:(NSString *)path_;

/*!
 @method
 @abstract     获取某个文件的创建日期
 @discussion
 @param        filePath:文件路径
 @result       返回该文件的创建日期
 */
+ (NSString *)getFileCreateDate:(NSString *)filePath;

/*!
 @method
 @abstract     获取某个文件的创建日期,用于排序
 @discussion
 @param        filePath:文件路径
 @result       返回该文件的创建日期，包括时分秒
 */
+ (NSString *)getFileSortDate:(NSString *)filePath;

/*!
 @method
 @abstract     获取某个文件的大小
 @discussion
 @param        filePath:文件路径
 @result       返回该文件的大小
 */
+ (NSString *)getFileSizer:(NSString *)filePath;

/*!
 @method
 @abstract     获取某个文件的文件类型
 @discussion
 @param        fileName:文件名称
 @result       返回该文件的文件类型
 */
+ (NSString *)getFileType:(NSString *)fileName;

/*!
 @method
 @abstract     获取某个文件文件图标名称
 @discussion
 @param        fileType:文件类型
 @result       返回该文件的图标名
 */
+ (NSString *)getFileIconImageName:(NSString *)fileType;

/*!
 @method
 @abstract     获取某个路径下的所有文件夹
 @discussion
 @param        path_:需要获取哪个路径下的文件夹
 @result       返回传入路径下的所有文件夹
 */
+ (NSArray *)getOnlyFolderWithPath:(NSString *)path_;

/*!
 @method
 @abstract     获取某个路径下的所有文件（不包括文件夹）
 @discussion
 @param        path_:需要获取哪个路径下的文件
 @result       返回传入路径下的所有文件
 */
+ (NSArray *)getOnlyFileWithPath:(NSString *)path_;

/*!
 @method
 @abstract     根据传入的路径，判断当前文件是否是文件夹
 @discussion
 @param        path_:当前选择文件的路径
 @result       返回该文件是否为文件夹
 */
+ (BOOL)chectIsFolder:(NSString *)path_;

/*!
 @method
 @abstract     根据传入的路径，判断当前目录是否可写
 @discussion
 @param        path_:当前目录的路径
 @result       返回该目录是否可写
 */
+ (BOOL)chectIsCanBeWriter:(NSString *)path_;


/*!
 @method
 @abstract     根据传入的路径与名称，创建新文件夹
 @discussion
 @param        directoryPath:当前选择的目录路径  folderName:需要创建的文件夹名称
 @result       返回是否创建成功
 */
+ (void)createNewFolder:(NSString *)directoryPath andFolderName:(NSString *)folderName;

/*!
 @method
 @abstract     根据传入的路径与名称，创建新文件
 @discussion
 @param        directoryPath:当前选择的目录路径  fileName:需要创建的文件名称  data:文件内容
 @result
 */
+ (void)createNewFile:(NSString *)directoryPath
          andFileName:(NSString *)fileName
              andData:(NSData *)data;

/*!
 @method
 @abstract     根据传入的路径与名称，读取文件内容
 @discussion
 @param        path_:当前文件所在路径  fileName:文件名
 @result       返回文件内容
 */
+ (NSData *)getfileInfo:(NSString *)path_ andFileName:(NSString *)fileName;

/*!
 @method
 @abstract     根据传入的路径删除文件
 @discussion
 @param        path_:需要删除的文件路径   目录路径＋文件名
 @result       返回删除成功标识
 */
+ (void)deleteFile:(NSString *)path_ andFileName:(NSString *)fileName;

/*!
 @method
 @abstract     上传图片
 @discussion
 @param        path_:上传的目录路径  image_:上传的图片
 @result       
 */
+ (void)upLoadImageWithPath:(NSString *)path_ andImage:(UIImage *)image_;

/*!
 @method
 @abstract     判断当前文件是否是个图片
 @discussion
 @param        fileName:需要判断的文件名
 @result
 */
+ (BOOL)checkIsImage:(NSString *)fileName;

/*!
 @method
 @abstract     判断一个字符串中是否含 另一个字符串
 @discussion
 @param        fileName:原字符串  otherStr:需要判断的字符串
 @result
 */
+ (BOOL)checkFileName:(NSString *)fileName andOther:(NSString *)otherStr;

/*!
 @method
 @abstract     获取当前时间转换为字符串格式
 @discussion
 @param        
 @result       返回当前时间字符串
 */
+ (NSString *)getNowDateTime;

/*!
 @method
 @abstract     修改文件夹名称
 @discussion
 @param        oldName:需要修改的文件夹名称  newName:修改后的名称  path_:文件夹所在路径
 @result       返回修改是否成功标志
 */
+ (void)updateFileNameWithOldName:(NSString *)oldName
                       andNewName:(NSString *)newName
                          andPath:(NSString *)path_;

/*!
 @method
 @abstract     按照用户名排序
 @discussion
 @param        oldArray:老数组
 @result       返回排序后的数组
 */
+ (NSArray *)sortByName:(NSArray *)oldArray;

/*!
 @method
 @abstract     按照创建时间排序
 @discussion
 @param        oldArray:老数组
 @result       返回排序后的数组
 */
+ (NSArray *)sortByCreateDate:(NSArray *)oldArray;

/*!
 @method
 @abstract     将文件夹移动到另一个目录
 @discussion
 @param        oldPath:移动前的目录路径  newPath:需要移动到的路径  folderName:需要移动的文件夹名称  isCopy:表示复制
 @result       返回是否移动成功标志
 */
+ (void)moveFolderWithOldPath:(NSString *)oldPath
                   andNewPath:(NSString *)newPath
                andFolderName:(NSString *)folderName
                      andCopy:(BOOL)isCopy;

/*!
 @method
 @abstract     弹出提示框
 @discussion
 @param        msgTitle:提示框标题  msgBody:提示框信息
 @result       
 */
+ (void)showAlertWithTitle:(NSString *)msgTitle andMsgBody:(NSString *)msgBody;

/*!
 @method
 @abstract     判断某个文件是否已经存在
 @discussion
 @param        fileDirectoryPath:需要判断的文件所在目录  fileName:文件名称
 @result
 */
+ (BOOL)fileIsAleradyExists:(NSString *)fileDirectoryPath andFileName:(NSString *)fileName;

/*!
 @method
 @abstract      通过本地视频存储URL，获取该视频的缩略图
 @discussion    使用AVURLAsset辅助类获取
 @param         vedioPath:本地视频存储URL
 @result        返回该视频的缩略图
 */
+ (UIImage *)getVideoThumbnailImage:(NSString *)vedioPath;

/*!
 @method
 @abstract      通过本地视频存储URL，获取该视频的缩略图
 @discussion    使用MFVideoViewController视频播放类获取
 @param         vedioPath:本地视频存储URL
 @result        返回该视频的缩略图
 */
+ (UIImage *)getVideoImage:(NSString *)vedioPath;

@end
