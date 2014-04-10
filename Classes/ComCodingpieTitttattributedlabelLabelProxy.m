/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2013 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "ComCodingpieTitttattributedlabelLabelProxy.h"
#import "TiUtils.h"

@implementation ComCodingpieTitttattributedlabelLabelProxy

USE_VIEW_FOR_CONTENT_WIDTH

-(void)_initWithProperties:(NSDictionary *)properties
{
    [super _initWithProperties:properties];
}

-(CGFloat)contentHeightForWidth:(CGFloat)suggestedWidth
{
	NSString *value = [TiUtils stringValue:[self valueForKey:@"text"]];
	id fontValue = [self valueForKey:@"font"];
	UIFont *font = nil;
	if (fontValue!=nil)
	{
		font = [[TiUtils fontValue:[self valueForKey:@"font"]] font];
	}
	else
	{
		font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
	}
	CGSize maxSize = CGSizeMake(suggestedWidth<=0 ? 480 : suggestedWidth, 10000);
    
    CGSize size;
    
    if ([value respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        CGRect textRect = [value boundingRectWithSize:maxSize
                                              options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName:font}
                                              context:nil];
        size = textRect.size;
        
        float fontSize = [[TiUtils fontValue:[self valueForKey:@"font"]] size];
        size.height += fontSize * ceil((size.height / fontSize) / 20); // TODO every 20 lines we add one more to fix the height
    } else {
        size = [value sizeWithFont:font constrainedToSize:maxSize lineBreakMode:UILineBreakModeTailTruncation];
    }
    
	return [self verifyHeight:size.height]; //Todo: We need to verifyHeight elsewhere as well.
}

-(CGFloat) verifyWidth:(CGFloat)suggestedWidth
{
	int width = ceil(suggestedWidth);
	if (width & 0x01)
	{
		width ++;
	}
	return width;
}

-(CGFloat) verifyHeight:(CGFloat)suggestedHeight
{
	int height = ceil(suggestedHeight);
	if (height & 0x01)
	{
		height ++;
	}
	return height;
}

-(NSArray *)keySequence
{
	static NSArray *labelKeySequence = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		labelKeySequence = [[NSArray arrayWithObjects:@"font",nil] retain];
	});
	return labelKeySequence;
}

-(NSMutableDictionary*)langConversionTable
{
    return [NSMutableDictionary dictionaryWithObject:@"text" forKey:@"textid"];
}

-(TiDimension)defaultAutoWidthBehavior:(id)unused
{
    return TiDimensionAutoSize;
}
-(TiDimension)defaultAutoHeightBehavior:(id)unused
{
    return TiDimensionAutoSize;
}

@end
