//
//  DisplayImageViewController.swift
//  Album
//
//  Created by Gareth Harris on 10/5/17.
//  Copyright © 2017 Gareth Harris. All rights reserved.
//

import UIKit

class DisplayImageViewController: UIViewController {

    @IBOutlet weak var displayImage: UIImageView?
    @IBOutlet weak var imageTitle: UILabel?
    
    var albumPhoto:Album!
    var index:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let album = self.albumPhoto {
            if let albumCollection = self.albumPhoto.albumContentArray[self.index] as AlbumContent! {
                if let urlImage = album.getCacheImage(uri: albumCollection.url!) {
                    //Get from cache
                    self.displayImage?.image =  urlImage
                } else {
                    //Save to cache
                    DispatchQueue.global().async {
                        album.setCacheImage(uri: albumCollection.url!)
                        DispatchQueue.main.async {
                            self.displayImage?.image =  album.getImage(url: albumCollection.url!)  //getThumbnailUrls(thumbnailUrl: albumCollection.thumbnailUrl!)
                        }
                    }
                }
                self.imageTitle?.text = albumCollection.title
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func downloadImage(_ sender: UIButton) {
        print("To Image save")
        if let ImageData = UIImagePNGRepresentation((self.displayImage?.image)!) {
            if let uiImage = UIImage(data: ImageData) {
                UIImageWriteToSavedPhotosAlbum(uiImage, self, nil, nil)
                let alert = UIAlertController(title: "Save to Photos", message: "Images has been saved.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler:nil)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
            }
        }
        
    }

}
