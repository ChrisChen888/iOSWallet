//
//  CCWSDKErrorHandle.m
//  CocosBCXWallet
//
//  Created by 邵银岭 on 2019/2/28.
//  Copyright © 2019年 邵银岭. All rights reserved.
//

#import "CCWSDKErrorHandle.h"

@implementation CCWSDKErrorHandle
// 请求错误码处理
+ (NSString *)httpErrorStatusWithCode:(id)errorResponse;
{
    NSString *errorString = @"网络繁忙，请检查您的网络连接";
    int errorCode = [errorResponse[@"code"] intValue];
    switch (errorCode) {
        case 300: // Chain sync error, please check your system clock
            errorString = @"链同步错误，请检查您的系统时钟";
            break;
        case 301: // RPC connection failed. Please check your network
            errorString = @"连接RPC失败，请检查你的网络";
            break;
        case 1:
            errorString = @"操作成功";
            break;
        case 0: // failed
            errorString = @"操作失败";
            break;
        case 101: // Parameter is missing
            errorString = @"参数缺失";
            break;
        case 1011:// Parameter error
            errorString = @"参数错误";
            break;
        case 102: // The network is busy, please check your network connection
            errorString = @"网络繁忙，请检查你的网络连接";
            break;
        case 103:// Please enter the correct account name(/^a-z{4,63}/$)
            errorString = @"请输入正确的账户名";
            break;
        case 104:// XX not found
            errorString = @"XX 不存在";
            break;
        case 105:// wrong password
            errorString = @"密码错误";
            break;
        case 106:// The account is already unlocked
            errorString = @"账户已经处于解锁状态";
            break;
        case 107:// Please import the private key
            errorString = @"请先导入私钥";
            break;
        case 108:// User name or password error (please confirm that your account is registered in account mode, and the account registered in wallet mode cannot be logged in using account mode)
            errorString = @"用户名或密码错误(请确认你的账户是通过账户模式注册的，钱包模式注册的账户不能使用账户模式登录)";
            break;
        case 109:// Please enter the correct private key
            errorString = @"请输入正确的私钥";
            break;
        case 110:// The private key has no account information
            errorString = @"该私钥没有对应的账户信息";
            break;
        case 111:// Please login first
            errorString = @"请先登录";
            break;
        case 112:// Must have owner permission to change the password, please confirm that you imported the ownerPrivateKey
            errorString = @"必须拥有owner权限才可以进行密码修改,请确认你导入的是ownerPrivateKey";
            break;
        case 113:// Please enter the correct original/temporary password
            errorString = @"请输入正确的原始密码/临时密码";
            break;
        case 114:// Account is locked or not logged in.
            errorString = @"帐户被锁定或未登录";
            break;
        case 115:// There is no asset XX on block chain
            errorString = @"区块链上不存在资产 XX";
            break;
        case 116:// Account receivable does not exist
            errorString = @"收款方账户不存在";
            break;
        case 117:// The current asset precision is configured as X ,and the decimal cannot exceed X
            errorString = @"当前资产精度配置为 X ，小数点不能超过 X";
            break;
        case 118:// Encrypt memo failed
            errorString = @"备注加密失败";
            break;
        case 119:// Expiry of the transaction
            errorString = @"交易过期";
            break;
        case 120:// Error fetching account record
            errorString = @"获取帐户记录错误";
            break;
        case 121:// block and transaction information cannot be found
            errorString = @"查询不到相关区块及交易信息";
            break;
        case 122:// Parameter blockOrTXID is incorrect
            errorString = @"参数blockOrTXID不正确";
            break;
        case 123:// Parameter account can not be empty
            errorString = @"参数account不能为空";
            break;
        case 124:// Receivables account name can not be empty
            errorString = @"收款方账户名不能为空";
            break;
        case 125:// Users do not own XX assets
            errorString = @"用户未拥有 XX 资产";
            break;
        case 126://
            errorString = @"";
            break;
        case 127:// No reward available
            errorString = @"没有可领取的奖励";
            break;
        case 128://
            errorString = @"";
            break;
        case 129:// Parameter ‘memo’ can not be empty
            errorString = @"memo不能为空";
            break;
        case 130:// Please enter the correct contract name(/^a-z{4,63}$/)
            errorString = @"请输入正确的合约名称(正则/^a-z{4,63}$/)";
            break;
        case 131:// Parameter ‘worldView’ can not be empty
            errorString = @"世界观名称不能为空";
            break;
        case 132://
            errorString = @"";
            break;
        case 133:// Parameter ‘toAccount’ can not be empty
            errorString = @"toAccount不能为空";
            break;
        case 134://
            errorString = @"";
            break;
        case 135:// Please check parameter data type
            errorString = @"请检查参数数据类型";
            break;
        case 136:// Parameter ‘orderId’ can not be empty
            errorString = @"orderId不能为空";
            break;
        case 137:// Parameter ‘NHAssetHashOrIds’ can not be empty
            errorString = @"NHAssetHashOrIds不能为空";
            break;
        case 138:// Parameter ‘url’ can not be empty
            errorString = @"接入点地址不能为空";
            break;
        case 139:// Node address must start with ws:// or wss://
            errorString = @"节点地址必须以 ws:// 或 wss:// 开头";
            break;
        case 140:// API server node address already exists
            errorString = @"API服务器节点地址已经存在";
            break;
        case 141:// Please check the data in parameter NHAssets
            errorString = @"请检查参数NHAssets中的数据";
            break;
        case 142:// Please check the data type of parameter NHAssets
            errorString = @"请检查参数NHAssets的数据类型";
            break;
        case 143://
            errorString = @"";
            break;
        case 144:// Your current batch creation / deletion / transfer number is X , and batch operations can not exceed X
            errorString = @"您当前批量 创建/删除/转移 NH资产数量为 X ，批量操作数量不能超过 X";
            break;
        case 145:// XX contract not found
            errorString = @"XX 合约不存在";
            break;
        case 146:// The account does not contain information about the contract
            errorString = @"账户没有该合约相关的信息";
            break;
        case 147:// NHAsset do not exist
            errorString = @"非同质资产不存在";
            break;
        case 148:// Request timeout, please try to unlock the account or login the account
            errorString = @"请求超时，请尝试解锁账户或登录账户";
            break;
        case 149:// This wallet has already been imported
            errorString = @"此私钥已导入过钱包";
            break;
        case 150:// Key import error
            errorString = @"导入私钥失败";
            break;
        case 151:// File saving is not supported
            errorString = @"您的浏览器不支持文件保存";
            break;
        case 152:// Invalid backup to download conversion
            errorString = @"无效的备份下载转换";
            break;
        case 153:// Please unlock your wallet first
            errorString = @"请先解锁钱包";
            break;
        case 154:// Please restore your wallet first
            errorString = @"请先恢复你的钱包";
            break;
        case 155:// Your browser may not support wallet file recovery
            errorString = @"浏览器不支持钱包文件恢复";
            break;
        case 156:// The wallet has been imported. Do not repeat import
            errorString = @"该钱包已经导入，请勿重复导入";
            break;
        case 157:// Can’t delete wallet, does not exist in index
            errorString = @"请求超时，请尝试解锁账户或登录账户";
            break;
        case 158:// Imported Wallet core assets can not be XX , and it should be XX
            errorString = @"导入的钱包核心资产不能为 XX ，应为 XX";
            break;
        case 159:// Account exists
            errorString = @"账户已存在";
            break;
        case 160:// You are not the creator of the Asset XX .
            errorString = @"你不是该资产的创建者";
            break;
        case 161:// Orders do not exist
            errorString = @"订单不存在";
            break;
        case 162:// The asset already exists
            errorString = @"资产已存在";
            break;
        case 163:// The wallet already exists. Please try importing the private key
            errorString = @"钱包已经存在，请尝试导入私钥";
            break;
        case 164:// worldViews do not exist
            errorString = @"世界观不存在";
            break;
        case 165:// There is no wallet account information on the chain
            errorString = @"链上没有该钱包账户信息";
            break;
        case 166:// The Wallet Chain ID does not match the current chain configuration information. The chain ID of the wallet is: XX
            errorString = @"该钱包链id与当前链配置信息不匹配，该钱包的链id为： XXX";
            break;
        case 167:// The current contract version ID was not found
            errorString = @"当前合约版本id没有找到 X";
            break;
        case 168:// This subscription does not exist
            errorString = @"当前没有订阅此项";
            break;
        case 169:// Method does not exist
            errorString = @"API方法不存在";
            break;
        case 400001:// Account creation required
            errorString = @"创建账户需符合要求";
            break;
        case 400002:// Creating  free account required
            errorString = @"账户需满足·含有数字";
            break;
        case 400003:// The account already exists
            errorString = @"该账户已存在";
            break;
        case 401001:// No authority
            errorString = @"没有权限";
            break;
        case 401002:// You can't create any more accounts today
            errorString = @"今日你不能再创建账户";
            break;
        case 401003:// No free account today
            errorString = @"今日已经没有免费账户";
            break;
        default:
            
            break;
    }
    CCWLog(@"SDKError:%@",errorString);
    return errorString;
}
@end
