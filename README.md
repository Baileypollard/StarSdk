# StarSampleSdk

## iOS Bugs that need to be fixed

#### Retrieving network printer status fails after subsequent attempts
  **Steps to reproduce:**

  1. Turn on a Wi-Fi printer.
  2. Launch the app and press Scan Network for the app to discover the Wi-Fi printer. Select the printer from the list.
  3. On the printer details page, press Get status, release port TWICE. Verify the printer status changes to Online.
  4. Press Get status, release port TWICE a few more times, verifying the status is always Online.
  5. Press Get status, release port ONCE, verify the status is Online.
  6. Press Get status, release port ONCE again, and verify the status changes to Offline after a few seconds, with the following error message logged. Any subsequent attempt to get the printer status will result in this failure.

  **Video:** https://user-images.githubusercontent.com/45129610/144146683-6999d953-2829-442d-a944-4c87c1a6213e.mp4
  
  **Expected outcome:**
  We should be able to fetch the network printers status as many times as we would like, and not have to worry about the attempt to fetch the status failing. This works as expected on Android - but fails on iOS
  
  **Actual outcome:**
  The first attempt to fetch the printers status will succeed, but any subsequent attempt to grab the printers status will fail with the following error: Failed to getPort. Printer is in use.
  
--------------------------------------  
#### Star Bluetooth printer with an active StarIoExtManager connection won't reconnect if we don't call releasePort() after a print job. As a result, calling releasePort() results in the EXC_BAD_ACCESS crashes that we have been seeing in production

  **Steps to reproduce:**
  1. Manually pair a Star Micronics Bluetooth printer to the iOS device
  2. On the sample app, click the "Scan BT" button to discover the paired BT printer
  3. Click on the discovered BT printer row to navigate to printer details
  4. In the top right, click "Connect" - wait for the connection to succeed 
  5. When the connection status is "didPrinterOnline, click "Print and do not release port" your printer should then print
  6. Now, turn the printer off - the status should update to "didPrinterImpossible"
  7. Turn the printer back on, see that the printer status is now "didAccessoryConnectFailure"
  8. At this point I would expect it to be "didPrinterOnline"

  **Video:** https://user-images.githubusercontent.com/45129610/144144933-d20680af-ded4-4849-a791-10733853161f.mp4

  **Expected outcome:**
  The printer should reconnect to the app after a print has completed without releasing the port. We shouldn't need to release the port after a print job, because we are using the StarIoExtManager to secure a connection with the app. 
  
  **Actual outcome:**
  The printer fails the reconnect to the app after a single print job has completed. This means that the user will have to restart their app everytime the printer has been turn off/on.

--------------------------------------  

#### Star Bluetooth printer with an active StarIoExtManager connection won't reconnect after calling disconnect()/connect()

  **Steps to reproduce:**
  1. Manually pair a Star Micronics Bluetooth printer to the iOS device
  2. On the sample app, click the "Scan BT" button to discover the paired BT printer
  3. Click on the discovered BT printer row to navigate to printer details
  4. In the top right, click "Connect" - wait for the connection to succeed 
  5. When the connection status is "didPrinterOnline, click "Print and do not release port" your printer should then print
  5. In the top right, click "Disconnect" this should disconnect the StarIoExtManager instance
  6. Click "Connect" again - observe that the Printer status is now "Initial connection failed"

  **Video:** https://user-images.githubusercontent.com/45129610/144147706-3ad17a28-a3d9-4711-b403-a781abb5fe9d.mp4

  **Expected outcome:**
  We should be able to disconnect/reconnect the printer regardless of if the user has previously printed or not. 
  
  **Actual outcome:**
  If the user has printed without releasing the port - then we can not disconnect and reconnect the StarIoExtManager

--------------------------------------  

#### Star mPOP printer has an empty macAddress in PortInfo object
  **Steps to reproduce:**
  1. Manually pair an mPOP printer
  2. On the sample app, click the "Scan BT" button to discover the paired BT printer
  3. Click on the discovered BT printer row to navigate to printer details
  4. In the printer details, see that the macAddress field is an empty string
  
  **Video:** https://user-images.githubusercontent.com/45129610/144145102-fc8ab567-b5ee-41f8-8fc2-247d58d2422a.mp4

  **Expected outcome:**
  Every BT device has a macAddress, so the PortInfo object should be populated correctly when the mPOP printer is discovered. This is how we uniquely identify printers. 
  
  **Actual outcome:**
  The macAddress field on the PortInfo object is empty when an mPOP printer is discovered
  
## Background Context

Native iOS app location: **src/ios/StarSampleApp.xcodeproj**

Notice that inside the src/ directory we also have androidMain/ iosMain/ and commonMain/ directories. These are apart of Kotlin Multiplatform (https://kotlinlang.org/docs/kmm-overview.html) and allow is to share common business logic between both iOS and Android platforms. Both the iosMain/ and androidMain/ will contain platform specific code - such as access to the StarSdk. While the commonMain/ directory contains code that isn't specific to any operating system. Meaning that we can share the code between platforms. This allows us to have constant feature pairity between both iOS and Android while minimizing the need for two separate dev teams ("iOS/Android devs" become "Mobile devs")

## Set up

### Xcode 13 and an iOS device running atleast iOS 15 will be required. 

You can open the iOS app by navigating to the src/ios/StarSampleApp/ directory and opening the StarSampleApp.xcodeproj file. 

Once you have the project opened in Xcode, assign a signing team and build + run the app on a physical device.

If you happen to see this error, then append the bundle id with some random characters such as "Shopify.StarSampleApp.cxs".

<img width="720" alt="Screen Shot 2021-11-30 at 12 41 02 PM" src="https://user-images.githubusercontent.com/45129610/144099415-59f9323f-3190-4e98-85ad-414a1c01394a.png">

Another error that could appear is below

<img width="540" alt="Screen Shot 2021-11-30 at 12 42 18 PM" src="https://user-images.githubusercontent.com/45129610/144099609-7c73b85e-7898-47df-b280-ce5cb72b1e51.png">

This happens when you first build the framework for a simulator, and then go to run it on a physical device (or vice versa). To fix this, navigate to the build/bin/ios/debugFramework directory and remove both the StarSdk.framework and the StarSdk.framework.dSYM files and rebuild the project. 

