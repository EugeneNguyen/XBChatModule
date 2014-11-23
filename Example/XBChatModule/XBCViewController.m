//
//  XBCViewController.m
//  XBChatModule
//
//  Created by eugenenguyen on 11/05/2014.
//  Copyright (c) 2014 eugenenguyen. All rights reserved.
//

#import "XBCViewController.h"

@interface XBCViewController ()

@end

@implementation XBCViewController

- (void)viewDidLoad
{
    self.jidStr = @"ka.ra.5602@chat.facebook.com";
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"XBChatModuleNewAvatar" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadData
{
    [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
