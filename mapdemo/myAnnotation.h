//
//  myAnnotation.h
//  mapdemo
//
//  Created by richard on 15/2/5.
//  Copyright (c) 2015年 richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAMapKit.h"
#import "sectionModel.h"
@interface myAnnotation : NSObject<MAAnnotation>
@property (nonatomic,strong) sectionModel * model;
@property (nonatomic,assign) CLLocationCoordinate2D lc2d;
@end
