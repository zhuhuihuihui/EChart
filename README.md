#EChart
A highly **extendable**, easy to use chart with **event handling**, **animation** supported. 


[![](https://dl.dropboxusercontent.com/s/d2yxmmqa4yjigbu/eColumn.gif)](https://dl.dropboxusercontent.com/s/d2yxmmqa4yjigbu/eColumn.gif)

[![](https://dl.dropboxusercontent.com/s/ehhscvf1m48v04h/eLine.gif)](https://dl.dropboxusercontent.com/s/ehhscvf1m48v04h/eLine.gif)

[![](https://dl.dropboxusercontent.com/s/2we5ay0fv5jmc6y/ePie.gif)](https://dl.dropboxusercontent.com/s/2we5ay0fv5jmc6y/ePie.gif)



## How To Use

#### Download and run the [EChartDemo](https://github.com/zhuhuihuihui/EChart/archive/master.zip) project is the best practice to know how to use EChart. 

### Step 1: Add EChart to Your Project
use [CocoaPods](http://cocoapods.org/) with **Podfile**:

```ruby
platform :ios, '7.0'
pod "EChart"
```

or Download project [here](https://github.com/zhuhuihuihui/EChart)

And Drag `/EChart/` folder into your project

### Step 2: Include ECharts in your View Controller 
**EColumnChart** as a example, all ECharts work in a similar way.

Import the head file:

	#import "EColumnChart.h"
	
Make your ViewController adopts the EColumnChart's protocol:

	@interface YourViewController : UIViewController <EColumnChartDelegate, EColumnChartDataSource>
	
Declare a EColumnChart instance:
	
	@property (strong, nonatomic) EColumnChart *eColumnChart;

### Step 3
Give your EColumnChart a nice frame:

	_eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(40, 100, 250, 200)];
	
Set EColumnChart's delegate and dataSource to your ViewController:

	[_eColumnChart setDelegate:self];
    [_eColumnChart setDataSource:self];
    
Add EColumnChart to wherever you want:

    [self.view addSubview:_eColumnChart];
    
## Provide data & Get events
After setting up your EColumnChart, you may need to provide the data for the EColumnChart and you will be able to get events from EColumnChart as well.

If you were a expert with `UITableView`, you will be quite familiar with the way `EColumnChart` works. Because they work in a same way.

### DataSource  
You need to implement every method in the `EColumnChartDataSource`

	/** How many Columns are there in total.*/
	- (NSInteger) numberOfColumnsInEColumnChart:(EColumnChart *) eColumnChart;

	/** How many Columns should be presented on the screen each time*/
	- (NSInteger) numberOfColumnsPresentedEveryTime:(EColumnChart *) eColumnChart;

	/** The highest value among the whole chart*/
	- (EColumnDataModel *)     highestValueEColumnChart:(EColumnChart *) eColumnChart;

	/** Value for each column*/
	- (EColumnDataModel *)     eColumnChart:(EColumnChart *) eColumnChart
                        valueForIndex:(NSInteger)index;
                        
### EColumnChartDelegate 
The implementation of the Delegate is according to your needs

	/** When finger single taped the column*/
	- (void)        eColumnChart:(EColumnChart *) eColumnChart
             didSelectColumn:(EColumn *) eColumn;

	/** When finger enter specific column, this is dif from tap*/
	- (void)        eColumnChart:(EColumnChart *) eColumnChart
        fingerDidEnterColumn:(EColumn *) eColumn;

	/** When finger leaves certain column, will tell you which column you are leaving*/
	- (void)        eColumnChart:(EColumnChart *) eColumnChart
        fingerDidLeaveColumn:(EColumn *) eColumn;

	/** When finger leaves wherever in the chart, will trigger both if finger is leaving from a column */
	- (void) fingerDidLeaveEColumnChart:(EColumnChart *)eColumnChart;
	
	
#License
EChart is available under the Apache License. See the LICENSE file for more info..



