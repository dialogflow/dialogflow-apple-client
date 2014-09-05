api-ai-ios-sdk
==============

## Overview

## Building the Demo app.

1. Install (Cocoapods)[http://cocoapods.org/] if you do not have it installed. 
2. Run
```
pod install
```
in the OpenAPIDemo folder
3. Open the project in X


## API Integration
Usage example:

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
