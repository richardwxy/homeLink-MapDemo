//
//  myAnnotationView.m
//  mapdemo
//
//  Created by richard on 15/2/5.
//  Copyright (c) 2015年 richard. All rights reserved.
//

#import "myAnnotationView.h"
#import "myAnnotation.h"
@implementation myAnnotationView

-(id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([annotation isKindOfClass:[myAnnotation class]]) {

        self.backgroundColor = [UIColor clearColor];
        //大头针的图片
        _mainImageV = [[UIImageView alloc] initWithFrame:CGRectMake(-42, -17.5, 84 ,35)];
        [_mainImageV setImage:[UIImage imageNamed:@"annoImg"]];
        [self addSubview:_mainImageV];

        _name = [[UILabel alloc] initWithFrame:CGRectMake(5, -1, 86, 30)];
        _name.text = [[(myAnnotation *)annotation model] sectionName];
        _name.font = [UIFont systemFontOfSize:13];
        _name.textColor = [UIColor whiteColor];
        _name.textAlignment = NSTextAlignmentLeft;
        [_mainImageV addSubview:_name];
            
        _num = [[UILabel alloc] initWithFrame:CGRectMake(59, -1, 20, 30)];
        _num.text = [NSString stringWithFormat:@"%ld",[[(myAnnotation *)annotation model] sellNum]];
        _num.font = [UIFont systemFontOfSize:13];
        _num.textColor = [UIColor whiteColor];
        _num.textAlignment = NSTextAlignmentLeft;
        [_mainImageV addSubview:_num];
        }
    }
    return self;
}
@end
