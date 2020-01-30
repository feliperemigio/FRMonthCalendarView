![Swift Version](https://img.shields.io/badge/Swift-5.0-orange.svg)
# FRCalendarView  

Component to calendar (iOS or tvOS)

![Alt text](ss1.png?raw=true "Screenshot")
![Alt text](ss2.png?raw=true "Screenshot")

### Requirements

You will need CocoaPods and also your project must be targeted fo iOS 10.3 or higher.

## Installation

FRCalendarView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'FRCalendarView'
```

## How to use

1. Import the FRCalendarView

```swift 
import FRCalendarView
```

2. Configure the CalendarView:

```swift 
let calendarView = FRCalendarView.CalendarView()
self.view.addSubview(calendarView)

self.calendarView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: self.view.bounds.width,
                                 height: 380.0) // recommended height 
                                 
// Configure range to the calendar                            
self.calendarView.minDate = minDate
self.calendarView.maxDate = maxDate
        
// Indicate the month to start if need
self.calendarView.currentMonth = self.availableDates.first
        
// Indicate the selected date if need
self.calendarView.selectedStartDate = date
 ```

3. You can use data source to indicate the availables dates
```swift
self.calendarView.dataSource = self
 
// Add that code below your class
extension YourViewController: CalendarViewDataSource {
   func dates(at month: Date) -> [Date] {
       return [] // Your availables dates to that month
   }
}
```

4. You can use delegate to receiver actions
 ```swift
 self.calendarView.delegate = self
 
 // Add that code below your class
 extension YourViewController: CalendarViewDelegate {
    func calendarView(calendarView: CalendarView, endDisplayMonth month: Date) {  }
    func calendarView(calendarView: CalendarView, didSelectDates firstDate: Date, secondDate: Date?) { }
}
```

#### How Customize your calendar

```swift
        
self.calendarView.backgroundColor = .black
        
// Configure the day text style
self.calendarView.appearance.dayTextAttributes = [.foregroundColor: UIColor.white]
        
// Configure the selected day text style
self.calendarView.appearance.daySelectedTextAttributes = [.foregroundColor: UIColor.white]
        
// Configure the selected day background color
self.calendarView.appearance.tintColor = .red
        
// Configure the weekday text style
self.calendarView.appearance.weekdayTextAttributes = [.foregroundColor: UIColor.gray]
        
// Configure the month text style
self.calendarView.appearance.monthTextAttributes = [.foregroundColor: UIColor.gray]
        
// Configure the disabled text style
self.calendarView.appearance.disabledTextAttributes = [.foregroundColor: UIColor.gray]
        
// Configure the spacing between days
self.calendarView.appearance.columnSpacing = 11
        
// Configure a height to month view
self.calendarView.appearance.monthHeight = 88
        
// Configure a size to item (day and weekday)
self.calendarView.appearance.dayItemSize = CGSize(width: 40, height: 40)
        
// You can allow select a date range 
self.calendarView.allowMultipleSelection = true
        
// You can display a control previous and next to navigate
self.calendarView.isControlActive = true
```

## Author
Felipe Remigio

*I will appreciate your contribution if you have any idea to improve this component*  

## License
*See the LICENSE file for more info*






