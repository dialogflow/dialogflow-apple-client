api-ai-ios-sdk
==============

## Overview

## Prerequsites
Create an [API.AI account](https://api.ai)

## API Integration
### Using CocoaPods
pod install 

### Usage example:

1. Init the SDK.
  ```
  self.openAPI = [[OPOpenAPI alloc] init];
  ```

2. Perform request using text.
  ```
  ...
  // Request using text (assumes that speech recognition / ASR is done using a third-party library, e.g. AT&T
  OPTextRequest *request = (OPTextRequest *)[_openAPI requestWithType:OPRequestTypeText];
  request.query = @[@"hello"];
  [request setCompletionBlockSuccess:^(OPRequest *request, id response) {
      // HANDLE RESPONSE ...
  } failure:^(OPRequest *request, NSError *error) {
      // HANDLE ERROR ...
  }];
  [_openAPI enqueue:request];

  ```

3. Or perform request using voice:
  ```
  // Request using voice
  OPTextRequest *request = (OPTextRequest *)[_openAPI requestWithType:OPRequestTypeText];
  request.query = @[@"hello"];
  [request setCompletionBlockSuccess:^(OPRequest *request, id response) {
      // HANDLE RESPONSE ...
  } failure:^(OPRequest *request, NSError *error) {
      // HANDLE ERRORS...
  }];
  [_openAPI enqueue:request];
  ```

## Building the Demo app.
1. Install [CocoaPods](http://cocoapods.org/) if you do not have it installed. 
2. In the OpenAPIDemo folder, run
  ```
  pod install
  ```
3. Open the project in X
