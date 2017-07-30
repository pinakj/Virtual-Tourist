//
//  FlickrConstants.swift
//  FlickFinder
//
//  Created by Pinak Jalan on 7/27/17.
//  Copyright © 2017 Pinak Jalan. All rights reserved.
//

import Foundation

extension FlickrClient
{
    struct Constants {
        
    struct Keys {
        
        static let Method = "method"
        static let Latitude = "lat"
        static let Longitude = "lon"
        static let Format = "format"
        static let AuthToken = "auth_token"
        static let Extras = "extras"
        static let PerPage = "per_page"
        static let APIKey = "api_key"
        static let bbox = "bbox"
        static let NoJSONCallback = "nojsoncallback"
        
    }
    
    struct Values {
        
        
        static let valPerPage = 25
        static let minLat = -90.0
        static let maxLat = 90.0
        static let minLong = -180.0
        static let maxLong = 180.0
        static let bboxhalfWidth = 0.5
        static let bboxhalfHeight = 1.5
        static let SearchMethod = "flickr.photos.search"
        static let Response = "json"
        static let DisableJSONCallback = "1"
        static let mediumURL = "url_m"
        static let APIKey = "77a7bf744f4e61f9771bbe5c86218115"
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest/"
        
        }

    }
    
}
