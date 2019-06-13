//
//  API.swift
//  OnTheMap
//
//  Created by Firas Al-Amri on 26/09/1440 AH.
//  Copyright © 1440 Mohammed. All rights reserved.
//

import Foundation


class API {
    
    struct User {
        static var userId = ""
        static var sessionId = ""
        static var objectId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        static let order = "-updatedAt"
        
        case login
        case getStudentLocation
        case getStudentInfo
        case createStudentLocation

        var stringValue: String {
            switch self {
            case .login: return Endpoints.base + "/session"
            
            case .getStudentLocation: return Endpoints.base + "/StudentLocation?order=\(Endpoints.order)"
                
            case .getStudentInfo: return Endpoints.base + "/users/" + User.userId
                
            case .createStudentLocation: return Endpoints.base + "/StudentLocation"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                var newData = data
                if url == Endpoints.login.url {
                    let range = (5..<data.count)
                    newData = data.subdata(in: range)
                }
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        task.resume()
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let account = UdacityAccount(username: username, password: password)
        let body = LoginRequest(udacity: account)
        
        taskForPOSTRequest(url: Endpoints.login.url, responseType: LoginResponse.self, body: body) { (response, error) in
            guard let response = response else {
                completion(false, error)
                return
            }
            User.userId = response.account.key
            User.sessionId = response.session.id
            completion(true, nil)
        }
    }
    
    class func createStudentLocation(student: PostStudent, completion: @escaping (Bool, Error?) -> Void) {
        let body = student
        taskForPOSTRequest(url: Endpoints.createStudentLocation.url, responseType: StudentResponse.self, body: body) { (response, error) in
            guard let response = response else {
                completion(false, error)
                return
            }
            User.objectId = response.objectId
            completion(true, nil)
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                var newData = data
                if url == Endpoints.getStudentInfo.url {
                    let range = (5..<data.count)
                    newData = data.subdata(in: range)
                }
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func getStudentLocation(completion: @escaping ([StudentLocation], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getStudentLocation.url, responseType: StudentLocationResults.self) { (response, error) in
            guard let response = response else {
                completion([], nil)
                return
            }
            completion(response.results, nil)
        }
    }
    
    class func getStudentInfo(completion: @escaping (UserInfo?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getStudentInfo.url, responseType: UserInfo.self) { (response, error) in
            guard let response = response else {
                completion(nil, error)
                return
            }
            completion(response,nil)
        }
    }
    
    class func logout(completion: @escaping (Error?) -> ()) {
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(error)
                return
            }
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            completion(nil)
        }
        task.resume()
    }
}
