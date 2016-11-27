//
//  ViewController.m
//  Calculator
//
//  Created by Maksim Khokhlov on 11/26/16.
//  Copyright © 2016 Maksim Khokhlov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *numbersField;

@property (strong, nonatomic) NSString *operand1;
@property (strong, nonatomic) NSString *operand2;
@property (strong, nonatomic) NSString *operator;

@property (nonatomic) BOOL resetOperand;

@property (weak, nonatomic) IBOutlet UITextView *historyText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.numbersField.text = @"0";
    self.resetOperand = true;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clearPressed:(id)sender {
    self.operand1 = nil;
    self.operand2 = nil;
    self.operator = nil;
    self.numbersField.text = @"0";
}

- (IBAction)operatorPressed:(id)sender {
    UIButton *button = (UIButton *) sender;
    self.operand1 = self.numbersField.text;
    self.operator = [button currentTitle];
    self.resetOperand = true;
}

- (IBAction)equalsPressed:(id)sender {
    self.operand2 = self.numbersField.text;
    
    if (self.operand1 == nil || self.operator == nil || self.operand2 == nil)
        return;
    
    NSMutableString *historyLine = [NSMutableString string];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *operand1 = [f numberFromString: self.operand1];
    NSNumber *operand2 = [f numberFromString: self.operand2];
    float result = 0;
    
    [historyLine appendString: self.operand1];
    [historyLine appendString: self.operator];
    [historyLine appendString: self.operand2];
    
    if ([self.operator isEqualToString:@"+"]) {
        result = [operand1 floatValue] + [operand2 floatValue];
    } else if ([self.operator isEqualToString:@"-"]) {
        result = [operand1 floatValue] - [operand2 floatValue];
    } else if ([self.operator isEqualToString:@"/"]) {
        result = [operand1 floatValue] / [operand2 floatValue];
    } else if ([self.operator isEqualToString:@"*"]) {
        result = [operand1 floatValue] * [operand2 floatValue];
    } else if ([self.operator isEqualToString:@"%"]) {
        result = [operand1 floatValue] / 100.0;
    }
    
    if (result - (int)result > 0)
        self.numbersField.text = [NSString stringWithFormat:@"%f", result];
    else
        self.numbersField.text = [NSString stringWithFormat:@"%d", (int) result];

    [historyLine appendString: @"="];
    [historyLine appendString: self.numbersField.text];
    
    self.historyText.text = [NSString stringWithFormat:@"%@\n%@", [historyLine copy], self.historyText.text];
    self.resetOperand = true;
}
- (IBAction)clearHistoryPressed:(id)sender {
    self.historyText.text = @"";
}

- (IBAction)signPressed:(id)sender {
}

- (IBAction)numberSelected:(id)sender {
    UIButton *button = (UIButton *) sender;
    
    // if the value is 0 - replace it the new value
    if (self.resetOperand || ([self.numbersField.text isEqualToString: @"0"] && ![[button currentTitle] isEqualToString:@"."])) {
        self.numbersField.text = [button currentTitle];
        self.resetOperand =  false;
        return;
    }
    
    // if the value already contains a dot, don't allow another one
    if ([self.numbersField.text containsString: @"."] && [[button currentTitle] isEqualToString:@"."]) {
        return;
    }
    
    self.numbersField.text = [NSString stringWithFormat: @"%@%@", self.numbersField.text, [button currentTitle]];
}


@end
