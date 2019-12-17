//
//  BMWavHeader.m
//  BMAudioRecorder
//
//  Created by liuxing8807@126.com on 2019/12/2.
//  Copyright © 2019 liuweizhen. All rights reserved.
//  http://www.skyfox.org/ios-audio-wav-write-header.html

#import "BMWavHeader.h"

@implementation BMWavHeader

- (NSData *)getData {
    Byte header[44];
    
    // fileID 4字节 RIFF
    header[0] = (Byte)'R';
    header[1] = (Byte)'I';
    header[2] = (Byte)'F';
    header[3] = (Byte)'F';
    
    // fileLength
    header[4] = self.fileLength & 0xff;
    header[5] = (self.fileLength >> 8) & 0xff;
    header[6] = (self.fileLength >> 16) & 0xff;
    header[7] = (self.fileLength >> 24) & 0xff;
    
    // wavTag WAVE
    header[8] = (Byte)'W';
    header[9] = (Byte)'A';
    header[10] = (Byte)'V';
    header[11] = (Byte)'E';
    
    // 4字节 fmt , 注fmt后有一个空格
    header[12] = (Byte)'f';
    header[13] = (Byte)'m';
    header[14] = (Byte)'t';
    header[15] = (Byte)' ';
    
    // fmtHeaderLength
    header[16] = self.fmtHeaderLength;
    header[17] = 0;
    header[18] = 0;
    header[19] = 0;
    
    // formatTag
    header[20] = self.formatTag & 0xff;
    header[21] = 0;
    header[22] = self.channels;
    header[23] = 0;
    
    // samplesPerSec 44100
    header[24] = (UInt8)(self.samplesPerSec & 0xff);
    header[25] = (UInt8)((self.samplesPerSec >> 8) & 0xff);
    header[26] = (UInt8)((self.samplesPerSec >> 16) & 0xff);
    header[27] = (UInt8)((self.samplesPerSec >> 24) & 0xff);
    
    // avgBytesPerSec
    header[28] = (UInt8)(self.avgBytesPerSec & 0xff);
    header[29] = (UInt8)((self.avgBytesPerSec >> 8) & 0xff);
    header[30] = (UInt8)((self.avgBytesPerSec >> 16) & 0xff);
    header[31] = (UInt8)((self.avgBytesPerSec >> 24) & 0xff);
    
    // blockAlign
    header[32] = self.blockAlign;
    header[33] = 0;
    
    // bitsPerSample
    header[34] = self.bitsPerSample;
    header[35] = 0;
    
    // dataHeaderID: data
    header[36] = 'd';
    header[37] = 'a';
    header[38] = 't';
    header[39] = 'a';
    
    header[40] = (UInt8)(self.dataHeaderLength & 0xff);
    header[41] = (UInt8)((self.dataHeaderLength >> 8) & 0xff);
    header[42] = (UInt8)((self.dataHeaderLength >> 16) & 0xff);
    header[43] = (UInt8)((self.dataHeaderLength >> 24) & 0xff);
    
    NSData *data = [NSData dataWithBytes:header length:44];
    
    return data;
}

@end
