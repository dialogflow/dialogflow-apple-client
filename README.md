iOS SDK for api.ai
==============

[![Build Status](https://travis-ci.org/api-ai/api-ai-ios-sdk.svg)](https://travis-ci.org/api-ai/api-ai-ios-sdk)

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
  ```
  configuration.clientAccessToken = @"YOUR_CLIENT_ACCESS_TOKEN";
  configuration.subscriptionKey = @"YOUR_SUBSCRIPTION_KEY";
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

### 2. Init audio session.
  In the AppDelegate.m, add
  ```Objective-C
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
  ```
  
### 3. Init the SDK.
  In the ```AppDelegate.h```, add ApiAI.h import and property: 
  ```Objective-C
  #import <ApiAI/ApiAI.h>
  
  @property(nonatomic, strong) ApiAI *apiAI;
  ```
  
  In the AppDelegate.m, add
  ```Objective-C
     self.apiAI = [[ApiAI alloc] init];
    
    // Define API.AI configuration here.
    Configuration *configuration = [[Configuration alloc] init];
    configuration.baseURL = [NSURL URLWithString:@"https://api.api.ai/v1"];
    configuration.clientAccessToken = @"YOUR_CLIENT_ACCESS_TOKEN_HERE";
    configuration.subscriptionKey = @"YOUR_SUBSCRIPTION_KEY_HERE";
    
    self.apiAI.configuration = configuration;
  ```

### 4. Perform request using text.
  ```Objective-C
  ...
  // Request using text (assumes that speech recognition / ASR is done using a third-party library, e.g. AT&T)
  AITextRequest *request = (AITextRequest *)[_apiAI requestWithType:AIRequestTypeText];
  request.query = @[@"hello"];
  [request setCompletionBlockSuccess:^(OPRequest *request, id response) {
      // Handle success ...
  } failure:^(OPRequest *request, NSError *error) {
      // Handle error ...
  }];
  
  [_openAPI enqueue:request];

  ```
  
### 5. Or perform request using voice:
  ```Objective-C
  // Request using voice
    AIVoiceRequest *request = (AIVoiceRequest *)[_apiAI requestWithType:AIRequestTypeVoice];
    
    [request setCompletionBlockSuccess:^(AIRequest *request, id response) {
        // Handle success ...
    } failure:^(AIRequest *request, NSError *error) {
        // Handle error ...
    }];
    
    self.voiceRequest = request;
    [_apiAI enqueue:request];
  ```
