//
//  Settings.swift
//  ApiAIDemoSwift
//
//  Created by Kuragin Dmitriy on 25/03/15.
//  Copyright (c) 2015 Kuragin Dmitriy. All rights reserved.
//

extension NSString {
    func URL() -> NSURL {
        return NSURL(string: self.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
    }
}

class Settings {
    class var sharedSettings: Settings {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: Settings? = nil
        }
        
        dispatch_once(&Static.onceToken, { () -> Void in
            Static.instance = Settings()
        })
        
        return Static.instance!
    }
    
    var settings : Array<Dictionary<String, String>>;
    
    var selectedSettings : Dictionary<String, String>? {
        didSet {
            if let currentSettings = selectedSettings {
                let apiai = ApiAI.sharedApiAI()
                
                let configuration: AIConfiguration = AIDefaultConfiguration()
                
                configuration.clientAccessToken = currentSettings["clientAccessToken"]
                configuration.baseURL = "https://dev.api.ai/api/".URL()
                
                apiai.lang = currentSettings["lang"]
                
                apiai.configuration = configuration
            }
        }
    }
    
    private init() {
        let path = NSBundle.mainBundle().pathForResource("Settings", ofType: "plist")!
        let data = NSData(contentsOfFile:path)!
        
        var error : NSError? = nil;
        
        var settings: AnyObject? =
        NSPropertyListSerialization.propertyListWithData(data,
            options: 0,
            format: nil,
            error: &error)
        
        assert(error == nil, "Error when load settings")
        
        self.settings = settings as Array<Dictionary<String, String>>
    }
}
