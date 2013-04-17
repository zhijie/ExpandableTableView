ExpandeTableView
================

tableview cell expand animation,
which create a smooth transformation from master view (like UITableViewController) to detailview

HOW TO USES:
step 1: copy OZLExpandableTableView.h && OZLExpandableTableView.m to your project
step 2: #import "OZLExpandableTableView.h" in your master view
step 3: in your master view, add code [self expandFromCell: toViewController:] when you trigger the detail view
for example:

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OZLDetailViewController *detailview = [[OZLDetailViewController alloc] init];
    detailview.titleStr = [_data objectAtIndex:indexPath.row];
    [self expandFromCell:[tableView cellForRowAtIndexPath:indexPath] toViewController:detailview];
    
}

step 4: add code below in your master view
-(void) viewWillAppear:(BOOL)animated
{
    [self restoreFromExpandedCell];
}

step 5: Enjoy!
