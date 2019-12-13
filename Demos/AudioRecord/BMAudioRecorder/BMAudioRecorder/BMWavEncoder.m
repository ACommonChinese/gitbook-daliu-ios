//
//  BMWavEncoder.m
//  BMAudioRecorder
//
//  Created by liuxing8807@126.com on 2019/12/2.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import "BMWavEncoder.h"
#import "BMWavHeader.h"

@interface BMWavEncoder ()

@property (nonatomic, assign) int SAMPLE_RATE;
@property (nonatomic, assign) UInt16 CHANNEL_COUNT;
@property (nonatomic, copy) NSString *srcFilePath;

@end

@implementation BMWavEncoder

- (instancetype)initWithFilePath:(NSString *)filePath {
    if (self = [super init]) {
        self.SAMPLE_RATE = 44100;
        self.CHANNEL_COUNT = 1; // 2时说话很快
        self.srcFilePath = filePath;
    }
    
    return self;
}

- (void)encode {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:self.srcFilePath]) {
        [NSString stringWithFormat:@"srcPath file not exitst error: %@", self.srcFilePath];
        return ;
    }
    NSError *error = nil;
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:self.srcFilePath error:&error];
    if (!attributes || error) {
        NSLog(@"get file attribute error %@", [NSString stringWithFormat:@"%@", error]);
        return;
    }
    int totalSize = (int)[attributes fileSize];
    BMWavHeader *header = [[BMWavHeader alloc] init];
    header.fileLength = totalSize + (44 - 8); // totalDataLength

    NSData *headerData = WriteWavFileHeader(totalSize, totalSize + (44 - 8), _SAMPLE_RATE, _CHANNEL_COUNT, header.blockAlign * header.samplesPerSec);
    if (headerData.length != 44) {
        return;
    }
    NSString *destPath = [[self.srcFilePath stringByDeletingPathExtension] stringByAppendingString:@".wav"];
    
    [fileManager createFileAtPath:destPath contents:nil attributes:nil];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:destPath];
    [fileHandle writeData:headerData];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[NSData dataWithContentsOfFile:self.srcFilePath]];
    [fileHandle closeFile];
    NSLog(@"src: %@", self.srcFilePath);
    NSLog(@"dest: %@", destPath);
}

NSData* WriteWavFileHeader(long totalAudioLen, long totalDataLen, long longSampleRate,int channels, long byteRate)
{
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
    header[22] = (Byte) channels;  // channels
    header[23] = 0;
    header[24] = (Byte) (longSampleRate & 0xff);
    header[25] = (Byte) ((longSampleRate >> 8) & 0xff);
    header[26] = (Byte) ((longSampleRate >> 16) & 0xff);
    header[27] = (Byte) ((longSampleRate >> 24) & 0xff);
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
    header[40] = (Byte) (totalAudioLen & 0xff);  //data-size (equals file-size - 44).
    header[41] = (Byte) ((totalAudioLen >> 8) & 0xff);
    header[42] = (Byte) ((totalAudioLen >> 16) & 0xff);
    header[43] = (Byte) ((totalAudioLen >> 24) & 0xff);
    return [[NSData alloc] initWithBytes:header length:44];;
}

@end

