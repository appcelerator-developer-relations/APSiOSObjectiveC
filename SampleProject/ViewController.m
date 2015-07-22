//
//  ViewController.m
//  SampleProject
//

#import "ViewController.h"
#import <Appcelerator/Appcelerator.h>

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Dismiss keyboard
    self.textField.delegate = self;
    [self.textField resignFirstResponder];
    
    // Query Cloud accounts to update Picker values
    [APSUsers query:nil withBlock:^(APSResponse *e){
        if (e.success) {
            _usernames = [e.response objectForKey:@"users"];
            [self.picker reloadAllComponents];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Unable to retrieve user accounts!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            NSLog(@"%@\n", e.responseString);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doClick:(id)sender {
    // Send analytics feature event
	[[APSAnalytics sharedInstance] sendAppFeatureEvent:@"sample.feature.login" payload:nil];
    
    // Login to a Cloud account
    NSDictionary *params = [[NSDictionary alloc]
                            initWithObjectsAndKeys:_username,@"login",
                            [_textField text],@"password",
                            nil];
    [APSUsers login:params withBlock:^(APSResponse *e){
        if (e.success) {
            NSLog(@"Successfully logged in as %@", _username);
            [APSPerformance sharedInstance].username = _username;
        } else {
            NSLog(@"ERROR: Failed to log in!");
        }
    }];
    
    // Throw an exception to show data in crash report
    @try {
        [NSException raise:NSGenericException format:@"Something happened..."];
    } @catch (NSException *exception) {
        [[APSPerformance sharedInstance] logHandledException:exception];
    }
}

#pragma mark Picker DataSource/Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _usernames.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_usernames[row] objectForKey:@"username"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _username = [_usernames[row] objectForKey:@"username"];
}

#pragma mark TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
