iOS SDK for api.ai
==============

[![Build Status](https://travis-ci.org/api-ai/api-ai-ios-sdk.svg?branch=master)](https://travis-ci.org/api-ai/api-ai-ios-sdk)

* [Overview](#overview)
* [Prerequisites](#prerequisites)
* [Running the Demo app](#runningthedemoapp)
* [Integrating api.ai into your iOS app](#integratingintoyourapp)

---------------

## <a name="overview"></a>Overview
The API.AI iOS SDK makes it easy to integrate speech recognition with API.AI natural language processing API on iOS devices. API.AI allows using voice commands and integration with dialog scenarios defined for a particular agent in API.AI.

## <a name="prerequisites"></a>Prerequsites
* Create an [API.AI account](http://api.ai)
* Install [CocoaPods](http://cocoapods.org/)


## <a name="runningthedemoapp"></a>Running the Demo app
* Run ```pod update``` in the ApiAiDemo project folder.
* Open **ApiAIDemo.xworkspace** in Xcode.
* In **ViewController -viewDidLoad** insert API key & subscription.
  ```swift
  configuration.clientAccessToken = "YOUR_CLIENT_ACCESS_TOKEN"
  configuration.subscriptionKey = "YOUR_SUBSCRIPTION_KEY"
  ```
  
  Note: an agent in **api.ai** should exist. Keys could be obtained on the agent's settings page.
  
* Define sample intents in the agent.
* Run the app in Xcode.
  Inputs are possible with text and voice (experimental).


## <a name="integratingintoyourapp"></a>Integrating into your app
### 1. Initialize CocoaPods 
  * Run  ```pod install``` in your project folder.
  
  * Update **Podfile** to include:
    ```Podfile
    pod 'ApiAI'
    ```

* Run ```pod update```

### 2. import Objective-C library
  In you project file *-Bridging-Header.h, add
  ```Objective-C
    #import <ApiAI/ApiAI.h>
    #import <ApiAI/AIDefaultConfiguration.h>
  ```

  Optionally:
  ```Objective-C
    ...
    #import <ApiAI/AIVoiceRequestButton.h>
    ...
  ```

  [How to create bridging header](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html)

### 3. Init audio session.
  In the AppDelegate.swift, add
  ```swift
    AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
    AVAudioSession.sharedInstance().setActive(true, error: nil)
  ```
  
### 4. Init the SDK.
  In the ```AppDelegate.swift```, add ApiAI.h import and property: 
  ```swift
    let apiai = ApiAI.sharedApiAI()
  ```
  
  In the AppDelegate.swift, add
  ```swift
    let configuration = AIDefaultConfiguration()
        
    configuration.clientAccessToken = "YOUR_CLIENT_ACCESS_TOKEN_HERE"
    configuration.subscriptionKey = "YOUR_SUBSCRIPTION_KEY_HERE"
    
    self.apiai.configuration = configuration
  ```

### 5. Perform request using text.
  ```Objective-C
  ...
  // Request using text (assumes that speech recognition / ASR is done using a third-party library, e.g. AT&T)
  let request = self.apiai.requestWithType(AIRequestType.Text) as AITextRequest
  request.query = ["Hello"]

  request.setCompletionBlockSuccess({[unowned self] (AIRequest request, AnyObject response) -> Void in
      // Handle success ...
  }, failure: { (AIRequest request, NSError error) -> Void in
      // Handle error ...
  });
  
  ApiAI.sharedApiAI().enqueue(request)
  ```
  
### 6. Or perform request using voice:
  ```swift
  // Request using voice
  let apiai = self.apiai
        
  let request = apiai.requestWithType(AIRequestType.Voice) as AIVoiceRequest
  
  request.setCompletionBlockSuccess({[unowned self] (AIRequest request, AnyObject response) -> Void in
      // Handle success ...
  }, failure: { (AIRequest request, NSError error) -> Void in
      // Handle error ...
  })
  
  apiai.enqueue(request)
  ```
