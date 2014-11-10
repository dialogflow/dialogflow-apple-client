api-ai-ios-sdk
==============

## Overview
The API.AI iOS SDK makes it easy to integrate speech recognition with API.AI natural language processing API on iOS devices. API.AI allows using voice commands and integration with dialog scenarios defined for a particular agent in API.AI.

## Prerequsites
* Create an [API.AI account](http://api.ai)
* Install [CocoaPods](http://cocoapods.org/)


## Running the Demo App
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


## Integrating into your app
* Run ```pod install``` in your project folder.
* Update **Podfile** to include:
    ```
    pod 'ApiAI', :path => '../'
    ```
    or
    ```
    pod 'ApiAI', :git => 'git@github.com:speaktoit/api-ai-ios-sdk.git'
    ```
  Regular pod definitions are coming soon.
* Run ```pod update```
* Add code to your app:
1. Init the SDK.
  ```
  @property(nonatomic, strong) ApiAI *openAPI;
  ```
  
  ```
     self.openAPI = [[ApiAI alloc] init];
    
    // Define API.AI configuration here.
    Configuration *configuration = [[Configuration alloc] init];
    configuration.baseURL = [NSURL URLWithString:@"https://api.api.ai/v1"];
    configuration.clientAccessToken = @"YOUR_CLIENT_ACCESS_TOKEN_HERE";
    configuration.subscriptionKey = @"YOUR_SUBSCRIPTION_KEY_HERE";
    
    self.openAPI.configuration = configuration;
  ```

2. Perform request using text.
  ```
  ...
  // Request using text (assumes that speech recognition / ASR is done using a third-party library, e.g. AT&T
  AITextRequest *request = (AITextRequest *)[_openAPI requestWithType:AIRequestTypeText];
  request.query = @[@"hello"];
  [request setCompletionBlockSuccess:^(OPRequest *request, id response) {
      // Handle success ...
  } failure:^(OPRequest *request, NSError *error) {
      // Handle error ...
  }];
  
  [_openAPI enqueue:request];

  ```

3. Or perform request using voice:
  ```
  // Request using voice
    AIVoiceRequest *request = (AIVoiceRequest *)[_openAPI requestWithType:AIRequestTypeVoice];
    
    [request setCompletionBlockSuccess:^(AIRequest *request, id response) {
        // Handle success ...
    } failure:^(AIRequest *request, NSError *error) {
        // Handle error ...
    }];
    
    self.voiceRequest = request;
    [_openAPI enqueue:request];
  ```
