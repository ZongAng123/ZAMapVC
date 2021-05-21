//
//  ViewController.m
//  ZAMapVC
//
//  Created by 纵昂 on 2021/5/21.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
//获取当前位置经纬度
#import <AMapLocationKit/AMapLocationKit.h>

@interface ViewController ()<AMapLocationManagerDelegate>

@property (nonatomic,strong) AMapLocationManager * locationManager;

@end

@implementation ViewController
#pragma mark - 懒加载
-(AMapLocationManager *)locationManager{
    if (!_locationManager) {
    _locationManager = [[AMapLocationManager alloc]init];
     }
    return _locationManager;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
      (三)唯物辩证法三大规律
       1、对立统一规律
             对立统一规律是唯物辩证法最根本的规律，揭示了事物发展的源泉和动力，是唯物辩证法的实质和核心
             对立统一规律就是矛盾规律。矛盾对立面双方既有同一性又有斗争性。
             矛盾的普遍性属于事物的共性，矛盾的特殊性则是事物的个性。矛盾的普遍性和特殊性的关系，就是事物的共性和个性之间的关系
       2、量变质变规律
             量变是事物的量的规定性在度的范围内发生的微小的、不显著的变化，是事物原有发展过程的延续和渐进。质变是事物由一种质态向另一种质态的飞跃，是事物延续和渐进过程的中断。事物的变化有没有超出"度"的范围，是区分量变与质变的根本标志。任何事物的变化都是量变和质变的统一。量变是质变的必要准备，质变是量变的必然结果，事物不断不断经过"量变-质变-新的量变-新的质变"，两种状态循环往复，永不停息地向前发展。
       3、否定之否定规律
             事物的发展是通过否定实现的，当事物内部的肯定方面占据主导地位的时候，事物就处在肯定阶段;
    */
    
    self.navigationItem.title = @"纵昂高德地图";
    self.view.backgroundColor = [UIColor whiteColor];

    
    [self mapviewUI];
    [self location];
    
    
}


#pragma mark - 第三步，实例化地图对象
-(void)mapviewUI{
#pragma mark - 地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
        [AMapServices sharedServices].enableHTTPS = YES;
//    初始化地图
        MAMapView *_mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
//    把地图添加至view
        [self.view addSubview:_mapView];
//    如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
//        _mapView.showsIndoorMap = YES;    //YES：显示室内地图；NO：不显示；
//       [_mapView setMapType:MAMapTypeSatellite]; //卫星地图
    
#pragma mark -  显示英文地图 0代表中文，1代表英文  英文模式下为栅格图，实际效果需要开发者根据应用场景进行评估。
//        _mapView.mapLanguage = @(1);
//        _mapView.mapLanguage = @(0);
    
    
    
    
#pragma mark -   自定义定位小蓝点
//    初始化 MAUserLocationRepresentation 对象：
    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
    r.showsAccuracyRing = NO;///精度圈是否显示，默认YES
    r.showsHeadingIndicator = NO;///是否显示方向指示(MAUserTrackingModeFollowWithHeading模式开启)。默认为YES
    r.fillColor = [UIColor redColor];///精度圈 填充颜色, 默认 kAccuracyCircleDefaultColor
    r.strokeColor = [UIColor blueColor];///精度圈 边线颜色, 默认 kAccuracyCircleDefaultColor
    r.lineWidth = 2;///精度圈 边线宽度，默认0
    r.enablePulseAnnimation = NO;///内部蓝色圆点是否使用律动效果, 默认YES
    r.locationDotBgColor = [UIColor greenColor];///定位点背景色，不设置默认白色
    r.locationDotFillColor = [UIColor grayColor];///定位点蓝色圆点颜色，不设置默认蓝色
    r.image = [UIImage imageNamed:@"你的图片"]; ///定位图标, 与蓝色原点互斥
    [_mapView updateUserLocationRepresentation:r];
    
    
    
}

#pragma mark - 定位,获得位置和坐标   定位
- (void)location{
    self.locationManager.delegate = self;
//    高精度定位 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//    定位超时时间，最低2s，此处设置为10s
    self.locationManager.locationTimeout =10;
//    逆地理请求超时时间，最低2s，此处设置为10s
    self.locationManager.reGeocodeTimeout = 10;
//    获得返回的地址
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed) {
                return;
            }
        }
        NSLog(@"location:%@", location);
//        得到定位的经纬度
        CLLocationDegrees latitude = location.coordinate.latitude;
        CLLocationDegrees longitude = location.coordinate.longitude;
        NSLog(@"经度%f:",longitude);
        NSLog(@"纬度%f:",latitude);
        if (regeocode) {
            NSLog(@"reGeocode:%@", regeocode);
            NSLog(@"reGeocode.cityName:%@", regeocode.city);
        }
        
        
    }];
    
}

#pragma mark - 也可以在代理方法中获得定位度
#pragma mark - AMapLocationManagerDelegate 协议
#pragma mark - 定位失败
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败");
}
#pragma mark - 定位成功
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    [_locationManager stopUpdatingLocation];
    NSLog(@"高德地图定位的经纬度:%f %f",location.coordinate.latitude,location.coordinate.longitude);
//    [self HttpCityLatitude:location.coordinate.latitude Longitude:location.coordinate.longitude];
}


//[MAMapKit] 要在iOS 11及以上版本使用后台定位服务, 需要实现mapViewRequireLocationAuth: 代理方法
- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager*)locationManager{
    [locationManager requestAlwaysAuthorization];
}





@end
