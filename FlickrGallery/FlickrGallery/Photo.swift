//
//  Photo.swift
//  FlickrGallery
//
//  Created by Max Kuznetsov on 26.06.2022.
//

import Foundation
import SwiftyJSON
struct PhotoStruct{
    
    var bigImageURL:String
    var smallImageURL:String
    var title
    
    init?(json:JSON){
        guard let urlQ=json["url_q"].string,
              let urlZ=json["url_z"].string else{
            return nil
        }
        self.bigImageURL=urlZ
        self.smallImageURL=urlQ
    }
}
