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
    long totalDataLen = self.dataHeaderLength + (44 - 8);
    UInt32 byteRate = self.blockAlign * self.samplesPerSec;
    Byte header[44];
    header[0] = 'R';  // RIFF/WAVE header
    header[1] = 'I';
    header[2] = 'F';
    header[3] = 'F';
    header[4] = (Byte) (totalDataLen & 0xff);  //file-size (equals file-size - 8)
    header[5] = (Byte) ((totalDataLen >> 8) & 0xff);
    header[6] = (Byte) ((totalDataLen >> 16) & 0xff);
    header[7] = (Byte) ((totalDataLen >> 24) & 0xff);
    header[8] = 'W';  // Mark it as type "WAVE"
    header[9] = 'A';
    header[10] = 'V';
    header[11] = 'E';
    header[12] = 'f';  // Mark the format section 'fmt ' chunk
    header[13] = 'm';
    header[14] = 't';
    header[15] = ' ';
    header[16] = 16;   // 4 bytes: size of 'fmt ' chunk, Length of format data.  Always 16
    header[17] = 0;
    header[18] = 0;
    header[19] = 0;
    header[20] = 1;  // format = 1 ,Wave type PCM
    header[21] = 0;
    header[22] = (Byte)self.channels;  // channels
    header[23] = 0;
    header[24] = (Byte) (self.samplesPerSec & 0xff);
    header[25] = (Byte) ((self.samplesPerSec >> 8) & 0xff);
    header[26] = (Byte) ((self.samplesPerSec >> 16) & 0xff);
    header[27] = (Byte) ((self.samplesPerSec >> 24) & 0xff);
    header[28] = (Byte) (byteRate & 0xff);
    header[29] = (Byte) ((byteRate >> 8) & 0xff);
    header[30] = (Byte) ((byteRate >> 16) & 0xff);
    header[31] = (Byte) ((byteRate >> 24) & 0xff);
    header[32] = (Byte) (2 * 16 / 8); // block align
    header[33] = 0;
    header[34] = 16; // bits per sample
    header[35] = 0;
    header[36] = 'd'; //"data" marker
    header[37] = 'a';
    header[38] = 't';
    header[39] = 'a';
    header[40] = (Byte)(self.dataHeaderLength & 0xff);  //data-size (equals file-size - 44).
    header[41] = (Byte)((self.dataHeaderLength >> 8) & 0xff);
    header[42] = (Byte)((self.dataHeaderLength >> 16) & 0xff);
    header[43] = (Byte)((self.dataHeaderLength >> 24) & 0xff);
    return [[NSData alloc] initWithBytes:header length:44];
}

@end
