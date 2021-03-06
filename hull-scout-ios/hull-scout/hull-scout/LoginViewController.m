//
//  LoginViewController.m
//  hull-scout
//
//  Created by Zaki Shaheen on 2/21/15.
//  Copyright (c) 2015 Zaki Shaheen. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginFacebook:(id)sender {
    
    NSArray *permissions = @[@"public_profile", @"email", @"user_friends"];
    
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            
            //get name, email, set XP to zero, level to zero.
            
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    
                    //setup a new user with required infos.
                    
                    user[@"email"] = result[@"email"];
                    user[@"name"] = result[@"name"];
                    user[@"gender"] = result[@"gender"];
                    user[@"xp"] = @(0);
                    user[@"level"] = @(0);
                    
                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if(succeeded){
                            //jump to next screen.
                            NSLog(@"User created for hull successfully");
                        }else{
                            NSLog(@"Could not publish user to hull");
                        }
                    }];
                    NSLog(@"user info: %@", result);
                } else {
                    NSLog(@"Problem getting user info");
                }
            }];
            
            
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            NSLog(@"User logged in through Facebook!");
            
            
            //segue to home screen.
        }
    }];
}
@end
