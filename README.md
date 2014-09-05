api-ai-ios-sdk
==============

iOS SDK for API.AI

Usage example:

    <pre><code>self.openAPI = [[OPOpenAPI alloc] init];
...
///text request
OPTextRequest *request = (OPTextRequest *)[_openAPI requestWithType:OPRequestTypeText];
request.query = @[@"hello"];
[request setCompletionBlockSuccess:^(OPRequest *request, id responce) {
    ///...
} failure:^(OPRequest *request, NSError *error) {
    ///...
}];
[_openAPI enqueue:request];

...
///voice request
OPTextRequest *request = (OPTextRequest *)[_openAPI requestWithType:OPRequestTypeText];
request.query = @[@"hello"];
[request setCompletionBlockSuccess:^(OPRequest *request, id responce) {
    ///...
} failure:^(OPRequest *request, NSError *error) {
    ///...
}];
[_openAPI enqueue:request];</code></pre> 
