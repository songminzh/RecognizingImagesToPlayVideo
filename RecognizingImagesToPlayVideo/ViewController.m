//
//  ViewController.m
//  RecognizingImagesToPlayVideo
//
//  Created by Murphy Zheng on 2018/11/20.
//  Copyright © 2018 mulberry. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<ARSCNViewDelegate>
@property (weak, nonatomic) IBOutlet ARSCNView *sceneView;

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation ViewController

- (AVPlayer *)player {
    if (!_player) {
        AVPlayerItem *playerItem = [self getPlayerItem:0];
        _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    }
    return _player;
}

- (AVPlayerItem *)getPlayerItem:(int)videoIndex {
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"videoName" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    return playerItem;
}

#pragma mark  - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sceneView.delegate = self;
    SCNScene *scene = [SCNScene new];
    self.sceneView.scene = scene;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
    configuration.detectionImages = [ARReferenceImage referenceImagesInGroupNamed:@"AR Resources" bundle:nil];
    [self.sceneView.session runWithConfiguration:configuration options:ARSessionRunOptionResetTracking | ARSessionRunOptionRemoveExistingAnchors];
    [self.sceneView.session runWithConfiguration:configuration];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.sceneView.session pause];
}

#pragma mark - ARSCNViewDelegate

- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    ARImageAnchor *imageAnchor = (ARImageAnchor *)anchor;
    
    // 获取参考图片对象
    ARReferenceImage *referenceImage = imageAnchor.referenceImage;
    // 根据图片对象播放对应视频
    if (referenceImage.name) {
        NSString *fileName = referenceImage.name;
        [self setFileForPlayerWithFileName:fileName];
        
        SCNNode *tempNode = [SCNNode new];
        CGFloat imageWidth = referenceImage.physicalSize.width;
        CGFloat imageHeight = referenceImage.physicalSize.height;
        
        SCNBox *bgBox = [SCNBox boxWithWidth:imageWidth height:imageHeight length:0.01 chamferRadius:0];
        tempNode.geometry = bgBox;
        tempNode.eulerAngles = SCNVector3Make(-M_PI/2.0, 0.0, 0.0);
        tempNode.opacity = 1.0;
        
        SCNMaterial *material = [[SCNMaterial alloc] init];
        material.diffuse.contents = self.player;
        tempNode.geometry.materials = @[material];
        [self.player play];
        
        [node addChildNode:tempNode];
    }
}

- (void)setFileForPlayerWithFileName:(NSString *)fileName {
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:fileName ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
}


@end
