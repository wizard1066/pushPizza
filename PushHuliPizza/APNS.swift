//
//  APNS.swift
//  PushHuliPizza
//
//  Created by localadmin on 19.09.18.
//  Copyright © 2018 Mark Lucking. All rights reserved.
//

//import Foundation
//import Security
//
//open class APNS: NSObject, NSURLConnectionDelegate {
//    
//    fileprivate var secIdentity: SecIdentity?
//    fileprivate var session: URLSession!
//    fileprivate var options: Options!
//    
//    public init(identity: SecIdentity, options: Options? = Options()) {
//        super.init()
//        
//        self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
//        
//        self.options = options
//        self.secIdentity = identity
//        
//    }
//    
//    public init?(certificatePath: String, passphrase: String) {
//        super.init()
//        guard let identity = identityFor(certificatePath, passphrase: passphrase) else {
//            return nil
//        }
//        
//        self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
//        
//        self.secIdentity = identity
//        
//    }
//    
//    open func sendPush(
//        tokenList: [String],
//        payload: Data,
//        responseBlock: ((_ apnsResponse: APNS.Response) -> Void)?
//        ) throws {
//        
//        for token in tokenList {
////            let pushURL = self.baseURL(options.development, port: options.port).appendingPathComponent(token)
//            let pushURL = URL(string: "https://api.sandbox.push.apple.com/3/device/")?.appendingPathComponent(token)
//            var request = URLRequest(url: pushURL!)
//            
//            request.httpBody = payload
//            request.httpMethod = "POST"
//            if let topic = options.topic {
//                request.addValue(topic, forHTTPHeaderField: "apns-topic")
//            }
//            if let priority = options.priority {
//                request.addValue("\(priority)", forHTTPHeaderField: "apns-priority")
//            }
//            if let apnsId = options.apnsId {
//                request.addValue(apnsId, forHTTPHeaderField: "apns-id")
//            }
//            if let apnsExpiry = options.expiry {
//                request.addValue("\(apnsExpiry.timeIntervalSince1970.rounded())", forHTTPHeaderField: "apns-expiration")
//            }
//            print("fcuk19092018 request \(request)")
//            
//            session.dataTask(with: request, completionHandler: { (data, response, err) -> Void in
//                guard err == nil else {
//                    print("error \(err!.localizedDescription)")
//                    return
//                }
//                let httpResponse = response as! HTTPURLResponse
//                
//                responseBlock?(Response(deviceToken: token, response: httpResponse, data: data))
//            }).resume()
//        }
//    }
//}
//
////MARK: - NSURLSessionDelegate
//extension APNS: URLSessionDelegate {
//    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        var cert : SecCertificate?
//        SecIdentityCopyCertificate(self.secIdentity!, &cert)//FIXME: User identity.certificate instead
//        let credentials = URLCredential(identity: self.secIdentity!, certificates: [cert!], persistence: .forSession)
//        completionHandler(.useCredential,credentials)
//    }
//}
//
////MARK: - Private Helpers
//extension APNS {
//    
//    fileprivate func baseURL(_ development: Bool, port: Options.Port) -> URL {
//        if development {
//            return URL(string: "https://api.sandbox.push.apple.com:\(port)/3/device/")!
//        } else {
//            return URL(string: "https://api.sandbox.push.apple.com:\(port)/3/device/")!
//        }
//        
//    }
//    
//    fileprivate func identityFor(_ certificatePath: String, passphrase: String) -> SecIdentity? {
//        let PKCS12Data = try? Data(contentsOf: URL(fileURLWithPath: certificatePath))
//        let passPhraseKey : String = kSecImportExportPassphrase as String
//        let options = [passPhraseKey : passphrase]
//        var items : CFArray?
//        let ossStatus = SecPKCS12Import(PKCS12Data! as CFData, options as CFDictionary, &items)
//        guard ossStatus == errSecSuccess else {
//            return nil
//        }
//        let arr = items!
//        if CFArrayGetCount(arr) > 0 {
//            let newArray = arr as [AnyObject]
//            let secIdentity =  newArray[0][kSecImportItemIdentity as String] as! SecIdentity
//            return secIdentity
//        }
//        return nil
//    }
//}
//
////FIXME: Temporary hack until Swift 3.0
//public extension TimeInterval {
//    func rounded() -> Int {
//        return Int(self)
//    }
//}
//
//extension APNS {
//    public struct Options: CustomStringConvertible {
//        public enum Port: Int {
//            case p443 = 443, p2197 = 2197
//        }
//        
//        public var topic: String?
//        public var port: Port = .p443
//        public var expiry: Date?
//        public var priority: Int?
//        public var apnsId: String?
//        public var development: Bool = true
//        
//        public init() {}
//        
//        public var description: String {
//            return "Topic \(self.topic)" +
//                "\nPort \(port.rawValue)" +
//                "\nExpiry \(expiry) \(expiry?.timeIntervalSince1970.rounded())" +
//                "\nPriority \(priority)" +
//                "\nAPNSID \(apnsId)" +
//            "\nDevelopment \(development)"
//        }
//    }
//}
//
//public extension APNS {
//    public enum Error: String, CustomStringConvertible {
//        case payloadEmpty
//        case payloadTooLarge
//        case badTopic
//        case topicDisallowed
//        case badMessageId
//        case badExpirationDate
//        case badPriority
//        case missingDeviceToken
//        case badDeviceToken
//        case deviceTokenNotForTopic
//        case unregistered
//        case duplicateHeaders
//        case badCertificateEnvironment
//        case badCertificate
//        case forbidden
//        case badPath
//        case methodNotAllowed
//        case tooManyRequests
//        case idleTimeout
//        case shutdown
//        case internalServerError
//        case serviceUnavailable
//        case missingTopic
//        
//        
//        public var description: String {
//            switch self {
//            case .payloadEmpty: return "The message payload was empty."
//            case .payloadTooLarge: return "The message payload was too large. The maximum payload size is 4096 bytes."
//            case .badTopic: return "The apns-topic was invalid."
//            case .topicDisallowed: return "Pushing to this topic is not allowed."
//            case .badMessageId: return "The apns-id value is bad."
//            case .badExpirationDate: return "The apns-expiration value is bad."
//            case .badPriority: return "The apns-priority value is bad."
//            case .missingDeviceToken: return "The device token is not specified in the request :path. Verify that the :path header contains the device token."
//            case .badDeviceToken: return "The specified device token was bad. Verify that the request contains a valid token and that the token matches the environment."
//            case .deviceTokenNotForTopic: return "The device token does not match the specified topic."
//            case .unregistered: return "The device token is inactive for the specified topic."
//            case .duplicateHeaders: return "One or more headers were repeated."
//            case .badCertificateEnvironment: return "The client certificate was for the wrong environment."
//            case .badCertificate: return "The certificate was bad."
//            case .forbidden: return "The specified action is not allowed."
//            case .badPath: return "The request contained a bad :path value."
//            case .methodNotAllowed: return "The specified :method was not POST."
//            case .tooManyRequests: return "Too many requests were made consecutively to the same device token."
//            case .idleTimeout: return "Idle time out."
//            case .shutdown: return "The server is shutting down."
//            case .internalServerError: return "An internal server error occurred."
//            case .serviceUnavailable: return "The service is unavailable."
//            case .missingTopic: return "The apns-topic header of the request was not specified and was required. The apns-topic header is mandatory when the client is connected using a certificate that supports multiple topics."
//            }
//            
//        }
//    }
//}
//
//extension APNS {
//    
//    public struct Response {
//        
//        public let apnsId: String?
//        public let serviceStatus: APNS.ServiceStatus
//        public var errorReason: APNS.Error?
//        public let deviceToken: String
//        
//        init(deviceToken: String, response: HTTPURLResponse, data: Data?) {
//            self.deviceToken = deviceToken
//            apnsId = response.allHeaderFields["apns-id"] as? String
//            print("\(response.statusCode.description)")
//            serviceStatus = APNS.ServiceStatus(rawValue: response.statusCode)!
//            
//            if serviceStatus != .success {
//                let json = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0))  as! [String : Any]
//                if let reason = json["reason"] as? String {
//                    errorReason = APNS.Error(rawValue: reason)
//                }
//            }
//        }
//    }
//}
//
//extension APNS {
//    public enum ServiceStatus: Int, CustomStringConvertible {
//        case success = 200
//        case badRequest = 400
//        case badCertitficate = 403
//        case badMethod = 405
//        case deviceTokenIsNoLongerActive = 410
//        case badNotificationPayload = 413
//        case serverReceivedTooManyRequests = 429
//        case internalServerError = 500
//        case serverShutingDownOrUnavailable = 503
//        
//        public var description: String {
//            switch self {
//            case .success: return "Success"
//            case .badRequest: return "Bad request"
//            case .badCertitficate: return "There was an error with the certificate."
//            case .badMethod: return "The request used a bad :method value. Only POST requests are supported."
//            case .deviceTokenIsNoLongerActive: return "The device token is no longer active for the topic."
//            case .badNotificationPayload: return "The notification payload was too large."
//            case .serverReceivedTooManyRequests: return "The server received too many requests for the same device token."
//            case .internalServerError: return "Internal server error"
//            case .serverShutingDownOrUnavailable: return "The server is shutting down and unavailable."
//            }
//        }
//    }
//}
