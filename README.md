# UHShield App

<div align="center">
<a href="https://devpost.com/software/uhshield">DevPost</a>
</div>

# TABLE OF CONTENTS
***
* [OVERVIEW](#overview)
* [INSTALLATION GUIDE](#installation-guide)

<br/>

# OverView
***
This is a powerful mobile iOS-platform app that allows users(sponsor and receptionists) to manage UH building access. 

* Sponsors can create new events and manage their events. They can also invite guests via sending emails with our APP.

* Guests will get the invitation email with a QR-Code, and they can use it to check-in.

* Receptionists can scan the QR-Code guest provided, and the system will automatically finish check-in, and then they only need to assign the badge to the guest. The badge has an embedded magnetic strip used for entry control, and it is limited to operating the elevator. When guests leave, they should give back their badges to the receptionists, and they can remove the binding between the guest and the badge through our APP.

* We also provide the conventional check-in workflow in case of that the guests do not bring valid QR-Codes.

# Installation Guide
***
### Precondition: 
Users have to install XCode under MacOS envrionment since it is a iOS platform application. We strongly recommend running our app on the latest version of XCode. 

Having a ios mobile device is important for testing all features in the app(some feature are not supported on the XCode simulator)
### Step 1:
Clone the repo to your local computer, and open the project "UHShield.xcworkspace".
<p><img class="ui large image" src="../main/images/Step1.png"/ ></p>

### Step 2:
Open the Performance of XCode to add your AppleID.(You can find it by clicking XCode on the top tool bar)
And then set up your personal account.
<p><img class="ui large image" src="../main/images/Step2.png"/ ></p>

### Step 3:
UHShield in XCode and change the Team and Bundle Identifier. Choose the account you just set up, and add a suffix to make the bundle Identifier unique(like ".XXXXX", the dot is necessary).
<p><img class="ui large image" src="../main/images/Step3.png"/ ></p>

### Step 4: 
Connect your iOS device with your computer. Make sure the version of Deployment target is lower or equal than the iOS version on your mobile device.
<p><img class="ui large image" src="../main/images/Step4.png"/ ></p>

### Finished set up, let run the app on your mobile device!
If you do not have an ios platform mobile device, you can run the app in XCode build-in simulator(No need to set up, can simply choose and run).
However, partial functionalities is not supported on XCode simulator(Scan QR Code and Sending Email).

### Note
After install the APP, you can either log in with exist account or register a new one.

* After Register, you will be automatically set to be SPONSOR rule. 
* If you want to try the functionality of RECEPTION, you can log in using account below and select your workplace building at Me Tab to start.

  ** username: reception@test.com  
  ** password: 123456
