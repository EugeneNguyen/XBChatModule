//
//  XBMessageViewController.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 11/5/14.
//
//

#import "JSQMessagesViewController.h"
#import "JSQMessage.h"

@interface XBMessageViewController : JSQMessagesViewController

@property (nonatomic, retain) NSString *jidStr;
@property (nonatomic, retain) NSMutableArray *avatarInformation;

@end
