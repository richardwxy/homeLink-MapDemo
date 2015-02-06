//
//  ViewController.m
//  homelinkMapDemo
//
//  Created by richard on 15/2/4.
//  Copyright (c) 2015年 richard. All rights reserved.
//

#import "ViewController.h"
#import "sectionModel.h"
#import "myAnnotationView.h"
#import "myAnnotation.h"
@interface ViewController ()
{
    MAMapView * _mapView;
    CLLocationManager * locationManager;
    NSMutableArray * _dataArray;
    NSString * zoomLevel;
}


@end

@implementation ViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   }

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _dataArray = [[NSMutableArray alloc] init];
    zoomLevel = @"detail";
    
    
    [MAMapServices sharedServices].apiKey=@"2b10decfe588a2fd99ca352ed20ced3c";
    
    _mapView = [[MAMapView alloc] initWithFrame:self.view.frame];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    
    //获取授权认证
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestAlwaysAuthorization];
    [locationManager requestWhenInUseAuthorization];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}

-(void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"%lf",mapView.zoomLevel);
    [self requestForPOI];
}

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation fromLocation: (CLLocation *)oldLocation
{
    NSTimeInterval howRecent = [newLocation.timestamp timeIntervalSinceNow];
    if(howRecent < -10) return ; //离上次更新的时间少于10秒
    if(newLocation.horizontalAccuracy > 100) return; //精度> 100米
    //经度和纬度
    //    double lat = newLocation.coordinate.latitude;
    //    double lon = newLocation.coordinate.longitude;
    //    _mapView.userLocation =
    //    [_mapView setCenterCoordinate:newLocation.coordinate animated:YES];
    
    [_mapView setRegion:MACoordinateRegionMake(newLocation.coordinate, MACoordinateSpanMake(0.04, 0.04))];
    
    [manager stopUpdatingLocation];
    
    [self requestForPOI];
    
}
-(void)requestForPOI
{
    CGFloat maxLati = _mapView.region.center.latitude + _mapView.region.span.latitudeDelta;
    CGFloat minLati = _mapView.region.center.latitude - _mapView.region.span.latitudeDelta;
    CGFloat maxLoti = _mapView.region.center.longitude + _mapView.region.span.longitudeDelta;
    CGFloat minLoti = _mapView.region.center.longitude - _mapView.region.span.longitudeDelta;
    CGFloat avgLati = _mapView.region.center.latitude;
    CGFloat avgLoti = _mapView.region.center.longitude;
    
    NSURL * url = [NSURL URLWithString:[[NSString stringWithFormat:@"http://apimo1.homelink.com.cn/client2014/MapInfo/MapInfo?actionType=1&cityId=110000&latitudeMax=%.10f&latitudeMin=%.10f&latitudes=%.10f&longitudeMax=%.10f&longitudeMin=%.10f&longitudes=%.10f&rows=20&searchMapType=google&sellOrRent=103100000001&start=0&type=google",maxLati,minLati,avgLati,maxLoti,minLoti,avgLoti] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        //系统自带JSON解析
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",resultDic);
        NSArray * arr = [[resultDic objectForKey:@"response"] objectForKey:@"docs"];
        [_dataArray removeAllObjects];
        for (NSDictionary * dic in arr) {
             sectionModel * model = [[sectionModel alloc] init];
            if ([[dic valueForKey:@"communityName"] length]>=5) {
                model.sectionName = [[dic valueForKey:@"communityName"] substringToIndex:4];
            }
            else
            {   model.sectionName = [dic valueForKey:@"communityName"];  }
            model.sellNum = [[dic valueForKey:@"houseSellNums"] integerValue];
            model.latitude = [[dic valueForKey:@"googleLatitude"] doubleValue];
            model.longtitude = [[dic valueForKey:@"googleLongitude"] doubleValue];
            [_dataArray addObject:model];
        }
        [self createAnnotation];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    [operation start];
}

-(void)createAnnotation
{
    NSLog(@"%@",_dataArray);
    
    for (sectionModel * model in _dataArray) {
        myAnnotation * anno = [[myAnnotation alloc] init];
        anno.model = model;
        anno.lc2d = CLLocationCoordinate2DMake(model.latitude, model.longtitude);
        [_mapView addAnnotation:anno];
    }
}
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if (![annotation isKindOfClass:[MAUserLocation class]])
    {
        if ([zoomLevel isEqualToString:@"detail"]) {
            static NSString *customReuseIndetifier = @"customReuseIndetifier";
            
            myAnnotationView *annotationView = (myAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
            
            if (annotationView == nil)
            {
                annotationView = [[myAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
                annotationView.canShowCallout = NO;
                annotationView.draggable = YES;
                annotationView.calloutOffset = CGPointMake(0, -5);
            }
            annotationView.annotation = annotation;
            return annotationView;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        //显示自己信息
        MAAnnotationView * selfAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"selfAnnotation"];
        selfAnnotationView.image = [UIImage imageNamed:@"selfImg"];
        return selfAnnotationView;
    }
}

//-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//    MKAnnotationView * anno = [mapView dequeueReusableAnnotationViewWithIdentifier:@"anno"];
//    
//    if (!anno) {
//        myAnnotationView * newAnno = [[myAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"anno"];
//        newAnno.model = [_dataArray firstObject];
//        newAnno.image = [UIImage imageNamed:@"annoImg"];
////        newAnno.name.text = ;
////        newAnno.num.text = ;
//        
//    }
//    return anno;
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
