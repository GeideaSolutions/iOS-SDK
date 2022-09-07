//
//  SuccessViewController.m
//  GeideaPaymentObjCSample
//
//  Created by euvid on 03/11/2020.
//

#import "SuccessViewController.h"

@interface SuccessViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.text = _json;
}

- (void)viewDidAppear:(BOOL)animated {
    [_textView setContentOffset:CGPointZero animated:YES];
}

- (IBAction)okTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
