//
//  GertrudeMyScene.m
//  Gertrude
//
//  Created by Nicholas Barr on 2/12/14.
//  Copyright (c) 2014 Nicholas Barr. All rights reserved.
//

#import "GertrudeMyScene.h"

@interface GertrudeMyScene()

@property (nonatomic) CGFloat timeSinceMidnightInSeconds;

@end

@implementation GertrudeMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        //first found out what time it is
        [self getTheTime];
        
        //convert time since midnight into hours
        float hoursSinceMidnight = _timeSinceMidnightInSeconds/3600;
        
        //the range of hoursSinceMidnight is 0 (12a) to 23.99 (11:59p).
        // 8 is 8a, peak morning. 20 is 8p, peak evening
        
        
        //debug hoursSinceMidnight here:
        hoursSinceMidnight = 20;
        
        //we'll use these to change the background color
        CGFloat red;
        CGFloat green;
        CGFloat blue;
        CGFloat alpha;
        
        //we'll use this to change the alpha of labels depending on whether it's closer to morning or evening. this is janky math to make sure it works right :|
        
        if (hoursSinceMidnight <= 20){
            alpha = abs(8-hoursSinceMidnight)*8.3/100;
        }
        else {
            alpha = abs(16-hoursSinceMidnight)*8.3/100;
        }
        
        
        // current values at various times.
        // red at 6p (255 0 0 )
        // purple and darker into 12 a (50 0 50)
        // very light and blue into 6a (180 230 250)
        // deeper blue into 12p (80 0 255)
        // back to red spanning purple (255 0 0)
        
        
    
        //logic to change the color over time
        
        if (hoursSinceMidnight >= 18 && hoursSinceMidnight < 24) {
            //255 0 0 --> 50 0 50
            float redCoefficient = 33.3;
            float hoursAfterMorningRed = (hoursSinceMidnight-18)*redCoefficient;
            red = 255 - hoursAfterMorningRed;
            //blue max 50
            float blueCoefficient = 8.3;
            float hoursAfterMorningBlue = (hoursSinceMidnight-18)*blueCoefficient;
            blue = hoursAfterMorningBlue;
            
            UIColor *lateEvening = [UIColor colorWithRed:red/255 green:0 blue:blue/255 alpha:1];
            self.backgroundColor = lateEvening;

        }
        else if (hoursSinceMidnight >= 0 && hoursSinceMidnight < 6) {
            //50 0 50 --> 180 230 250
            float redCoefficient = 21.6;
            //red min 50 max 180
            red = 50 + hoursSinceMidnight*redCoefficient;
            //green min 0 max 230
            float greenCoefficient = 38.3;
            green = 0 + hoursSinceMidnight*greenCoefficient;
            //blue min 50 max 250
            float blueCoefficient = 33.3;
            blue = 50 + hoursSinceMidnight*blueCoefficient;
            
            UIColor *earlyMorning = [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
            self.backgroundColor = earlyMorning;
            
        }
        else if (hoursSinceMidnight >= 6 && hoursSinceMidnight < 12) {
            // 180 230 250 --> 80 0 255
        
            //max red 180, min red 80
            float redCoefficient = 16.6;
            red = 180 - (hoursSinceMidnight-6)*redCoefficient;
            //green min 0 max 230
            float greenCoefficient = 38.3;
            green = 230 - (hoursSinceMidnight-6)*greenCoefficient;
            //blue min 50 max 250
            float blueCoefficient = .83;
            blue = 250 + (hoursSinceMidnight-6)*blueCoefficient;
            
            UIColor *morning = [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
            self.backgroundColor = morning;
            
        }
        else { //if (hoursSinceMidnight >= 12 && hoursSinceMidnight < 18)
            //80 0 250 --> // 255 0 0
            float redCoefficient = 29.1;
            red = 80 + (hoursSinceMidnight-12)*redCoefficient;
            //green min 0 max 230
            float greenCoefficient = 38.3;
            green = 230 - (hoursSinceMidnight-12)*greenCoefficient;
            //blue min 50 max 250
            float blueCoefficient = 41.6;
            blue = 250 - (hoursSinceMidnight-12)*blueCoefficient;
            
            UIColor *morning = [UIColor colorWithRed:red/255 green:0 blue:blue/255 alpha:1];
            self.backgroundColor = morning;
            
        }

        //sanity check the current color
        NSLog(@"Color: %@",self.backgroundColor);

        
        //create the MEAN label
        
        SKLabelNode *meanLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier-Oblique"];
        
        meanLabel.text = @"MEAN";
        meanLabel.alpha = 1 - alpha;
    
        meanLabel.fontSize = 100;
        meanLabel.position = CGPointMake(self.frame.size.width/2,self.frame.size.height/2-30);
        
        //create the FEEL label
        
        SKLabelNode *feelLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier-Oblique"];
        
        feelLabel.text = @"FEEL";
        feelLabel.alpha = alpha;
        
        feelLabel.fontSize = 100;
        feelLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame)-30);
        
    
        // add the labelNodes to the scene

        [self addChild:feelLabel];
        [self addChild:meanLabel];

    }
    return self;
}

// gets the localized time and calculates time after midnight
-(void)getTheTime {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [NSDate date];
    
    NSDateComponents *midnightdateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                   fromDate:date];
    [midnightdateComponents setHour:0];
    [midnightdateComponents setMinute:0];
    [midnightdateComponents setSecond:0];
    
    NSDate *midnightUTC = [calendar dateFromComponents:midnightdateComponents];
    
    
    NSTimeInterval altTimeSinceMidnight = [date timeIntervalSinceDate:midnightUTC];
    
    NSLog(@"Now: %@",date);
    NSLog(@"Midnight: %@",midnightUTC);
    NSLog(@"Alt Time Since Midnight: %f",altTimeSinceMidnight);
    _timeSinceMidnightInSeconds = altTimeSinceMidnight;

    

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
