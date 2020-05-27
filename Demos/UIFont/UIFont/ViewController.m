//
//  ViewController.m
//  UIFont
//
//  Created by 刘威振 on 2020/5/14.
//  Copyright © 2020 刘威振. All rights reserved.
//

#import "ViewController.h"
#import "UIFont+Addition.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textLabel.font = [UIFont systemFontOfSize:38];
}

- (IBAction)printAllFont:(id)sender {
    NSArray *familys = [UIFont familyNames];
    NSMutableString *fontFamilyNames = [NSMutableString string];
    for (int i = 0; i < familys.count; i++) {
        NSString *familyName = [familys objectAtIndex:i];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        [fontFamilyNames appendFormat:@"\n\n==== %d %@ ====\n", i, familyName];
        for (int i = 0; i < fontNames.count; i++) {
            [fontFamilyNames appendFormat:@"    %@\n", fontNames[i]];
        }
    }
    NSLog(@"%@", fontFamilyNames);
}

/**
注：自定义字体需要在Info.plist中添加字体声明，比如：
<key>UIAppFonts</key>
<array>
    <string>DIN-Medium.otf</string>
    <string>DIN-Regular.otf</string>
    <string>DIN-Light.otf</string>
    <string>Roboto-Light.ttf</string>
    <string>Roboto-Regular.ttf</string>
</array>
*/

- (IBAction)useCustomFont:(id)sender {
    UIFont *font = [UIFont fontWithName:@"Roboto-Light" size:38];; // [UIFont fontWithName:@"Roboto-Light" size:38];
    if (font == nil) {
        NSLog(@"No this font!");
    }
    self.textLabel.font = font;
    // [UIFont fontWithName:@"DIN-Light" size:fontSize]
    // [UIFont fontWithName:@"DIN-Regular" size:fontSize]
}

- (IBAction)dinMedium:(id)sender {
    self.textLabel.font = [UIFont dl_dinMedium:30];
}

- (IBAction)dinRegular:(id)sender {
    self.textLabel.font = [UIFont dl_dinRegular:30];
}

- (IBAction)dinLight:(id)sender {
    self.textLabel.font = [UIFont dl_dinLight:30];
}

- (IBAction)robotoRegular:(id)sender {
    self.textLabel.font = [UIFont dl_robotoRegular:30];
}

- (IBAction)robotoLight:(id)sender {
    self.textLabel.font = [UIFont dl_robotoLight:30];
}

- (IBAction)sourceHanSerifSCHeavy:(id)sender {
    self.textLabel.font = [UIFont dl_sourceHanSerifSCHeavy:30];
}

@end
