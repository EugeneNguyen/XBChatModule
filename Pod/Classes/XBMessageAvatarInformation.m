//
//  XBMessageAvatarInformation.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 11/12/14.
//
//

#import "XBMessageAvatarInformation.h"
#import "SDWebImageDownloader.h"
#import "XBChatModule.h"
#import "SDWebImageManager.h"

static NSMutableDictionary *__sharedStoreAvatar = nil;

@implementation XBMessageAvatarInformation
@synthesize username;

+ (NSMutableDictionary *)sharedStore
{
    if (!__sharedStoreAvatar)
    {
        __sharedStoreAvatar = [@{} mutableCopy];
    }
    return __sharedStoreAvatar;
}

+ (XBMessageAvatarInformation *)avatarObjectForUsername:(NSString *)username
{
    if ([[XBChatModule sharedInstance] avatarFormat])
    {
        UIImage *avatar = [XBMessageAvatarInformation sharedStore][username];
        if (avatar)
        {
            XBMessageAvatarInformation *message = [[XBMessageAvatarInformation alloc] initWithAvatarImage:avatar highlightedImage:avatar placeholderImage:[[XBChatModule sharedInstance] avatarPlaceHolder]];
            return message;
        }
        else
        {
            XBMessageAvatarInformation *message = [[XBMessageAvatarInformation alloc] initWithAvatarImage:nil highlightedImage:nil placeholderImage:[[XBChatModule sharedInstance] avatarPlaceHolder]];
            NSString *path = [NSString stringWithFormat:[[XBChatModule sharedInstance] avatarFormat], username];
            [message loadPath:path];
            message.username = username;
            return message;
        }
    }
    return nil;
}

- (void)loadPath:(NSString *)path
{
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:path] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        [self setAvatarImage:image];
        [self setAvatarHighlightedImage:image];
        [[XBMessageAvatarInformation sharedStore] setValue:image forKey:self.username];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"XBChatModuleNewAvatar" object:nil];
    }];
}

@end
