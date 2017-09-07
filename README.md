# AIConnection
Some time while writing your iOS application you see it crashes when our mobile data or wifi is not connected.then we start checking through out the application and find out the points , where it is crashing without internet connection and start doing need full things.what if you stop users to use any activity on your application until he/she is not connected to internet.Yes this class helps you to achieve this,You simply need to add this class in your XCode project and initialize it in your Appdelegate.Thats it, It will keep traking your connection and presents a controller if connection is lost.You can modify it according to your need and show whatever message you want.



Simply drag and drop AIConnection.swift file in you project and write this line of code in your project's Appdelegate.

AIConnection.sharedInstance.startEngine()

That's it here you go...

Right now this code is written for swift 3 only so please avoid to use in lower versions of swift.
