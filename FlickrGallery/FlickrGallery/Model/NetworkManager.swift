//
//  Network.swift
//  FlickrGallery
//
//  Created by Max Kuznetsov on 26.06.2022.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol NetworkManagerProtocol: AnyObject {
    
    func fetchFlickrPhotos(completionHandler: (([[String:String]]?) -> Void)?)
    
}

class NetworkManager: NetworkManagerProtocol{
    
    func fetchFlickrPhotos(completionHandler: (([[String:String]]?) -> Void)?) {
        let urlString = "https://www.flickr.com/services/rest/"
        let parameters = [
            "method":"flickr.interestingness.getList",
            "api_key":"42191eade73a18609a28e25c1cfcb149",
            "sort":"relevance",
            "per_page":"20",
            "format":"json",
            "nojsoncallback":"1",
            "extras":"url_z"
        ]
        
        AF.request(urlString, parameters: parameters).validate().responseData {
            response in
            switch response.result{
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler?(nil)
            case .success(_):
                guard let data = response.data, let json = try? JSON(data: data) else {
                    print("Error parsing")
                    completionHandler?(nil)
                    return
                }
                
                let photos = json["photos"]["photo"].arrayValue
                
                var outputPhotos: [[String:String]] = []
                
                for photo in photos{
                    guard let urlZ = photo["url_z"].string, let name = photo["title"].string else{
                        continue
                    }
                    var dict: [String:String] = [:]
                    dict["name"] = name
                    dict["imageData"] = urlZ
                    outputPhotos.append(dict)
                }
                print(outputPhotos)
                completionHandler?(outputPhotos)
            }
        }
    }
}
