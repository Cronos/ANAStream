//
//  ANAPeersController.m
//  ANAStream
//
//  Created by Voropaev Vitali on 12.02.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import "ANAPeersController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "UITableView+ANAExtensions.h"
#import "ANAViewStreamController.h"

@interface ANAPeersController () <MCNearbyServiceBrowserDelegate>
@property(nonatomic, strong) MCNearbyServiceBrowser *browser;
@property(nonatomic, strong) NSMutableArray <MCPeerID *> *peers;

@end

@implementation ANAPeersController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.peers = @[].mutableCopy;
    
    MCPeerID *peerId = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:peerId serviceType:@"multipeer-video"];
    self.browser.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.peers removeAllObjects];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.browser startBrowsingForPeers];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.browser stopBrowsingForPeers];
}

#pragma mark -
#pragma mark UITableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.peers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ANAPeersCellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ANAPeersCellIdentifier"];
    }
    
    cell.textLabel.text =  self.peers[indexPath.row].displayName;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ANAViewStreamController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ANAViewStreamController"];
    MCSession *session = [self sessionWithPeer:self.browser.myPeerID];
    [self.browser invitePeer:self.peers[indexPath.row] toSession:session withContext:nil timeout:0.0];
    controller.session = session;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma mark MCNearbyServiceBrowserDelegate methods

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    NSInteger index = [self.peers indexOfObject:peerID];
    [self.peers removeObject:peerID];
    [self.tableView deleteCellAtRow:index section:0];
}

- (void) browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    [self.peers addObject:peerID];
    [self.tableView insertCellAtRow:self.peers.count-1 section:0];
}

#pragma mark -
#pragma mark Private methods

- (MCSession *)sessionWithPeer:(MCPeerID *)peer {
    MCSession *session = [[MCSession alloc] initWithPeer:peer securityIdentity:nil encryptionPreference:MCEncryptionNone];

    return session;
}

@end
