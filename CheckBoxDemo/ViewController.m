//
//  ViewController.m
//  CheckBoxDemo
//
//  Created by digifizz on 22/07/14.
//  Copyright (c) 2014 DIZIFIZZ. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"
@interface ViewController ()
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray=[[NSArray alloc]initWithObjects:@"hello",@"hi",nil];
	// Do any additional setup after loading the view, typically from a nib.
}
#pragma mark -
#pragma mark UITableViewDataSource

//| ----------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return (NSInteger)[self.dataArray count];
}


//| ----------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCustomCellID = @"CustomCell";
	
	CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:kCustomCellID];
	
	NSDictionary *item = self.dataArray[(NSUInteger)indexPath.row];
    
	cell.titleLabel.text = item[@"text"];
	cell.checkBox.checked = [item[@"checked"] boolValue];
    
    // Accessibility
    [self updateAccessibilityForCell:cell];
    
	return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

//| ----------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Find the cell being touched and update its checked/unchecked image.
	CustomCell *targetCustomCell = (CustomCell *)[tableView cellForRowAtIndexPath:indexPath];
    targetCustomCell.checkBox.checked = !targetCustomCell.checkBox.checked;
	
	// Don't keep the table selection.
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	// Update our data source array with the new checked state.
	NSMutableDictionary *selectedItem = self.dataArray[(NSUInteger)indexPath.row];
    selectedItem[@"checked"] = @(targetCustomCell.checkBox.checked);
    
    // Accessibility
    [self updateAccessibilityForCell:targetCustomCell];
}


//| ----------------------------------------------------------------------------
//! IBAction that is called when the value of a checkbox in any row changes.
//
- (IBAction)checkBoxTapped:(id)sender forEvent:(UIEvent*)event
{
    NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.tableview];
    
    // Lookup the index path of the cell whose checkbox was modified.
	NSIndexPath *indexPath = [self.tableview indexPathForRowAtPoint:currentTouchPosition];
    
	if (indexPath != nil)
	{
		// Update our data source array with the new checked state.
        NSMutableDictionary *selectedItem = self.dataArray[(NSUInteger)indexPath.row];
        selectedItem[@"checked"] = @([(Checkbox*)sender isChecked]);
	}
    
    // Accessibility
    [self updateAccessibilityForCell:(CustomCell*)[self.tableview cellForRowAtIndexPath:indexPath]];
}

//| ----------------------------------------------------------------------------
//  This will be called when the accessory button in one of the cells is tapped.

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString:@"DetailViewSegue"]) {
//        DetailViewController *destination = (DetailViewController*)segue.destinationViewController;
//        
//        NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:sender];
//        
//        destination.item = self.dataArray[(NSUInteger)selectedIndexPath.row];
//    }
}

#pragma mark -
#pragma mark Accessibility

//| ----------------------------------------------------------------------------
//! Utility method for configuring a cell's accessibilityValue based upon the
//! current checkbox state.
//
- (void)updateAccessibilityForCell:(CustomCell*)cell
{
    // The cell's accessibilityValue is the Checkbox's accessibilityValue.
    cell.accessibilityValue = cell.checkBox.accessibilityValue;
    
//    cell.checkBox.accessibilityLabel = cell.titleLabel.text;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
