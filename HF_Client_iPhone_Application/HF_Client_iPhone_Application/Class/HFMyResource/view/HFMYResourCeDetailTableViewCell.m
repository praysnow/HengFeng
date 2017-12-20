//
//  HFMYResourCeDetailTableViewCell.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 18/12/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import "HFMYResourCeDetailTableViewCell.h"

@implementation HFMYResourCeDetailTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setDictionary:(NSDictionary *)dictionary
{
    _dictionary = dictionary;
    self.textLabel.text = [dictionary objectForKey: @"DxaZj_Title"];
    NSString *test = [dictionary objectForKey: @"typeName"];
    if ([test isEqualToString: DAOXUEAN_BeforeMicrolecture] || [test isEqualToString: DAOXUEAN_InClassMicrolecture] || [test isEqualToString: DAOXUEAN_AfterClassMicrolecture] || [test isEqualToString: DAOXUEAN_InClassExercise] || [test isEqualToString: DAOXUEAN_BeforeClassExercise] || [test isEqualToString: DAOXUEAN_ImageHomework] || [test isEqualToString: DAOXUEAN_StandardTest] || [test isEqualToString: DAOXUEAN_Microlecture]) {
        self.userInteractionEnabled = YES;
        self.textLabel.textColor = UICOLOR_RGB(0xff000000);
    } else {
        self.textLabel.textColor = UICOLOR_RGB(0xffe0e0e0);
        self.userInteractionEnabled = NO;
    }
}

@end
