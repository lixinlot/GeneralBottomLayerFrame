//
//  LXDownLoadModel.m
//  GeneralBottomLayerFrame
//
//  Created by jimmy on 2018/11/28.
//  Copyright © 2018年 jimmy. All rights reserved.
//

#import "LXDownLoadModel.h"

@implementation LXDownLoadModel

- (void)openOutputStream {
    
    if (_outputStream) {
        [_outputStream open];
    }
}

- (void)closeOutputStream {
    
    if (_outputStream) {
        if (_outputStream.streamStatus > NSStreamStatusNotOpen && _outputStream.streamStatus < NSStreamStatusClosed) {
            [_outputStream close];
        }
        _outputStream = nil;
    }
}

@end
