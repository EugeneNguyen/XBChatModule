//
//  XBMessageViewController.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 11/5/14.
//
//

#import "XBMessageViewController.h"
#import "XBChatModule.h"
#import "XBMessage.h"
#import "JSQMessagesBubbleImageFactory.h"
#import "JSQMessagesTimestampFormatter.h"

@interface XBMessageViewController () <NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *fetchedResultsController;
    NSMutableArray *items;
}

@end

@implementation XBMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.jidStr = @"hoat@sflashcard.com";
    self.title = @"JSQMessages";
    
    /**
     *  You MUST set your senderId and display name
     */
    self.senderId = @"admin@sflashcard.com";
    self.senderDisplayName = @"Nguyen Xuan Binh";
    
    
    /**
     *  Load up our fake data for the demo
     */
//    self.demoData = [[DemoModelData alloc] init];
    
    
    /**
     *  You can set custom avatar sizes
     */
//    if (![NSUserDefaults incomingAvatarSetting]) {
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
//    }
    
//    if (![NSUserDefaults outgoingAvatarSetting]) {
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
//    }
    
//    self.showLoadEarlierMessagesHeader = YES;
    [self loadDataToTable];
    [self fetchData];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage jsq_defaultTypingIndicatorImage]
//                                                                              style:UIBarButtonItemStyleBordered
//                                                                             target:self
//                                                                             action:@selector(receiveMessagePressed:)];
}

- (void)fetchData
{
    NSXMLElement *iQ = [NSXMLElement elementWithName:@"iq"];
    [iQ addAttributeWithName:@"type" stringValue:@"get"];
    [iQ addAttributeWithName:@"id" stringValue:@"page1"];
    
    NSXMLElement *retrieve = [NSXMLElement elementWithName:@"retrieve"];
    [retrieve addAttributeWithName:@"xmlns" stringValue:@"urn:xmpp:archive:data"];
    [retrieve addAttributeWithName:@"with" stringValue:self.jidStr];
    [retrieve addAttributeWithName:@"start" stringValue:@"1469-07-21T02:56:15Z"];
    
    NSXMLElement *set = [NSXMLElement elementWithName:@"set"];
    [set addAttributeWithName:@"xmlns" stringValue:@"http://jabber.org/protocol/rsm"];
    NSXMLElement *max = [NSXMLElement elementWithName:@"max"];
    max.stringValue = @"100";
    [set addChild:max];
    
    [retrieve addChild:set];
    [iQ addChild:retrieve];
    
    [[[XBChatModule sharedInstance] xmppStream] sendElement:iQ];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSFetchedResultsController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController == nil)
    {
        XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                  inManagedObjectContext:moc];
        
        NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
        
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, nil];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        [fetchRequest setSortDescriptors:sortDescriptors];
        [fetchRequest setFetchBatchSize:10];
        
        NSPredicate *p1 = [NSPredicate predicateWithFormat:@"bareJidStr=%@" argumentArray:@[self.jidStr]];
        [fetchRequest setPredicate:p1];
        
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
        [fetchedResultsController setDelegate:self];
        
        NSError *error = nil;
        if (![fetchedResultsController performFetch:&error])
        {
            NSLog(@"Error performing fetch: %@", error);
        }
        
    }
    return fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self loadDataToTable];
}

- (void)loadDataToTable
{
    items = [@[] mutableCopy];
    for (int sectionIndex = 0; sectionIndex < [[[self fetchedResultsController] sections] count]; sectionIndex ++)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:sectionIndex];
        for (int i = 0; i < [sectionInfo numberOfObjects]; i ++)
        {
            XMPPMessageArchiving_Message_CoreDataObject *item = [[self fetchedResultsController] objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:sectionIndex]];
            XBMessage *message = [[XBMessage alloc] init];
            message.text = item.body;
            message.date = item.timestamp;
            message.senderId = item.bareJidStr;
            message.isOutgoing = item.isOutgoing;
            message.senderDisplayName = item.bareJid.full;
            [items addObject:message];
        }
    }
    [self finishReceivingMessage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
}

#pragma mark - Actions

//- (void)receiveMessagePressed:(UIBarButtonItem *)sender
//{
//    /**
//     *  DEMO ONLY
//     *
//     *  The following is simply to simulate received messages for the demo.
//     *  Do not actually do this.
//     */
//    
//    
//    /**
//     *  Show the typing indicator to be shown
//     */
//    self.showTypingIndicator = !self.showTypingIndicator;
//    
//    /**
//     *  Scroll to actually view the indicator
//     */
//    [self scrollToBottomAnimated:YES];
//    
//    /**
//     *  Copy last sent message, this will be the new "received" message
//     */
//    JSQMessage *copyMessage = [[self.demoData.messages lastObject] copy];
//    
//    if (!copyMessage) {
//        copyMessage = [JSQTextMessage messageWithSenderId:kJSQDemoAvatarIdJobs
//                                              displayName:kJSQDemoAvatarDisplayNameJobs
//                                                     text:@"First received!"];
//    }
//    
//    /**
//     *  Allow typing indicator to show
//     */
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        NSMutableArray *userIds = [[self.demoData.users allKeys] mutableCopy];
//        [userIds removeObject:self.senderId];
//        NSString *randomUserId = userIds[arc4random_uniform((int)[userIds count])];
//        
//        JSQMessage *newMessage = nil;
//        id<JSQMessageMediaData> newMediaData = nil;
//        id newMediaAttachmentCopy = nil;
//        
//        if ([copyMessage isKindOfClass:[JSQMediaMessage class]]) {
//            /**
//             *  Last message was a media message
//             */
//            id<JSQMessageMediaData> copyMediaData = copyMessage.media;
//            
//            if ([copyMediaData isKindOfClass:[JSQPhotoMediaItem class]]) {
//                JSQPhotoMediaItem *photoItemCopy = [((JSQPhotoMediaItem *)copyMediaData) copy];
//                photoItemCopy.appliesMediaViewMaskAsOutgoing = NO;
//                newMediaAttachmentCopy = [UIImage imageWithCGImage:photoItemCopy.image.CGImage];
//                
//                /**
//                 *  Set image to nil to simulate "downloading" the image
//                 *  and show the placeholder view
//                 */
//                photoItemCopy.image = nil;
//                
//                newMediaData = photoItemCopy;
//            }
//            else if ([copyMediaData isKindOfClass:[JSQLocationMediaItem class]]) {
//                JSQLocationMediaItem *locationItemCopy = [((JSQLocationMediaItem *)copyMediaData) copy];
//                locationItemCopy.appliesMediaViewMaskAsOutgoing = NO;
//                newMediaAttachmentCopy = [locationItemCopy.location copy];
//                
//                /**
//                 *  Set location to nil to simulate "downloading" the location data
//                 */
//                locationItemCopy.location = nil;
//                
//                newMediaData = locationItemCopy;
//            }
//            else if ([copyMediaData isKindOfClass:[JSQVideoMediaItem class]]) {
//                JSQVideoMediaItem *videoItemCopy = [((JSQVideoMediaItem *)copyMediaData) copy];
//                videoItemCopy.appliesMediaViewMaskAsOutgoing = NO;
//                newMediaAttachmentCopy = [videoItemCopy.fileURL copy];
//                
//                /**
//                 *  Reset video item to simulate "downloading" the video
//                 */
//                videoItemCopy.fileURL = nil;
//                videoItemCopy.isReadyToPlay = NO;
//                
//                newMediaData = videoItemCopy;
//            }
//            else {
//                NSLog(@"%s error: unrecognized media item", __PRETTY_FUNCTION__);
//            }
//            
//            newMessage = [JSQMediaMessage messageWithSenderId:randomUserId
//                                                  displayName:self.demoData.users[randomUserId]
//                                                        media:newMediaData];
//        }
//        else {
//            /**
//             *  Last message was a text message
//             */
//            newMessage = [JSQTextMessage messageWithSenderId:randomUserId
//                                                 displayName:self.demoData.users[randomUserId]
//                                                        text:copyMessage.text];
//        }
//        
//        /**
//         *  Upon receiving a message, you should:
//         *
//         *  1. Play sound (optional)
//         *  2. Add new id<JSQMessageData> object to your data source
//         *  3. Call `finishReceivingMessage`
//         */
//        [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
//        [self.demoData.messages addObject:newMessage];
//        [self finishReceivingMessage];
//        
//        
//        if ([newMessage isKindOfClass:[JSQMediaMessage class]]) {
//            /**
//             *  Simulate "downloading" media
//             */
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                /**
//                 *  Media is "finished downloading", re-display visible cells
//                 *
//                 *  If media cell is not visible, the next time it is dequeued the view controller will display its new attachment data
//                 *
//                 *  Reload the specific item, or simply call `reloadData`
//                 */
//                
//                if ([newMediaData isKindOfClass:[JSQPhotoMediaItem class]]) {
//                    ((JSQPhotoMediaItem *)newMediaData).image = newMediaAttachmentCopy;
//                    [self.collectionView reloadData];
//                }
//                else if ([newMediaData isKindOfClass:[JSQLocationMediaItem class]]) {
//                    [((JSQLocationMediaItem *)newMediaData)setLocation:newMediaAttachmentCopy withCompletionHandler:^{
//                        [self.collectionView reloadData];
//                    }];
//                }
//                else if ([newMediaData isKindOfClass:[JSQVideoMediaItem class]]) {
//                    ((JSQVideoMediaItem *)newMediaData).fileURL = newMediaAttachmentCopy;
//                    ((JSQVideoMediaItem *)newMediaData).isReadyToPlay = YES;
//                    [self.collectionView reloadData];
//                }
//                else {
//                    NSLog(@"%s error: unrecognized media item", __PRETTY_FUNCTION__);
//                }
//                
//            });
//        }
//        
//    });
//}

//- (void)closePressed:(UIBarButtonItem *)sender
//{
//    [self.delegateModal didDismissJSQDemoViewController:self];
//}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    [[XBChatModule sharedInstance] sendMessage:text toID:self.jidStr];
    [self finishSendingMessage];
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Media messages"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Send photo", @"Send location", @"Send video", nil];
    
    [sheet showFromToolbar:self.inputToolbar];
}

//- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == actionSheet.cancelButtonIndex) {
//        return;
//    }
//    
//    switch (buttonIndex) {
//        case 0:
//            [self.demoData addPhotoMediaMessage];
//            break;
//            
//        case 1:
//        {
//            __weak UICollectionView *weakView = self.collectionView;
//            
//            [self.demoData addLocationMediaMessageCompletion:^{
//                [weakView reloadData];
//            }];
//        }
//            break;
//            
//        case 2:
//            [self.demoData addVideoMediaMessage];
//            break;
//    }
//    
//    [JSQSystemSoundPlayer jsq_playMessageSentSound];
//    [self finishSendingMessage];
//}

#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return items[indexPath.row];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XBMessage *message = items[indexPath.row];
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    if (message.isOutgoing) {
        return [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor colorWithRed:207.0f/255.0f green:238.0f/255.0f blue:249.0f/255.0f alpha:1]];
    }
    
    return [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor colorWithRed:207.0f/255.0f green:238.0f/255.0f blue:249.0f/255.0f alpha:1]];
}

//- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    /**
//     *  Return `nil` here if you do not want avatars.
//     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
//     *
//     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
//     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
//     *
//     *  It is possible to have only outgoing avatars or only incoming avatars, too.
//     */
//    
//    /**
//     *  Return your previously created avatar image data objects.
//     *
//     *  Note: these the avatars will be sized according to these values:
//     *
//     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
//     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
//     *
//     *  Override the defaults in `viewDidLoad`
//     */
//    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
//    
//    if ([message.senderId isEqualToString:self.senderId]) {
//        if (![NSUserDefaults outgoingAvatarSetting]) {
//            return nil;
//        }
//    }
//    else {
//        if (![NSUserDefaults incomingAvatarSetting]) {
//            return nil;
//        }
//    }
//    
//    
//    return [self.demoData.avatars objectForKey:message.senderId];
//}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item % 3 == 0) {
        XBMessage *message = items[indexPath.row];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    XBMessage *message = items[indexPath.row];
    
    /**
     *  iOS7-style sender name labels
     */
    if (!message.isOutgoing) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        XBMessage *previousMessage = items[indexPath.item - 1];
        if (!previousMessage.isOutgoing) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [items count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    XBMessage *msg = items[indexPath.row];
    
    if ([msg isKindOfClass:[XBMessage class]]) {
        
        cell.textView.textColor = [UIColor blackColor];
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}


#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    XBMessage *currentMessage = items[indexPath.row];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        XBMessage *previousMessage = items[indexPath.row - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

@end
