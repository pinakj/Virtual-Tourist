//
//  FlickrClient.swift
//  FlickFinder
//
//  Created by Pinak Jalan on 7/27/17.
//  Copyright © 2017 Pinak Jalan. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData
import CoreLocation


class FlickrClient:NSObject, NSFetchedResultsControllerDelegate
{
    
    var session = URLSession.shared
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
        
    }
    public var pinData : Pin?
    public var latitude:Double?
    public var longitude:Double?
    var cnt:Int = 0
    
    
    override init() {
        super.init()
    }
    
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            // Whenever the frc changes, we execute the search and
            // reload the table
            fetchedResultsController?.delegate = self
        }
    }
    
    
    public func taskforGETMethod(_ parameters:[String: AnyObject], completionhandlerforGET:@escaping(_ result: AnyObject?, _ errorString:String?)-> Void)-> URLSessionDataTask
    {
        let newParams = parameters
        let request = URLRequest(url: FlickrURLFromParameters(newParams))

        
       // let request = URLRequest(url: url!)
        let task = session.dataTask(with: request) {(data, response, error) in
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            var parsedResult: AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            } catch {
                completionhandlerforGET(nil, "Error in JSON parsing")
            }

            completionhandlerforGET(parsedResult,nil)
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            //self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionhandlerforGET)
        }

        task.resume()
        return task
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: String?) -> Void) {
        
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            completionHandlerForConvertData(nil, "Error in JSON parsing")
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    public func FlickrURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Values.APIScheme
        components.host = Constants.Values.APIHost
        components.path = Constants.Values.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    
    class func sharedInstance() -> FlickrClient {
        
        struct Singleton {
            static var sharedInstance = FlickrClient()
        }
        
        return Singleton.sharedInstance
    }
}
