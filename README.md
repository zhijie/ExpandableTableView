ExpandableTableView
================

tableview cell expand animation<br/>
-------------------------------------
which create a smooth transformation from master view (like UITableViewController) to detailview<br/>

HOW TO USE:
------------
- **step 1**: copy OZLExpandableTableView.h && OZLExpandableTableView.m to your project
- **step 2**: <pre class="prettyprint">#import "OZLExpandableTableView.h"</pre> in your master view
- **step 3**: in your master view, add code [self expandFromCell: toViewController:] when you trigger the detail view
for example:
<pre class="prettyprint">
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OZLDetailViewController *detailview = [[OZLDetailViewController alloc] init];
    detailview.titleStr = [_data objectAtIndex:indexPath.row];
    [self expandFromCell:[tableView cellForRowAtIndexPath:indexPath] toViewController:detailview];
}

</pre>

- **step 4**: add code below in your master view
<pre class="prettyprint">
-(void) viewWillAppear:(BOOL)animated
{
    [self restoreFromExpandedCell];
}
</pre>
- **step 5**: Enjoy!
