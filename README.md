Objective-C(Cocoa) SDK for api.ai
==============

[![Build Status](https://travis-ci.org/api-ai/api-ai-ios-sdk.svg)](https://travis-ci.org/api-ai/api-ai-ios-sdk)
[![Version](https://img.shields.io/cocoapods/v/ApiAI.svg?style=flat)](http://cocoapods.org/pods/ApiAI)
[![License](https://img.shields.io/cocoapods/l/ApiAI.svg?style=flat)](http://cocoapods.org/pods/ApiAI)
[![Platform](https://img.shields.io/cocoapods/p/ApiAI.svg?style=flat)](http://cocoapods.org/pods/ApiAI)

* [Overview](#overview)
* [Prerequisites](#prerequisites)
* [Running the Demo app](#runningthedemoapp)
* [Integrating api.ai into your iOS app](#integratingintoyourapp)

---------------

## <a name="overview"></a>Overview
The API.AI Objective-C(Cocoa) SDK makes it easy to integrate speech recognition with API.AI natural language processing API on Apple devices. API.AI allows using voice commands and integration with dialog scenarios defined for a particular agent in API.AI.

## <a name="prerequisites"></a>Prerequsites
* Create an [API.AI account](http://api.ai)
* Install [CocoaPods](http://cocoapods.org/)


## <a name="runningthedemoapp"></a>Running the Demo app
* Run ```pod update``` in the ApiAiDemo project folder.
* Open **ApiAIDemo.xworkspace** in Xcode.
* In **ViewController -viewDidLoad** insert API key.
  ```
  configuration.clientAccessToken = @"YOUR_CLIENT_ACCESS_TOKEN";
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

### 2. Init the SDK.
  In the ```AppDelegate.h```, add ApiAI.h import and property:
  ```Objective-C
  #import <ApiAI/ApiAI.h>

  @property(nonatomic, strong) ApiAI *apiAI;
  ```

  In the AppDelegate.m, add
  ```Objective-C
    self.apiAI = [[ApiAI alloc] init];

    // Define API.AI configuration here.
    id <AIConfiguration> configuration = [[AIDefaultConfiguration alloc] init];
    configuration.clientAccessToken = @"YOUR_CLIENT_ACCESS_TOKEN_HERE";

    self.apiAI.configuration = configuration;
  ```

### 3. Perform request.
  ```Objective-C
  ...
  // Request using text (assumes that speech recognition / ASR is done using a third-party library, e.g. AT&T)
  AITextRequest *request = [apiai textRequest];
  request.query = @[@"hello"];
  [request setCompletionBlockSuccess:^(AIRequest *request, id response) {
      // Handle success ...
  } failure:^(AIRequest *request, NSError *error) {
      // Handle error ...
  }];

  [_apiAI enqueue:request];

  ```
