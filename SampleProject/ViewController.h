//
//  ViewController.h
//  SampleProject
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) NSArray *usernames;
@property (strong, nonatomic) NSString *username;
@end
