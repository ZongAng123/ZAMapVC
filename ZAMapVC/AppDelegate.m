//
//  AppDelegate.m
//  ZAMapVC
//
//  Created by 纵昂 on 2021/5/21.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    ViewController *mainView = [[ViewController alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:mainView];
    navi.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.window setRootViewController:navi];
    [self.window makeKeyAndVisible];
    
    return YES;
}





@end
