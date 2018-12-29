//
//  AppDelegate.h
//  OpenGLES_Ch2_1
//
//  Created by 云舟02 on 2018-12-27.
//  Copyright © 2018 云舟02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end
