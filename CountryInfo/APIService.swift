//
//  APIService.swift
//  CountryInfo
//
//  Created by Haryanto Salim on 08/07/20.
//  Copyright © 2020 Haryanto Salim. All rights reserved.
//

import Foundation
import UIKit

class APIService: NSObject {
    
    let query = "keyVUKyXUU2ztfFqJ"
    lazy var endPoint: String = {
        return "https://api.airtable.com/v0/appK5bnJrs54Xj2Bs/Stories?sort[0][field]=story_id&api_key=\(self.query)"
    }()
    
    func basicAuthTrip(didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.previousFailureCount < 3 {
            let credential = URLCredential(user: "bbbb", password: "BBBB", persistence: .forSession)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }

    func digestAuthTrip(didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.previousFailureCount < 3 {
            let credential = URLCredential(user: "dddd", password: "DDDD", persistence: .forSession)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        // Look for specific authentication challenges and dispatch those to various helper methods.
        //
        // IMPORTANT: It's critical that, if you get a challenge you weren't expecting,
        // you resolve that challenge with `.performDefaultHandling`.

        switch (challenge.protectionSpace.authenticationMethod, challenge.protectionSpace.host) {
            case (NSURLAuthenticationMethodHTTPBasic, "httpbin.org"):
                self.basicAuthTrip(didReceive: challenge, completionHandler: completionHandler)
            case (NSURLAuthenticationMethodHTTPDigest, "httpbin.org"):
                self.digestAuthTrip(didReceive: challenge, completionHandler: completionHandler)
            default:
                completionHandler(.performDefaultHandling, nil)
        }
    }
    
    func getDataWith(completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        
        let urlString = endPoint
        
        guard let url = URL(string: urlString) else { return completion(.Error("Invalid URL, we can't update your feed")) }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    guard let itemsJsonArray = json["records"] as? [[String: AnyObject]] else {
                        return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
                    }
                    DispatchQueue.main.async {
                        completion(.Success(itemsJsonArray))
                    }
                }
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
        }.resume()
    }
    
    func getDataWith(definedEndPoint: String, itemsJsonArrayString: String, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        
        let urlString = "\(definedEndPoint)\(self.query)"
        
        guard let url = URL(string: urlString) else { return completion(.Error("Invalid URL, we can't update your feed")) }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    guard let itemsJsonArray = json[itemsJsonArrayString] as? [[String: AnyObject]] else {
                        return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
                    }
                    DispatchQueue.main.async {
                        completion(.Success(itemsJsonArray))
                    }
                }
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
        }.resume()
    }
    
    func getAvailableProvinces(iso: String, completion: @escaping (Result<[[String: AnyObject]]>) -> Void){
        let headers = [
            "x-rapidapi-host": "covid-19-statistics.p.rapidapi.com",
            "x-rapidapi-key": "866f0006a2msh5b7e6d519a7d701p1e2323jsn173d9ad99dab"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://covid-19-statistics.p.rapidapi.com/provinces?iso=\(iso)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
                completion(.Error(error!.localizedDescription))
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse as Any)
                
                guard let data = data else {return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))}
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                        guard let itemsJsonArray = json["data"] as? [[String: AnyObject]] else {
                            return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
                        }
                        DispatchQueue.main.async {
                            completion(.Success(itemsJsonArray))
                        }
                    }
                } catch let error {
                    return completion(.Error(error.localizedDescription))
                }
            }
        })

        dataTask.resume()
    }


    func getAvailableRegions(completion: @escaping (Result<[[String: AnyObject]]>) -> Void){
        let headers = [
            "x-rapidapi-host": "covid-19-statistics.p.rapidapi.com",
            "x-rapidapi-key": "866f0006a2msh5b7e6d519a7d701p1e2323jsn173d9ad99dab"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://covid-19-statistics.p.rapidapi.com/regions")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
                completion(.Error(error!.localizedDescription))
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse as Any)
                
                guard let data = data else {return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))}
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                        guard let itemsJsonArray = json["data"] as? [[String: AnyObject]] else {
                            return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
                        }
                        DispatchQueue.main.async {
                            completion(.Success(itemsJsonArray))
                        }
                    }
                } catch let error {
                    return completion(.Error(error.localizedDescription))
                }
            }
        })

        dataTask.resume()
    }
    
}

enum Result<T> {
    case Success(T)
    case Error(String)
}





extension UIViewController {

    func setLargeTitleDisplayMode(_ largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode) {
        switch largeTitleDisplayMode {
        case .automatic:
              guard let navigationController = navigationController else { break }
            if let index = navigationController.children.firstIndex(of: self) {
                setLargeTitleDisplayMode(index == 0 ? .always : .never)
            } else {
                setLargeTitleDisplayMode(.always)
            }
        case .always, .never:
            navigationItem.largeTitleDisplayMode = largeTitleDisplayMode
            // Even when .never, needs to be true otherwise animation will be broken on iOS11, 12, 13
            navigationController?.navigationBar.prefersLargeTitles = true
        @unknown default:
            assertionFailure("\(#function): Missing handler for \(largeTitleDisplayMode)")
        }
    }
}
