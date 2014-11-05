//
//  XBChatModule.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 10/26/14.
//
//

#import <Foundation/Foundation.h>

#import "XMPPReconnect.h"

#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"

#import "XMPPvCardTempModule.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"

#import "XMPPCapabilities.h"
#import "XMPPCapabilitiesCoreDataStorage.h"

#import "XMPPMUC.h"
#import "XMPPRoomCoreDataStorage.h"

#import "XMPPMessageArchivingCoreDataStorage.h"

extern NSString *const XBChatEventConnected;
extern NSString *const XBChatEventReceiveMessage;

@interface XBChatModule : NSObject
{
    XMPPStream *xmppStream;
    XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
    XMPPvCardTempModule *xmppvCardTempModule;
    XMPPvCardAvatarModule *xmppvCardAvatarModule;
    XMPPCapabilities *xmppCapabilities;
    XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingStorage;
    XMPPMessageArchiving *xmppMessageArchivingModule;

    NSString *password;

    BOOL customCertEvaluation;

    BOOL isXmppConnected;
}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *host;

+ (id)sharedInstance;

- (BOOL)connect;
- (void)disconnect;

- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;
- (void)sendMessage:(NSString *)message toID:(NSString *)jid;

@end
