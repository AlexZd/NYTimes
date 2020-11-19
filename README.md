# NYTimes
This project is Master - Details application which showing popular news articles for selected period. 

For develoment of this project XCode 12.2 was used and it is build for iOS 13 and above.

Project has following stack:
* MVVM pattern
* UIKit for Master view. All UI written in code with constraints
* SwiftUI for Details view
* Combine for reactivity
* Codable for decoding json to objects
* SwiftLint for code style autofixes during compilation
* XCTest for View models and Models testing
* XCUITest for Views testing

## To run the project:
You need to open terminal and navigate to cloned project:
```
cd <path to cloned folder>
```
after this you need to install project pods (if cocoapods not installed follow [this guide](https://guides.cocoapods.org/using/getting-started.html#getting-started)):
```
pod install
```
then run `NYTimes.xcworkspace` file.
* For running project press `Cmd+R`
* For running tests press `Cmd+U` and `Cmd+6` for switching to "Test navigator"
* After running tests you can press `Cmd+9` and select "Coverage" line and you will see NYTimes target, which you can expand for details
