//
//  mySectionAnnotationView.m
//  mapdemo
//
//  Created by richard on 15/2/6.
//  Copyright (c) 2015年 richard. All rights reserved.
//

#import "mySectionAnnotationView.h"
#import "myAnnotation.h"
@implementation mySectionAnnotationView


-(id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //大头针的图片
        _mainImageV = [[UIImageView alloc] initWithFrame:CGRectMake(-27, -27, 54 ,54)];
        [_mainImageV setImage:[UIImage imageNamed:@"annoSImg"]];
        [self addSubview:_mainImageV];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 44, 22)];
        _name.text = [[(myAnnotation *)annotation model] sectionName];
        _name.font = [UIFont systemFontOfSize:13];
        _name.textColor = [UIColor whiteColor];
        _name.textAlignment = NSTextAlignmentLeft;
        [_mainImageV addSubview:_name];
        
        _num = [[UILabel alloc] initWithFrame:CGRectMake(5, 27, 44, 22)];
        _num.text = [NSString stringWithFormat:@"%ld",[[(myAnnotation *)annotation model] sellNum]];
        _num.font = [UIFont systemFontOfSize:13];
        _num.textColor = [UIColor whiteColor];
        _num.textAlignment = NSTextAlignmentCenter;
        [_mainImageV addSubview:_num];
    
    }
    return self;
}

@end
