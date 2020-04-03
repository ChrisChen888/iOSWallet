//
//  CCWDappModel.h
//  CocosWallet
//
//  Created by 邵银岭 on 2018/11/15.
//  Copyright © 2018年 CCW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCWDappModel : NSObject
/** 图片 */
@property (nonatomic, copy) NSString *imageUrl;
/** 英文标题 */
@property (nonatomic, copy) NSString *enTitle;
/** 英文标题 */
@property (nonatomic, copy) NSString *title;
/** 描述 */
@property (nonatomic, copy) NSString *dec;
/** 英文描述 */
@property (nonatomic, copy) NSString *enDec;
/** 链接 */
@property (nonatomic, copy) NSString *linkUrl;

/*************************** 收藏 ***************************/
/** 图片 */
@property (nonatomic, copy) NSString *logo;

@end
