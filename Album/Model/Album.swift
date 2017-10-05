//
//  Album.swift
//  albumplay
//
//  Created by Gareth Harris on 10/3/17.
//  Copyright © 2017 Gareth Harris. All rights reserved.
//

import UIKit

class Album {
    var cache = NSCache<AnyObject, AnyObject>()
    
    var albumId:Int?
    var thumbnailUrl:String?
    var albumContentArray = [AlbumContent]()
    
    func setValues (albumId:Int, thumbnailUrl:String) {
        self.albumId = albumId
        self.thumbnailUrl = thumbnailUrl
    }
    
    func appendAlbum (albumContent:AlbumContent) {
        
        //I was thinking of caching all the image on load. But concern about memory space
        /*
         let dataThumbnailUrl = NSData(contentsOf: URL(string: albumContent.thumbnailUrl!)!)
         self.cache.setObject(UIImage(data: dataThumbnailUrl! as Data)!, forKey: albumContent.thumbnailUrl as AnyObject)
         
         let dataUrl = NSData(contentsOf: URL(string: albumContent.url!)!)
         self.cache.setObject(UIImage(data: dataUrl! as Data)!, forKey: albumContent.url as AnyObject)
         */
        
        self.albumContentArray.append(albumContent)
    }
    
    func getAlbumThumbnailUrls () -> UIImage! {
        return self.getThumbnailUrls (thumbnailUrl:self.thumbnailUrl!)
    }
    
    func setCacheImage (uri:String) {
        let dataUri = NSData(contentsOf: URL(string: uri)!)
        self.cache.setObject(UIImage(data: dataUri! as Data)!, forKey: uri as AnyObject)
    }
    
    func getCacheImage (uri:String) -> UIImage! {
        var rtnImage:UIImage!
        if let uriImage = self.cache.object(forKey: uri as AnyObject) {
            rtnImage =  uriImage as! UIImage
        }
        return  rtnImage
    }
    
    func getImage (url:String) -> UIImage! {
        return self.getCacheImage (uri:url)
    }
    
    func getThumbnailUrls (thumbnailUrl:String) -> UIImage! {
        return self.getCacheImage (uri:thumbnailUrl)
    }
}


class AlbumContent: NSObject {
    let albumId:Int?
    let id:Int?
    let title:String?
    let url:String?
    let thumbnailUrl:String?
    
    init(albumId:Int, id:Int, title:String, url:String, thumbnailUrl:String) {
        self.albumId = albumId
        self.id = id
        self.title = title
        self.url = url
        self.thumbnailUrl = thumbnailUrl
    }
}

