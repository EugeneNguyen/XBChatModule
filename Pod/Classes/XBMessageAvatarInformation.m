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
#import "JSQMessagesAvatarImageFactory.h"

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
        
        if ([XBMessageAvatarInformation sharedStore][username])
        {
            UIImage *avatar = [JSQMessagesAvatarImageFactory circularAvatarImage:[XBMessageAvatarInformation sharedStore][username] withDiameter:40];
            XBMessageAvatarInformation *message = [[XBMessageAvatarInformation alloc] initWithAvatarImage:avatar highlightedImage:avatar placeholderImage:[JSQMessagesAvatarImageFactory circularAvatarImage:[[XBChatModule sharedInstance] avatarPlaceHolder] withDiameter:40]];
            return message;
        }
        else
        {
            XBMessageAvatarInformation *message = [[XBMessageAvatarInformation alloc] initWithAvatarImage:nil highlightedImage:nil placeholderImage:[JSQMessagesAvatarImageFactory circularAvatarImage:[[XBChatModule sharedInstance] avatarPlaceHolder] withDiameter:40]];
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
        [self setAvatarImage:[JSQMessagesAvatarImageFactory circularAvatarImage:image withDiameter:40]];
        [self setAvatarHighlightedImage:[JSQMessagesAvatarImageFactory circularAvatarImage:image withDiameter:40]];
        [[XBMessageAvatarInformation sharedStore] setValue:[JSQMessagesAvatarImageFactory circularAvatarImage:image withDiameter:40] forKey:self.username];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"XBChatModuleNewAvatar" object:nil];
    }];
}

@end
