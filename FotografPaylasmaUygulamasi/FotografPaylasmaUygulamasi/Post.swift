//
//  Post.swift
//  FotografPaylasmaUygulamasi
//
//  Created by AbdullahKaragoz on 24.04.2022.
//

import Foundation


class Post {
    var email : String
    var yorum : String
    var gorselUrl : String
    init(email:String,yorum:String,gorselUrl:String){
        self.email = email
        self.yorum = yorum
        self.gorselUrl = gorselUrl
    }

}
