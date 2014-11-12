//
//  XBMessageAvatarInformation.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 11/12/14.
//
//

#import <Foundation/Foundation.h>
#import "JSQMessagesAvatarImage.h"

@interface XBMessageAvatarInformation : JSQMessagesAvatarImage

@property (nonatomic, retain) NSString *username;

+ (NSMutableDictionary *)sharedStore;

+ (XBMessageAvatarInformation *)avatarObjectForUsername:(NSString *)username;

- (void)loadPath:(NSString *)path;

@end
