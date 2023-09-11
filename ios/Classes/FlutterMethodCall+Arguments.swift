//
//  FlutterMethodCall+Arguments.swift
//  gainsightpx
//
//  Created by Ramineni Sunanda on 17/08/20.
//

import Foundation
import Flutter

extension Dictionary {
    
    var toRect: CGRect? {
        let json = self as? [String: Any]
        if let rectX = json?["x"] as? Double,
            let rectY = json?["y"] as? Double,
            let rectW = json?["width"] as? Double,
            let rectH = json?["height"] as? Double {
            return CGRect(x: rectX, y: rectY, width: rectW, height: rectH)
        }
        return nil
    }
}

extension FlutterMethodCall {
    func initiliseParams(_ completion: (([String: Any]) -> Void), _ errorCompletion: (() -> Void)) {
        guard let params = arguments as? [String: Any] else {
            errorCompletion()
            return
        }
        completion(params)
    }
        
    func customEvent(_ completion: ((String) -> Void), _ errorCompletion: (() -> Void)) {
        guard let params = arguments as? [String: Any],
            let name = params["event"] as? String else {
            errorCompletion()
            return
        }
        completion(name)
    }
    
    func customEventProperties(_ completion: ((String, [String: Any]?) -> Void), _ errorCompletion: (() -> Void)) {
        guard let params = arguments as? [String: Any],
            let name = params["event"] as? String else {
            errorCompletion()
            return
        }
        completion(name, params["properties"] as? [String: Any])
    }
    
    func screenName(_ completion: ((String) -> Void), _ errorCompletion: (() -> Void)) {
        guard let params = arguments as? [String: Any],
            let screenName = params["screenName"] as? String else {
            errorCompletion()
            return
        }
        completion(screenName)
    }
    
    func screenNameWithProperties(_ completion: ((String, [String: Any]?) -> Void), _ errorCompletion: (() -> Void)) {
        guard let params = arguments as? [String: Any],
            let screenName = params["screenName"] as? String else {
            errorCompletion()
            return
        }
        completion(screenName, params["properties"] as? [String: Any])
    }
    
    func screenEventWithProperties(_ completion: ((String, String?, [String: Any]?) -> Void), _ errorCompletion: (() -> Void)) {
        guard let params = arguments as? [String: Any],
            let screenName = params["screenName"] as? String else {
            errorCompletion()
            return
        }
        completion(screenName, params["screenClass"] as? String, params["properties"] as? [String: Any])
    }
    
    func userID(_ completion: ((String) -> Void), _ errorCompletion: (() -> Void)) {
        guard let params = arguments as? [String: Any], let userID = params["userID"] as? String else {
            errorCompletion()
            return
        }
        completion(userID)
    }
    
    func user(_ completion: (([String: Any]) -> Void), _ errorCompletion: (() -> Void)) {
        guard let params = arguments as? [String: Any], let user = params["user"] as? [String: Any] else {
            errorCompletion()
            return
        }
        completion(user)
    }
    
    func identify(_ completion: (([String: Any], [String: Any]?) -> Void), _ errorCompletion: (() -> Void)) {
        guard let params = arguments as? [String: Any],
            let user = params["user"] as? [String: Any] else {
            errorCompletion()
            return
        }
        completion(user, params["account"] as? [String: Any])
    }
    
    func removeContextKeys(_ completion: (([String]) -> Void), _ errorCompletion: (() -> Void)) {
        guard let params = arguments as? [String: Any], let keys = params["keys"] as? [String] else {
            errorCompletion()
            return
        }
        completion(keys)
    }
    
    func contextCheckKey(_ completion: ((String) -> Void), _ errorCompletion: (() -> Void)) {
        guard let params = arguments as? [String: Any], let key = params["key"] as? String else {
            errorCompletion()
            return
        }
        completion(key)
    }
    
    func contextMap(_ completion: (([String: Any]?) -> Void), _ errorCompletion: (() -> Void)) {
        guard let params = arguments as? [String: Any] else {
            errorCompletion()
            return
        }
        completion(params["params"] as? [String: Any])
    }
    
    func trackTaps(_ completion: (([[String: Any]], Int) -> Void), _ errorCompletion: (() -> Void)) {
        guard let params = arguments as? [String: Any],
            let viewElements = params["viewElements"] as? [[String: Any]],
            let points = params["points"] as? Int else {
            errorCompletion()
            return
        }
        completion(viewElements, points)
    }
    
    func editingURL(_ completion: ((String) -> Void), _ errorCompletion: (() -> Void)) {
        guard let params = arguments as? [String: Any],
            let url = params["url"] as? String else {
            errorCompletion()
            return
        }
        completion(url)
    }
    
    func enableEngagements(_ completion: ((Bool) -> Void), _ errorCompletion: (() -> Void)) {
        guard let params = arguments as? [String: Any],
            let enableEngagements = params["enable"] as? Bool else {
            errorCompletion()
            return
        }
        completion(enableEngagements)
    }

}
