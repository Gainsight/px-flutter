import Flutter
import UIKit
import PXKit

enum GainsightPXMethod: String {
    case initialise
    case customEvent
    case customEventWithProperties
    case screenEventWithTitle
    case screenEventWithTitleAndProperties
    case screenEventWithProperties
    case identifyWithID
    case identifyWithUser
    case identifyWithUserAndAccount
    case setGlobalContext
    case hasGlobalKey
    case removeGlobalContextKeys
    case flush
    case enable
    case disable
    case trackTaps
    case enterEditing
    case exitEditing
    case flutterViewChanged
    case scrollStateChanged
    case reset
}

enum FlutterMethod: String {
    case getViewPosition
    case getViewAtPosition
    case createDOMStructure
    case onEngagementCallback
}

public class SwiftGainsightpxFlutterPlugin: NSObject, FlutterPlugin {

    typealias GainsightPXCallback = (status: Bool, message: String?, properties: [String: Any]?)
    var channel: FlutterMethodChannel

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "gainsightpx", binaryMessenger: registrar.messenger())
        let instance = SwiftGainsightpxFlutterPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public init(channel: FlutterMethodChannel) {
        self.channel = channel
        super.init()
        GainsightPX.shared.uiMapperConsumer = self
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let error = {
            print("SDK ERROR: \(FlutterMethodCallError.invalidArguments.localizedDescription)")
        }
        switch call.method {
        case GainsightPXMethod.initialise.rawValue:
            call.initiliseParams({ (params) in
                initialise(params: params, result: result)
            }, error)
        case GainsightPXMethod.customEvent.rawValue:
            call.customEvent({ (name) in
                customEvent(name: name, result: result)
            }, error)
        case GainsightPXMethod.customEventWithProperties.rawValue:
            call.customEventProperties({ (name, properties) in
                customEvent(name: name, properties: properties, result: result)
            }, error)
        case GainsightPXMethod.screenEventWithTitle.rawValue:
            call.screenName({ (name) in screenEvent(screenName: name, result: result)}, error)
        case GainsightPXMethod.screenEventWithTitleAndProperties.rawValue:
            call.screenNameWithProperties({ (name, properties) in
                screenEvent(screenName: name, properties: properties, result: result)
            }, error)
        case GainsightPXMethod.screenEventWithProperties.rawValue:
            call.screenEventWithProperties({ (screenName, screenClass, properties) in
                screenEvent(screenName: screenName, screenClass: screenClass, properties: properties, result: result)
            }, error)
        case GainsightPXMethod.identifyWithID.rawValue:
            call.userID({ (userID) in
                identify(userID: userID, result: result)
            }, error)
        case GainsightPXMethod.identifyWithUser.rawValue:
            call.user({ (user) in
                identify(user: user, result: result)
            }, error)
        case GainsightPXMethod.identifyWithUserAndAccount.rawValue:
            call.identify({ (user, account) in
                identify(user: user, account: account, result: result)
            }, error)
        case GainsightPXMethod.setGlobalContext.rawValue:
            call.contextMap({ (map) in
                setGlobalContext(map: map, result: result)
            }, error)
        case GainsightPXMethod.hasGlobalKey.rawValue:
            call.contextCheckKey({ (key) in
                hasGlobalKey(key: key, result: result)
            }, error)
        case GainsightPXMethod.removeGlobalContextKeys.rawValue:
            call.removeContextKeys({ (keys) in
                removeGlobalContextKeys(keys: keys, result: result)
            }, error)
        case GainsightPXMethod.flush.rawValue:
            flush(result: result)
        case GainsightPXMethod.enable.rawValue:
            enable(result: result)
        case GainsightPXMethod.disable.rawValue:
            disable(result: result)
        case GainsightPXMethod.trackTaps.rawValue:
            call.trackTaps({ (viewElements, points) in
                trackTaps(viewElements: viewElements, points: points, result: result)
            }, error)
        case GainsightPXMethod.enterEditing.rawValue:
            call.editingURL({ (url) in
                enterEditing(url: url, result: result)
            }, error)
        case GainsightPXMethod.exitEditing.rawValue:
            exitEditing(result: result)
        case GainsightPXMethod.flutterViewChanged.rawValue, GainsightPXMethod.scrollStateChanged.rawValue:
            break
        case GainsightPXMethod.reset.rawValue:
            GainsightPX.shared.reset()
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func initialise(params: [String: Any], result: @escaping FlutterResult) {
        var gCallback: GainsightPXCallback = (status: true, nil, nil)
        let apiKey = params["apiKey"] as! String
        let key = apiKey + "&2"
        let config = AnalyticsConfigurations(apiKey: key)
        if let enable = params["enable"] as? Bool {
            config.enabled = enable
        }
        if let flushInterval = params["flushInterval"] as? Double {
            config.flushInterval = flushInterval
        }
        if let flushQueueSize = params["flushQueueSize"] as? Int {
            config.flushQueueSize = flushQueueSize
        }
        if let maxQueueSize = params["maxQueueSize"] as? Int {
            config.maxQueueSize = maxQueueSize
        }
        if let trackApplicationLifeCycleEvents = params["trackApplicationLifeCycleEvents"] as? Bool {
            config.trackApplicationLifecycleEvents = trackApplicationLifeCycleEvents
        }
        if let shouldTrackTapEvents = params["shouldTrackTapEvents"] as? Bool {
            config.shouldTrackTapEvents = shouldTrackTapEvents
        }
        if let reportTrackingIssues = params["reportTrackingIssues"] as? Bool {
            config.reportTrackingIssues = reportTrackingIssues
        }
        config.recordScreenViews = false
        if let proxy = params["proxy"] as? String {
            config.connection = Connection(connectionMode: ConnectionMode.custom(host: proxy));
        } else if let host = params["host"] as? String {
            switch host {
            case "eu":
                config.connection.connectionMode = ConnectionMode.eu
            case "us2":
                config.connection.connectionMode = ConnectionMode.us2
            default:
                config.connection.connectionMode = ConnectionMode.us
            }
      }
        if let enableLogs = params["enableLogs"] as? Bool {
            GainsightPX.debugLogs(enable: enableLogs)
        }
        config.currentWindow = UIApplication.shared.windows.first
        let isEngagementCallBackListenerAdded = params["engagementCallback"] as? Bool ?? false
        
        GainsightPX.shared.initialise(configurations: config, completionBlock: { (_, properties, error) in
            gCallback.status = (error == nil)
            gCallback.properties = properties
            gCallback.message = error?.localizedDescription
        }, callback: isEngagementCallBackListenerAdded ? onEngagementCallBack : nil)
    
        handleCallback(result: result,
                       functionName: GainsightPXMethod.initialise.rawValue,
                       error: gCallback)
    }

    private func onEngagementCallBack(callbackModel: EngagementCallBackModel?, error: Error?) -> Bool {
        let params: [String: Any] = callbackModel?.toJSON() ?? [:];
        channel.invokeMethod(FlutterMethod.onEngagementCallback.rawValue, arguments: params);
        return true
    }
    
    private func customEvent(name: String, result: @escaping FlutterResult) {
        var gCallback: GainsightPXCallback = (status: true, nil, nil)
        GainsightPX.shared.custom(event: name) { (_, properties, error) in
            gCallback.status = false
            gCallback.message = error?.localizedDescription
            gCallback.properties = properties
        }
        handleCallback(result: result,
                       functionName: GainsightPXMethod.customEvent.rawValue,
                       error: gCallback)
    }

    private func customEvent(name: String, properties: [String: Any]?, result: @escaping FlutterResult) {
        var gCallback: GainsightPXCallback = (status: true, nil, nil)
        GainsightPX.shared.custom(event: name, properties: properties) { (_, properties, error) in
            gCallback.status = false
            gCallback.message = error?.localizedDescription
            gCallback.properties = properties
        }
        handleCallback(result: result,
                       functionName: GainsightPXMethod.customEventWithProperties.rawValue,
                       error: gCallback)
    }

    private func screenEvent(screenName: String, result: @escaping FlutterResult) {
        var gCallback: GainsightPXCallback = (status: true, nil, nil)
        GainsightPX.shared.screen(title: screenName) { (_, properties, error) in
            gCallback.status = false
            gCallback.message = error?.localizedDescription
            gCallback.properties = properties
        }
        handleCallback(result: result,
                       functionName: GainsightPXMethod.screenEventWithTitle.rawValue,
                       error: gCallback)
    }

    private func screenEvent(screenName: String, properties: [String: Any]?, result: @escaping FlutterResult) {
        var gCallback: GainsightPXCallback = (status: true, nil, nil)
        GainsightPX.shared.screen(title: screenName, properties: properties) { (_, properties, error) in
            gCallback.status = false
            gCallback.message = error?.localizedDescription
            gCallback.properties = properties
        }
        handleCallback(result: result,
                       functionName: GainsightPXMethod.screenEventWithTitleAndProperties.rawValue,
                       error: gCallback)
    }

    private func screenEvent(screenName: String, screenClass: String?, properties: [String: Any]?, result: @escaping FlutterResult) {
        var gCallback: GainsightPXCallback = (status: true, nil, nil)
        let event = ScreenEvent(screenName: screenName, screenClass: screenClass)
        GainsightPX.shared.screen(screen: event, properties: properties) { (_, properties, error) in
            gCallback.status = false
            gCallback.message = error?.localizedDescription
            gCallback.properties = properties
        }
        handleCallback(result: result,
                       functionName: GainsightPXMethod.screenEventWithProperties.rawValue,
                       error: gCallback)
    }

    private func identify(userID: String, result: @escaping FlutterResult) {
        var gCallback: GainsightPXCallback = (status: true, nil, nil)
        GainsightPX.shared.identify(userId: userID) { (_, properties, error) in
            gCallback.status = false
            gCallback.message = error?.localizedDescription
            gCallback.properties = properties
        }
        handleCallback(result: result,
                       functionName: GainsightPXMethod.identifyWithID.rawValue,
                       error: gCallback)
    }

    private func identify(user: [String: Any], result: @escaping FlutterResult) {
        var gCallback: GainsightPXCallback = (status: true, nil, nil)
        let userObject = fetchUser(params: user)
        GainsightPX.shared.identify(user: userObject) { (_, properties, error) in
            gCallback.status = false
            gCallback.message = error?.localizedDescription
            gCallback.properties = properties
        }
        handleCallback(result: result,
                       functionName: GainsightPXMethod.identifyWithUser.rawValue,
                       error: gCallback)
    }

    private func identify(user: [String: Any], account: [String: Any]?, result: @escaping FlutterResult) {
        var gCallback: GainsightPXCallback = (status: true, nil, nil)
        let userObject = fetchUser(params: user)
        let account = fetchAccount(params: account)
        GainsightPX.shared.identify(user: userObject, account: account) { (_, properties, error) in
            gCallback.status = false
            gCallback.message = error?.localizedDescription
            gCallback.properties = properties
        }
        handleCallback(result: result,
                       functionName: GainsightPXMethod.identifyWithUserAndAccount.rawValue,
                       error: gCallback)
    }

    private func setGlobalContext(map: [String: Any]?, result: @escaping FlutterResult) {
        let gCallback: GainsightPXCallback = (status: true, nil, nil)
        if let contextMap = map {
            var context = GainsightPX.shared.globalContext
            if context == nil {
                context = GlobalContext()
            }
            for (key, value) in contextMap {
                if let value = value as? String {
                    context = context?.setString(key: key, value: value)
                } else if let boolValue = value as? Bool {
                    context = context?.setBoolean(key: key, value: boolValue)
                } else if let doubelValue = value as? Double {
                    context = context?.setDouble(key: key, value: doubelValue)
                }
            }
            GainsightPX.shared.globalContext(context: context)
        } else {
            GainsightPX.shared.globalContext(context: nil)
        }
        handleCallback(result: result,
                       functionName: GainsightPXMethod.setGlobalContext.rawValue,
                       error: gCallback)
    }

    private func hasGlobalKey(key: String?, result: @escaping FlutterResult) {
        let context = GainsightPX.shared.globalContext
        if let context = context, let key = key {
            sendResult(result: result, content: context.hasKey(key: key))
        } else {
            sendResult(result: result, content: false)
        }
    }

    private func removeGlobalContextKeys(keys: [String]?, result: @escaping FlutterResult) {
        let gCallback: GainsightPXCallback = (status: true, nil, nil)
        if let keys = keys, let context = GainsightPX.shared.globalContext {
            context.removeKeys(keys: keys)
        }
        handleCallback(result: result, functionName: GainsightPXMethod.removeGlobalContextKeys.rawValue, error: gCallback)
    }

    private func flush(result: @escaping FlutterResult) {
        var gCallback: GainsightPXCallback = (status: true, nil, nil)
        GainsightPX.shared.flush { (name, properties, error) in
            gCallback.status = false
            gCallback.message = error?.localizedDescription
            gCallback.properties = properties
        }
        handleCallback(result: result,
                       functionName: GainsightPXMethod.flush.rawValue,
                       error: gCallback)
    }

    private func enable(result: @escaping FlutterResult) {
        GainsightPX.enable()
        handleCallback(result: result,
                       functionName: GainsightPXMethod.enable.rawValue,
                       error: (status: true, nil, nil))
    }

    private func disable(result: @escaping FlutterResult) {
        GainsightPX.disable()
        handleCallback(result: result,
                       functionName: GainsightPXMethod.disable.rawValue,
                       error: (status: true, nil, nil))
    }

    private func trackTaps(viewElements: [[String : Any]], points: Int, result: @escaping FlutterResult) {
        let gCallback: GainsightPXCallback = (status: true, nil, nil)
        GainsightPX.shared.trackTap(viewElements: viewElements, points: points)
        handleCallback(result: result,
                       functionName: GainsightPXMethod.trackTaps.rawValue,
                       error: gCallback)
    }

    private func enterEditing(url: String, result: @escaping FlutterResult) {
        var gCallback: GainsightPXCallback = (status: true, nil, nil)
        if let editorURL = URL(string: url) {
            GainsightPX.shared.enterEditingMode(url: editorURL)
        } else {
            gCallback.status = false
            gCallback.message = "Invalid URL"
        }
        handleCallback(result: result,
                       functionName: GainsightPXMethod.enterEditing.rawValue,
                       error: gCallback)
    }
    
    private func exitEditing(result: @escaping FlutterResult) {
        GainsightPX.shared.exitEditingMode()
        handleCallback(result: result,
                       functionName: GainsightPXMethod.exitEditing.rawValue,
                       error: (status: true, nil, nil))
    }
    
    // MARK: - Support Methods
    private func fetchUser(params: [String: Any]) -> User {
        let ide = params["ide"] as! String
        let user = User(userId: ide)
        var attributes: [String: Any] = [:]

        for key in params.keys {
            let value = params[key]
            if user.responds(to: NSSelectorFromString(key)) {
                user.setValue(value, forKey: key)
            } else {
                attributes[key] = value
            }
        }
        if attributes.count > 0 {
            user.customAttributes = attributes
        }
        return user
    }

    private func fetchAccount(params: [String: Any]?) -> Account? {
        if let params = params, let ide = params["id"] as? String {
            let account = Account(id: ide)
            var attributes: [String: Any] = [:]

            for key in params.keys {
                if key == "id" {continue}
                let value = params[key]
                if account.responds(to: NSSelectorFromString(key)) {
                    account.setValue(value, forKey: key)
                } else {
                    attributes[key] = value
                }
            }
            if attributes.count > 0 {
                account.customAttributes = attributes
            }
            return account
        } else {
            return nil
        }
    }

    //MARK: - Callback Methods
    private func handleCallback(result: @escaping FlutterResult, functionName: String, error: GainsightPXCallback) {
        var userInfo: [String: Any?] = ["status": error.status]
        if !error.status {
            userInfo = ["methodName": functionName,
                        "exceptionMessage": error.message,
                        NSLocalizedDescriptionKey: error.message]
            if let properties = error.properties {
                userInfo["params"] = properties
            }
            sendResult(result: result, content: FlutterError(code: "0", message: error.message, details: userInfo))
        } else {
            sendResult(result: result, content: userInfo)
        }
    }

    private func sendResult(result: @escaping FlutterResult, content: Any) {
        DispatchQueue.main.async {
            result(content)
        }
    }
}

extension SwiftGainsightpxFlutterPlugin: UIMapperConsuming {
    
    public var isCrossPlatform: Bool {
        let window = GainsightPX.shared.analyticsConfigurations.currentWindow
        let topVC = UIApplication.shared.topViewController(base: window?.rootViewController)
        return topVC is FlutterViewController
    }
    
    public func getViewPosition(builder: TreeBuilding, completion: @escaping (([CGRect]?) -> Void)) {
        channel.invokeMethod(FlutterMethod.getViewPosition.rawValue,
                             arguments: builder.build()) { (result) in
            DispatchQueue.main.async {
                if let rectJSONs = result as? [[String: Any]] {
                    let rects: [CGRect] = rectJSONs.map {$0.toRect}.compactMap{$0}
                    completion(rects)
                } else {
                    completion(nil)
                }
            }
        }
    }

    public func getViewAtPosition(screenPosition: CGPoint, completion: @escaping ((TreeBuilding?) -> Void)) {
        let methodArguments = ["x": screenPosition.x, "y": screenPosition.y];
        channel.invokeMethod(FlutterMethod.getViewAtPosition.rawValue,
                             arguments: methodArguments) { (result) in
            DispatchQueue.main.async {
                if let result = result as? [String: Any] {
                    completion(TreeBuilder(params: result))
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    public func createDOMStructure(completion: @escaping ((TreeBuilding?) -> Void)) {
        channel.invokeMethod(FlutterMethod.createDOMStructure.rawValue,
                             arguments: nil) { (result) in
            if let response = result as? [String: Any] {
                completion(TreeBuilder(params: ["componentTree": [response], "id": "flutter"]))
            } else {
                completion(nil)
            }
        }
    }

    public func getFilterClass() -> String {
        let window = GainsightPX.shared.analyticsConfigurations.currentWindow
        let topVC = UIApplication.shared.topViewController(base: window?.rootViewController)
        guard topVC is FlutterViewController, let view = topVC?.view else {
            return ""
        }
        return NSStringFromClass(type(of: view))
    }

}

class TreeBuilder: TreeBuilding {

    var params: [String: Any]

    init(params: [String: Any]) {
        self.params = params
    }

    func build() -> [String : Any] {
        return params
    }
}

extension UIApplication {
    
    func topViewController(base: UIViewController?) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
