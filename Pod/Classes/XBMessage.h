//
//  XBMessage.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 11/5/14.
//
//

#import <Foundation/Foundation.h>
#import "JSQMessageData.h"

@interface XBMessage : NSObject <JSQMessageData>

@property (nonatomic, retain) NSString *senderId;
@property (nonatomic, retain) NSString *senderDisplayName;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, assign) BOOL isMediaMessage;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) id <JSQMessageMediaData> media;
@property (nonatomic, assign) BOOL isOutgoing;

@end
