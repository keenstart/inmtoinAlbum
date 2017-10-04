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
        
        //I was thinking of caching all the image on load. But concern about memory size
        /*
         let dataThumbnailUrl = NSData(contentsOf: URL(string: albumContent.thumbnailUrl!)!)
         cache.setObject(UIImage(data: dataThumbnailUrl! as Data)!, forKey: albumContent.thumbnailUrl as AnyObject)
         
         let dataUrl = NSData(contentsOf: URL(string: albumContent.url!)!)
         cache.setObject(UIImage(data: dataUrl! as Data)!, forKey: albumContent.url as AnyObject)
         */
        
        self.albumContentArray.append(albumContent)
    }
    
    func getAlbumThumbnailUrls () -> UIImage! {
        return getThumbnailUrls (thumbnailUrl:self.thumbnailUrl!)
    }
    
    func getImage (url:String) -> UIImage! {
        var rtnImage:UIImage!
        if let urlImage = self.cache.object(forKey: url as AnyObject) {
            rtnImage =  urlImage as! UIImage
        } else {
            DispatchQueue.global().async {
                let dataUrl = NSData(contentsOf: URL(string: url)!)
                self.cache.setObject(UIImage(data: dataUrl! as Data)!, forKey: url as AnyObject)
                DispatchQueue.main.async {
                    rtnImage =  UIImage(data: dataUrl! as Data)
                }
            }
        }
        return  rtnImage
    }
    
    func getThumbnailUrls (thumbnailUrl:String) -> UIImage! {
        var rtnImage:UIImage!
        if let urlImage = self.cache.object(forKey: thumbnailUrl as AnyObject) {
            rtnImage =  urlImage as! UIImage
        } else {
            DispatchQueue.global().async {
                let dataUrl = NSData(contentsOf: URL(string: thumbnailUrl)!)
                self.cache.setObject(UIImage(data: dataUrl! as Data)!, forKey: thumbnailUrl as AnyObject)
                DispatchQueue.main.async {
                    rtnImage =  UIImage(data: dataUrl! as Data)
                }
            }
        }
        return  rtnImage
    }
}


class AlbumContent: NSObject {
    let albumId:Int?
    let id:Int?
    let title:String?
    let url:String?
    let thumbnailUrl:String?
    //let imgUrl:UIImage?
    //let imgthumbnailUrl:UIImage?
    
    init(albumId:Int, id:Int, title:String, url:String, thumbnailUrl:String /*, *imgUrl:UIImage, imgthumbnailUrl:UIImage*/) {
        self.albumId = albumId
        self.id = id
        self.title = title
        self.url = url
        self.thumbnailUrl = thumbnailUrl
        //self.imgUrl = imgUrl
        //self.imgthumbnailUrl = imgthumbnailUrl
    }
}

