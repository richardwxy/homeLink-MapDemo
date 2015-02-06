//
//  myAnnotationView.h
//  mapdemo
//
//  Created by richard on 15/2/5.
//  Copyright (c) 2015年 richard. All rights reserved.
//

#import "MAMapKit.h"
#import "sectionModel.h"
@interface myAnnotationView : MAAnnotationView
@property (nonatomic,strong) UIImageView * mainImageV;
@property (nonatomic,strong) UILabel * name;
@property (nonatomic,strong) UILabel * num;
@property (nonatomic,strong) sectionModel * model;

@end
