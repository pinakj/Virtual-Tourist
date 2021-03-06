//
//  FlickrConvenience.swift
//  FlickFinder
//
//  Created by Pinak Jalan on 7/27/17.
//  Copyright © 2017 Pinak Jalan. All rights reserved.
//

import Foundation
import UIKit

extension FlickrClient {
    
    public func getPhotosforCoordinates(pin: Pin, completionhandlerForPhoto: @escaping(_ success: Bool, _ errorString:String?)
        -> Void) {
                
        
        let parameters: [String : AnyObject] = [
            FlickrClient.Constants.Keys.APIKey: FlickrClient.Constants.Values.APIKey as AnyObject, FlickrClient.Constants.Keys.Format:FlickrClient.Constants.Values.Response as AnyObject,FlickrClient.Constants.Keys.Method:FlickrClient.Constants.Values.SearchMethod as AnyObject, FlickrClient.Constants.Keys.Latitude:pin.latitude as AnyObject, FlickrClient.Constants.Keys.Longitude:pin.longitude as AnyObject, "page":"1" as AnyObject, "nojsoncallback":"1" as AnyObject, "extras":"url_m" as AnyObject, "per_page":"21" as AnyObject]
        
        self.taskforGETMethod(parameters) {(result, error) in
            
            
            if(error == nil)
            {
                
                let photoDictionary = result?["photos"] as! [String:AnyObject]
                let photosArray = photoDictionary["photo"] as! [[String:AnyObject]]
                
                for photo in photosArray
                {
                    self.cnt = self.cnt + 1

                    
                    //TO DO: REDO THIS
                    if(self.cnt < 17)
                    {
                    let photoURL = photo["url_m"] as! String
                   
                    
                    let downloadedPicture =  try! UIImage(data: Data(contentsOf: URL(string:photoURL)!))
                    //print(downloadedPicture)
                    
                    let picture = Photo(context: self.sharedContext)
                    
                    picture.photo = UIImagePNGRepresentation(downloadedPicture!) as NSData?
    
                    self.pinData?.addToRelationship(picture)
                    print(self.pinData?.relationship?.count)
            
                    
                    try! self.sharedContext.save()
                    print(self.sharedContext)
                    completionhandlerForPhoto(true,nil)
                    }
                }
                
            }
            else
            {
                completionhandlerForPhoto(false, "Error in photo for coordinate")

            }
        }
    }
 
    private func boundingBoxForGETImages(forPin pin: Pin) -> String {
 
        let bottom_left_longitude = max(Double(pin.longitude) - Constants.Values.bboxhalfWidth, Constants.Values.minLong)
        let bottom_left_latitude = max(Double(pin.latitude) - Constants.Values.bboxhalfHeight, Constants.Values.minLat)
        let top_right_longitude = min(Double(pin.longitude) + Constants.Values.bboxhalfHeight, Constants.Values.maxLong)
        let top_right_latitude = min(Double(pin.latitude) + Constants.Values.bboxhalfWidth, Constants.Values.maxLat)
        
        return "\(bottom_left_longitude),\(bottom_left_latitude),\(top_right_longitude),\(top_right_latitude)"
    }
}
