//
//  ViewController.m
//  GeideaPaymentObjCSample
//
//  Created by euvid on 21/10/2020.
//

@import GeideaPaymentSDK;
//#import "GeideaPaymentSDK/GeideaPaymentSDK.h"
#import "ViewController.h"
#import "SuccessViewController.h"
#import <PassKit/PassKit.h>

@interface ViewController () <PKPaymentAuthorizationViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *applePayDirectBTN;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UITextField *currencyTF;
@property (weak, nonatomic) IBOutlet UITextField *cardHolderNameTF;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *cvvTF;
@property (weak, nonatomic) IBOutlet UITextField *expiryMonthTF;
@property (weak, nonatomic) IBOutlet UITextField *expiryYearTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *callbackUrlTF;
@property (weak, nonatomic) IBOutlet UITextField *publicKeyTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UISegmentedControl *environmentSelection;
@property (weak, nonatomic) IBOutlet UISwitch *loginSwitch;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *merchantRefIDTF;
@property (weak, nonatomic) IBOutlet UITextField *shippingCountryCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *shippingCityTF;
@property (weak, nonatomic) IBOutlet UITextField *shippingStreetTF;
@property (weak, nonatomic) IBOutlet UITextField *shippingPostCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *billingCountryCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *billingCityTF;
@property (weak, nonatomic) IBOutlet UITextField *billingStreetTF;
@property (weak, nonatomic) IBOutlet UITextField *billingPostCodeTF;
@property (weak, nonatomic) IBOutlet UIView *applePayBtnView;
@property (weak, nonatomic) IBOutlet UIView *cardOnFileView;
@property (weak, nonatomic) IBOutlet UILabel *cardOnFileLabel;
@property (weak, nonatomic) IBOutlet UISwitch *cardOnFileSwitch;
@property (weak, nonatomic) IBOutlet UIView *initiateByView;
@property (weak, nonatomic) IBOutlet UILabel *initiatedByLabel;
@property (weak, nonatomic) IBOutlet UIButton *initiatedByBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *configBtn;
@property (weak, nonatomic) IBOutlet UIView *AgreementView;
@property (weak, nonatomic) IBOutlet UILabel *agreementId;
@property (weak, nonatomic) IBOutlet UILabel *agreementType;
@property (weak, nonatomic) IBOutlet UITextField *agreementTypeTF;
@property (weak, nonatomic) IBOutlet UITextField *agreementIdTF;
@property (weak, nonatomic) IBOutlet UIButton *paymentOperationBtn;
@property (weak, nonatomic) IBOutlet UILabel *captureLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentOperationLabel;
@property (weak, nonatomic) IBOutlet UIButton *captureBtn;
@property (weak, nonatomic) IBOutlet UIButton *payTokenBtn;
@property (nonatomic, strong) GDConfigResponse *merchantConfig;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic) PaymentOperation *paymentOperation;
@property (weak, nonatomic) IBOutlet UISegmentedControl *paymentMethodSelection;
@property (weak, nonatomic) IBOutlet UISwitch *showAddressSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *showEmail;
@property (weak, nonatomic) IBOutlet UITextField *eInvoiceIdTF;
@property (weak, nonatomic) IBOutlet UIView *showAddressView;
@property (weak, nonatomic) IBOutlet UIView *paymentDetailsView;
@property (weak, nonatomic) IBOutlet UIImageView *cardSchemeLogoIV;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_environmentSelection addTarget:self action:@selector(valueChangedEnvironment:) forControlEvents:UIControlEventValueChanged];
    [_environmentSelection setSelectedSegmentIndex:0];
    [self valueChangedEnvironment:_environmentSelection];
    
    [_paymentMethodSelection addTarget:self action:@selector(valueChangedPayment:) forControlEvents:UIControlEventValueChanged];
    [_paymentMethodSelection setSelectedSegmentIndex:1];
    [self valueChangedPayment:_paymentMethodSelection];
    
    self.title = @"Payment Sample Objective C";
    
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.paymentOperation = _paymentOperation;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self registerForKeyboardNotifications];
    [self configureComponents];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(hideKeyboard)];
    [self.contentView addGestureRecognizer:gestureRecognizer];
}

-(void)setupApplePay:(UIView *) buttonView {
    _applePayBtnView.hidden = false;
    
    GDAmount *amount = [[GDAmount alloc] initWithAmount: [_amountTF.text doubleValue] currency:_currencyTF.text];
    GDApplePayDetails *applePayDetails = [[GDApplePayDetails alloc] initIn:self andButtonIn:buttonView forMerchantIdentifier:@"merchant.net.geidea.applepayonline.objc" andMerchantDisplayName:@"My Company" requiredBillingContactFields:false requiredShippingContactFields:false paymentMethods:NULL withCallbackUrl:_callbackUrlTF.text andReferenceId:_merchantRefIDTF.text];
    
    
    
    [GeideaPaymentAPI setupApplePayForApplePayDetails:applePayDetails with:amount config:nil completion:^(GDOrderResponse* response, GDErrorResponse* error) {
        if (error != NULL) {
            if (!error.errors || !error.errors.count) {
                NSString *message;
                if ( [error.responseCode length] ==0) {
                    message = [NSString stringWithFormat:@"\n responseMessage: %@", error.responseMessage];
                } else if ([error.orderId length] != 0) {
                    message = [NSString stringWithFormat:@"\n responseCode: %@ \n responseMessage: %@ \n detailedResponseCode: %@  \n detailedResponseMessage: %@ \n orderId: %@", error.responseCode , error.responseMessage, error.detailedResponseCode, error.detailedResponseMessage, error.orderId];
                } else {
                    message = [NSString stringWithFormat:@"\n responseCode: %@ \n responseMessage: %@ \n detailedResponseCode: %@  \n detailedResponseMessage: %@", error.responseCode , error.responseMessage, error.detailedResponseCode, error.detailedResponseMessage];
                }
                
                [self displayAlertViewWithTitle: error.title andMessage: message];
            } else {
                NSString *messageOutput = [NSString stringWithFormat:@"\n responseCode: %li \n responseMessage: %@ \n detailedResponseCode: %@ detailedResponseMessage: %@",  (long)error.status, error.errors, error.detailedResponseCode, error.detailedResponseMessage];
                [self displayAlertViewWithTitle: error.title andMessage: messageOutput];
            }
            
        } else {
            if (response != NULL) {
                NSString *messageOutput = [NSString stringWithFormat:@"\n responseCode: %f \n responseMessage: %@ \n orderId : %@",  response.amount, response.currency, response.orderId];
                [self displayAlertViewWithTitle: response.orderId andMessage: messageOutput];
                
            }
        }
    }];
    
}

-(void)configureComponents {
    _captureLabel.hidden = self.orderId == NULL;
    _captureBtn.hidden = self.orderId == NULL;
    
    [self setupApplePay:_applePayBtnView];
    
    [_loginSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    
    if ([GeideaPaymentAPI isCredentialsAvailable]) {
        [_loginSwitch setOn: YES];
        _loginLabel.text = @"Already Loggedin";
        [_passwordTF setEnabled:NO];
        [_publicKeyTF setEnabled:NO];
    } else {
        [_loginSwitch setOn: NO];
        _loginLabel.text = @"Login";
        [_passwordTF setEnabled:YES];
        [_publicKeyTF setEnabled:YES];
    }
    
    [self detectCardScheme];
    
    [self showPayWithToken];
}

- (void) hideKeyboard {
    [[self view] endEditing:YES];
}

- (void)changeSwitch:(id)sender{
    UISwitch *loginSwitch = (UISwitch*)sender;
    if (![loginSwitch isOn]) {
        [GeideaPaymentAPI removeCredentials];
    }
    [self configureComponents];
}

-(void) refreshConfig {
    [GeideaPaymentAPI getMerchantConfigWithCompletion:^(GDConfigResponse* config, GDErrorResponse* error) {
        if (config != NULL) {
            self->_merchantConfig = config;
            self->_configBtn.hidden = false;
            [self configureComponents];
        }
        
    }];
}
- (IBAction)tappedApplePayDirect:(id)sender {
    [self setupApplePay:NULL];
}

-(void) showPayWithToken {
    if ([self getTokens] != NULL) {
        for (id token in [self getTokens]){
            if (token[@"environment"] == [_environmentSelection selectedSegmentIndex]) {
                _payTokenBtn.hidden = false;
            } else {
                _payTokenBtn.hidden = true;
            }
            
        }
    } else {
        _payTokenBtn.hidden = true;
    }
}

- (IBAction)loginTapped:(id)sender {
    [GeideaPaymentAPI updateCredentialsWithMerchantKey:_publicKeyTF.text andPassword:_passwordTF.text];
    
    [_loginSwitch setOn:true];
    [self refreshConfig];
    [self setupApplePay:_applePayBtnView];
}

- (IBAction)configTapped:(id)sender {
    if (_merchantConfig != NULL) {
        
        
        NSString *configMessage = [GeideaPaymentAPI getConfigStringWithConfig:_merchantConfig];
        
        if (configMessage != NULL) {
            SuccessViewController *vc = [[SuccessViewController alloc] init];
            vc.json = configMessage;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
    
}

- (IBAction)payTapped:(id)sender {
    
    if (![GeideaPaymentAPI isCredentialsAvailable]) {
        [GeideaPaymentAPI setCredentialsWithMerchantKey:_publicKeyTF.text andPassword:_passwordTF.text];
    }
    
    GDAmount *amount = [[GDAmount alloc] initWithAmount: [_amountTF.text doubleValue] currency:_currencyTF.text];
    GDCardDetails *cardDetails = [[GDCardDetails alloc] initWithCardholderName:_cardHolderNameTF.text andCardNumber:_cardNumberTF.text andCVV:_cvvTF.text andExpiryMonth:[_expiryMonthTF.text integerValue] andExpiryYear:[_expiryYearTF.text integerValue]];
    
    GDTokenizationDetails *tokenizationDetails = [[GDTokenizationDetails alloc] initWithCardOnFile:[_cardOnFileSwitch isOn] initiatedBy:[_initiatedByBtn currentTitle] agreementId:_agreementIdTF.text agreementType:_agreementTypeTF.text subscriptionId:NULL ];
    

    
    GDApplePayDetails *applePayDetails = [[GDApplePayDetails alloc] initIn:self andButtonIn:_applePayBtnView forMerchantIdentifier:@"merchant.net.geidea.applepayonline.objc" andMerchantDisplayName:@"My Company" requiredBillingContactFields:false requiredShippingContactFields:false paymentMethods:NULL withCallbackUrl:_callbackUrlTF.text andReferenceId:_merchantRefIDTF.text];
    
    GDAddress *shippingAddress = [[GDAddress alloc] initWithCountryCode:_shippingCountryCodeTF.text andCity:_shippingCityTF.text andStreet:_shippingStreetTF.text andPostCode:_shippingPostCodeTF.text];
    
    GDAddress *billingAddress = [[GDAddress alloc] initWithCountryCode:_billingCountryCodeTF.text andCity:_billingCityTF.text andStreet:_billingStreetTF.text andPostCode:_billingPostCodeTF.text];
    
    GDCustomerDetails *customerDetails = [[GDCustomerDetails alloc] initWithEmail:_emailTF.text andCallbackUrl:_callbackUrlTF.text merchantReferenceId:_merchantRefIDTF.text shippingAddress:shippingAddress billingAddress:billingAddress paymentOperation:self.paymentOperation];
    
    
    if (_paymentMethodSelection.selectedSegmentIndex == 1 ) {
        [self payWithAmount: amount andCardDetails:cardDetails andTokenizationDetails:tokenizationDetails andCustomerDetails:customerDetails];
    } else {
        [self payWithGeideaForm:amount showAddress:_showAddressSwitch.on showEmail:_showEmail.on  andTokenizationDetails:tokenizationDetails andCustomerDetails:customerDetails andApplePayDetails:applePayDetails];
    }
    
}

- (void)payWithAmount:(GDAmount *)amount andCardDetails: (GDCardDetails *) cardDetails andTokenizationDetails: (GDTokenizationDetails *) tokenizationDetails  andCustomerDetails: customerDetails {
    UINavigationController *navVC =  (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    [GeideaPaymentAPI payWithTheAmount:amount withCardDetails:cardDetails config:_merchantConfig showReceipt:true andTokenizationDetails:tokenizationDetails andPaymentIntentId:NULL andCustomerDetails:customerDetails orderId:NULL paymentMethods:NULL dismissAction:NULL navController:navVC completion:^(GDOrderResponse* order, GDErrorResponse* error) {
//    [GeideaPaymentAPI payWithTheAmount:amount withCardDetails:cardDetails and3DV2Enabled: true andTokenizationDetails:tokenizationDetails andPaymentIntentId:_eInvoiceIdTF.text andCustomerDetails:customerDetails orderId:NULL paymentMethods:NULL isFromHPP:false dismissAction:NULL navController:navVC completion:^(GDOrderResponse* order, GDErrorResponse* error) {
        
        if (error != NULL) {
            if (!error.errors || !error.errors.count) {
                NSString *message;
                if ( [error.responseCode length] ==0) {
                    message = [NSString stringWithFormat:@"\n responseMessage: %@", error.responseMessage];
                } else if ([error.orderId length] != 0) {
                    message = [NSString stringWithFormat:@"\n responseCode: %@ \n responseMessage: %@ \n detailedResponseCode: %@  \n detailedResponseMessage: %@ \n orderId: %@", error.responseCode , error.responseMessage, error.detailedResponseCode, error.detailedResponseMessage, error.orderId];
                } else {
                    message = [NSString stringWithFormat:@"\n responseCode: %@ \n responseMessage: %@ \n detailedResponseCode: %@  \n detailedResponseMessage: %@", error.responseCode , error.responseMessage, error.detailedResponseCode, error.detailedResponseMessage];
                }
                
                [self displayAlertViewWithTitle: error.title andMessage: message];
            } else {
                NSString *messageOutput = [NSString stringWithFormat:@"\n responseCode: %li \n responseMessage: %@ \n detailedResponseCode: %@ detailedResponseMessage: %@",  (long)error.status, error.errors, error.detailedResponseCode, error.detailedResponseMessage];
                [self displayAlertViewWithTitle: error.title andMessage: messageOutput];
            }
            
        } else {
            if (order != NULL) {
                
                NSString *prettyMessage = [GeideaPaymentAPI getModelStringWithOrder:order];
                
                if (prettyMessage != NULL) {
                    
                    SuccessViewController *vc = [[SuccessViewController alloc] init];
                    vc.json = prettyMessage;
                    [self presentViewController:vc animated:YES completion:nil];
                }
                
                if ([[order detailedStatus] isEqual: @"Authorized"]) {
                    self.orderId = [order orderId];
                    _captureLabel.text = [order orderId];
                    [self configureComponents];
                }
                
                if ([order tokenId] != NULL && [[order paymentMethod] maskedCardNumber] != NULL) {
                    
                    [self saveTokenId:[order tokenId] andMaskedCardNumber:[[order paymentMethod] maskedCardNumber]];
                }
                
            }
        }
    }];
}

- (void)payWithGeideaForm:(GDAmount *)amount showAddress: (bool)addressShown  showEmail: (bool)emailShown andTokenizationDetails: (GDTokenizationDetails *) tokenizationDetails  andCustomerDetails: customerDetails  andApplePayDetails: (GDApplePayDetails *) applePayDetails {
    UINavigationController *navVC =  (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    [GeideaPaymentAPI payWithGeideaFormWithTheAmount:amount showAddress:addressShown showEmail:emailShown showReceipt:true tokenizationDetails:tokenizationDetails customerDetails:customerDetails applePayDetails:applePayDetails config:_merchantConfig paymentIntentId:NULL qrDetails:NULL bnplItems:NULL paymentMethods:NULL viewController:navVC completion:^(GDOrderResponse* order, GDErrorResponse* error) {
 
//    [GeideaPaymentAPI payWithGeideaFormWithTheAmount:amount showAddress:addressShown showEmail:emailShown showReceipt:true tokenizationDetails:tokenizationDetails customerDetails:customerDetails applePayDetails:applePayDetails config:NULL paymentIntentId:NULL qrDetails:NULL paymentMethods:NULL viewController:self completion:^(GDOrderResponse* order, GDErrorResponse* error) {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (error != NULL) {
                if (!error.errors || !error.errors.count) {
                    NSString *message;
                    if ( [error.responseCode length] ==0) {
                        message = [NSString stringWithFormat:@"\n responseMessage: %@", error.responseMessage];
                    } else if ([error.orderId length] != 0) {
                        message = [NSString stringWithFormat:@"\n responseCode: %@ \n responseMessage: %@ \n detailedResponseCode: %@  \n detailedResponseMessage: %@ \n orderId: %@", error.responseCode , error.responseMessage, error.detailedResponseCode, error.detailedResponseMessage, error.orderId];
                    } else {
                        message = [NSString stringWithFormat:@"\n responseCode: %@ \n responseMessage: %@ \n detailedResponseCode: %@  \n detailedResponseMessage: %@", error.responseCode , error.responseMessage, error.detailedResponseCode, error.detailedResponseMessage];
                    }
                    
                    [self displayAlertViewWithTitle: error.title andMessage: message];
                } else {
                    NSString *messageOutput = [NSString stringWithFormat:@"\n responseCode: %li \n responseMessage: %@ \n detailedResponseCode: %@ detailedResponseMessage: %@",  (long)error.status, error.errors, error.detailedResponseCode, error.detailedResponseMessage];
                    [self displayAlertViewWithTitle: error.title andMessage: messageOutput];
                }
                
            } else {
                if (order != NULL) {
                    
                    NSString *prettyMessage = [GeideaPaymentAPI getModelStringWithOrder:order];
                    
                    if (prettyMessage != NULL) {
                        
                        SuccessViewController *vc = [[SuccessViewController alloc] init];
                        vc.json = prettyMessage;
                        [self presentViewController:vc animated:YES completion:nil];
                    }
                    
                    if ([[order detailedStatus] isEqual: @"Authorized"]) {
                        self.orderId = [order orderId];
                        _captureLabel.text = [order orderId];
                        [self configureComponents];
                    }
                    
                    if ([order tokenId] != NULL && [[order paymentMethod] maskedCardNumber] != NULL) {
                        
                        [self saveTokenId:[order tokenId] andMaskedCardNumber:[[order paymentMethod] maskedCardNumber]];
                    }
                    
                }
            }
            
        });
        
    }];
}

- (IBAction)payTokenTapped:(id)sender {
    GDAmount *amount = [[GDAmount alloc] initWithAmount: [_amountTF.text doubleValue] currency:_currencyTF.text];
    
    GDTokenizationDetails *tokenizationDetails = [[GDTokenizationDetails alloc] initWithCardOnFile:[_cardOnFileSwitch isOn] initiatedBy:[_initiatedByBtn currentTitle] agreementId:_agreementIdTF.text agreementType:_agreementTypeTF.text subscriptionId:NULL ];
    
    GDAddress *shippingAddress = [[GDAddress alloc] initWithCountryCode:_shippingCountryCodeTF.text andCity:_shippingCityTF.text andStreet:_shippingStreetTF.text andPostCode:_shippingPostCodeTF.text];
    
    GDAddress *billingAddress = [[GDAddress alloc] initWithCountryCode:_billingCountryCodeTF.text andCity:_billingCityTF.text andStreet:_billingStreetTF.text andPostCode:_billingPostCodeTF.text];
    GDCustomerDetails *customerDetails = [[GDCustomerDetails alloc] initWithEmail:_emailTF.text andCallbackUrl:_callbackUrlTF.text merchantReferenceId:_merchantRefIDTF.text shippingAddress:shippingAddress billingAddress:billingAddress paymentOperation:self.paymentOperation];
    
    UINavigationController *navVC =  (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    
//    [GeideaPaymentAPI payWithTokenWithTheAmount:amount withTokenId:@"token" tokenizationDetails:tokenizationDetails andCustomerDetails:customerDetails navController:self completion:^(GDOrderResponse* order, GDErrorResponse* error) {
//
//        if (error != NULL) {
//            if (!error.errors || !error.errors.count) {
//                NSString *message;
//                if ( [error.responseCode length] ==0) {
//                    message = [NSString stringWithFormat:@"\n responseMessage: %@", error.responseMessage];
//                } else if ([error.orderId length] != 0) {
//                    message = [NSString stringWithFormat:@"\n responseCode: %@ \n responseMessage: %@ \n detailedResponseCode: %@  \n detailedResponseMessage: %@ \n orderId: %@", error.responseCode , error.responseMessage, error.detailedResponseCode, error.detailedResponseMessage, error.orderId];
//                } else {
//                    message = [NSString stringWithFormat:@"\n responseCode: %@ \n responseMessage: %@ \n detailedResponseCode: %@  \n detailedResponseMessage: %@", error.responseCode , error.responseMessage, error.detailedResponseCode, error.detailedResponseMessage];
//                }
//
//                [self displayAlertViewWithTitle: error.title andMessage: message];
//            } else {
//                NSString *messageOutput = [NSString stringWithFormat:@"\n responseCode: %li \n responseMessage: %@ \n detailedResponseCode: %@ detailedResponseMessage: %@",  (long)error.status, error.errors, error.detailedResponseCode, error.detailedResponseMessage];
//                [self displayAlertViewWithTitle: error.title andMessage: messageOutput];
//            }
//
//        } else {
//            if (order != NULL) {
//
//                NSString *prettyMessage = [GeideaPaymentAPI getModelStringWithOrder:order];
//
//                if (prettyMessage != NULL) {
//
//                    SuccessViewController *vc = [[SuccessViewController alloc] init];
//                    vc.json = prettyMessage;
//                    [self presentViewController:vc animated:YES completion:nil];
//                }
//
//                if ([[order detailedStatus] isEqual: @"Authorized"]) {
//                    self.orderId = [order orderId];
//                    self->_captureLabel.text = [order orderId];
//                    [self configureComponents];
//                }
//
//                if ([order tokenId] != NULL && [[order paymentMethod] maskedCardNumber] != NULL) {
//
//                    [self saveTokenId:[order tokenId] andMaskedCardNumber:[[order paymentMethod] maskedCardNumber]];
//                }
//
//            }
//        }
//    }];
}

- (IBAction)initiatedBtnTapped:(id)sender {
    
}

- (IBAction)paymentOperationTapped:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Payment operation" message:@"Please Select the payment operation" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"NONE" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        self.paymentOperation = PaymentOperationNONE;
        [_paymentOperationBtn setTitle:@"NONE" forState:(UIControlStateNormal)];
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Pay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        self.paymentOperation = PaymentOperationPay;
        [self->_paymentOperationBtn setTitle:@"Pay" forState:(UIControlStateNormal)];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"PreAuthorize" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.paymentOperation = PaymentOperationPreAuthorize;
        [self->_paymentOperationBtn setTitle:@"PreAuthorize" forState:(UIControlStateNormal)];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"AuthorizeCapture" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self->_paymentOperationBtn setTitle:@"AuthorizeCapture" forState:(UIControlStateNormal)];
        self.paymentOperation = PaymentOperationAuthorizeCapture;
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
    
};

- (IBAction)captureBtnTapped:(id)sender {
    
    UINavigationController *navVC = (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    [GeideaPaymentAPI captureWith:self.orderId callbackUrl:_callbackUrlTF.text navController:navVC completion:^(GDOrderResponse* order, GDErrorResponse* error) {
//    [GeideaPaymentAPI captureWith:self.orderId navController: navVC completion:^(GDOrderResponse* order, GDErrorResponse* error) {
        
        if (error != NULL) {
            if (!error.errors || !error.errors.count) {
                NSString *message;
                if ( [error.responseCode length] ==0) {
                    message = [NSString stringWithFormat:@"\n responseMessage: %@", error.responseMessage];
                } else if ([error.orderId length] != 0) {
                    message = [NSString stringWithFormat:@"\n responseCode: %@ \n responseMessage: %@ \n detailedResponseCode: %@  \n detailedResponseMessage: %@ \n orderId: %@", error.responseCode , error.responseMessage, error.detailedResponseCode, error.detailedResponseMessage, error.orderId];
                } else {
                    message = [NSString stringWithFormat:@"\n responseCode: %@ \n responseMessage: %@ \n detailedResponseCode: %@  \n detailedResponseMessage: %@", error.responseCode , error.responseMessage, error.detailedResponseCode, error.detailedResponseMessage];
                }
                
                [self displayAlertViewWithTitle: error.title andMessage: message];
            } else {
                NSString *messageOutput = [NSString stringWithFormat:@"\n responseCode: %li \n responseMessage: %@ \n detailedResponseCode: %@ detailedResponseMessage: %@",  (long)error.status, error.errors, error.detailedResponseCode, error.detailedResponseMessage];
                [self displayAlertViewWithTitle: error.title andMessage: messageOutput];
            }
            
        } else {
            if (order != NULL) {
                
                NSString *prettyMessage = [GeideaPaymentAPI getModelStringWithOrder:order];
                
                if (prettyMessage != NULL) {
                    
                    SuccessViewController *vc = [[SuccessViewController alloc] init];
                    vc.json = prettyMessage;
                    [self presentViewController:vc animated:YES completion:nil];
                }
                self.orderId = NULL;
                self.captureLabel.text = @"Capture:";
                [self configureComponents];
                
            }
        }
    }];
    
}
- (IBAction)generateInvoiceTapped:(id)sender {
    
//    [GeideaPaymentAPI startPaymentIntentWithPaymentIntentID:_eInvoiceIdTF.text status:NULL type:@"EInvoice" viewController:self completion:^(GDPaymentIntentResponse* eInvoiceResponse, GDErrorResponse* error) {
//        if (error != NULL) {
//            if (!error.errors || !error.errors.count) {
//                NSString *message;
//                if ( [error.responseCode length] ==0) {
//                    message = [NSString stringWithFormat:@"\n responseMessage: %@", error.responseMessage];
//                } else if ([error.orderId length] != 0) {
//                    message = [NSString stringWithFormat:@"\n responseCode: %@ \n responseMessage: %@ \n detailedResponseCode: %@  \n detailedResponseMessage: %@ \n orderId: %@", error.responseCode , error.responseMessage, error.detailedResponseCode, error.detailedResponseMessage, error.orderId];
//                } else {
//                    message = [NSString stringWithFormat:@"\n responseCode: %@ \n responseMessage: %@ \n detailedResponseCode: %@  \n detailedResponseMessage: %@", error.responseCode , error.responseMessage, error.detailedResponseCode, error.detailedResponseMessage];
//                }
//
//                [self displayAlertViewWithTitle: error.title andMessage: message];
//            } else {
//                NSString *messageOutput = [NSString stringWithFormat:@"\n responseCode: %li \n responseMessage: %@ \n detailedResponseCode: %@ detailedResponseMessage: %@",  (long)error.status, error.errors, error.detailedResponseCode, error.detailedResponseMessage];
//                [self displayAlertViewWithTitle: error.title andMessage: messageOutput];
//            }
//
//        } else {
//            if (eInvoiceResponse != NULL) {
//
//                NSString *prettyMessage = [GeideaPaymentAPI getPaymentIntentStringWithOrder:eInvoiceResponse];
//
//                if (prettyMessage != NULL) {
//
//                    SuccessViewController *vc = [[SuccessViewController alloc] init];
//                    vc.json = prettyMessage;
//                    [self presentViewController:vc animated:YES completion:nil];
//                }
//                self.eInvoiceIdTF.text = eInvoiceResponse.paymentIntent.paymentIntentId;
//            }
//        }
//    }];
}

- (void)valueChangedEnvironment:(UISegmentedControl *)segmentedControl
{
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:  [GeideaPaymentAPI setEnvironmentWithEnvironment:EnvironmentDev];
            break;
        case 1: [GeideaPaymentAPI setEnvironmentWithEnvironment:EnvironmentTest];
            break;
        case 2: [GeideaPaymentAPI setEnvironmentWithEnvironment:EnvironmentPreprod];
            break;
        case 3: [GeideaPaymentAPI setEnvironmentWithEnvironment:EnvironmentProd];
            break;
    }
    [self refreshConfig];
    [self setupApplePay:_applePayBtnView];
}

- (IBAction)paymentMethodSelectionTapped:(id)sender {
    [self valueChangedPayment:sender];
}


- (void)valueChangedPayment:(UISegmentedControl *)segmentedControl
{
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            _paymentDetailsView.hidden = YES;
            _showAddressView.hidden = NO;
            
            break;
        case 1:
            _paymentDetailsView.hidden = NO;
            _showAddressView.hidden = YES;
            break;
    }
    [self refreshConfig];
    [self setupApplePay:_applePayBtnView];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}

-(void) saveTokenId: (NSString *) tokenId andMaskedCardNumber: (NSString *) maskedCardNumber{
    NSMutableArray* tokens;
    NSMutableArray* savedTokens = [self getTokens];
    if (savedTokens != NULL) {
        tokens = savedTokens;
        int index = 0;
        for (id token in tokens){
            if (token[@"tokenId"] == tokenId) {
                if ([tokens count] > index){
                    [tokens removeObjectAtIndex: index];
                }
            }
            index += 1;
        }
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"environment"] = _environmentSelection;
    dict[@"maskedCardNumber"] = maskedCardNumber;
    dict[@"tokenId"] = tokenId;
    
    [tokens addObject: dict];
}

-(NSMutableArray*) getTokens {
    NSMutableArray* myTokens = [[NSUserDefaults standardUserDefaults] arrayForKey:@"myTokens"];
    return myTokens;
}

-(void) clearTokens {
    NSUserDefaults* nsUserDefault =  [NSUserDefaults standardUserDefaults];
    [nsUserDefault removeObjectForKey:@"myTokens"];
    [nsUserDefault synchronize];
}

-(void) detectCardScheme {
    
    _cardSchemeLogoIV.image = NULL;
    NSString  *cardNumber = [_cardNumberTF.text stringByReplacingOccurrencesOfString:@" " withString: @""];
    cardNumber = [cardNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    _cardSchemeLogoIV.image = [GeideaPaymentAPI getCardSchemeLogoWithCardNumber:cardNumber];
    
    
}

#pragma mark----****---- alert

- (void)displayAlertViewWithTitle:(NSString *)title andMessage: (NSString *)message {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle : title
                                                                    message : message
                                                             preferredStyle : UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:yesButton];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
    
}


@end
