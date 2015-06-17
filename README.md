# GLCFoodApp

HOW TO GET THIS APP WORKING

First ensure you have xcode installed.
Then you can pull this repository, install cocoapods.
  
```sudo gem install cocoapods```

and run ```pod install``` in the directory with the podfile to install all the dependencies. Then open up the generated .xcworkspace file and 
use that instead of the .xcodeproj file.

At this point you should be able to run the app in the simulator.

Now go into the ResultsViewController.m file and replace the current value of the NSString url (with the large comment above it) with the url of the predictive service which is 
running the food classifier code.

At this point you need to deploy to a device so first of all go and create an iOS developer account (paid to be enrolled in the iphone developer program).
And follow apple's online instructions about how to deploy an application to the physical device.

NOTE: it is possible that you might have to change the code signing identity in the project or build target in order to be able to deploy to your devices although I don't think you have to.

If everything went well with following apples tutorial you should now be able to deploy the application to a physical device, and, after the app is deployed, it is installed on the phone even after testing has ceased.


  
