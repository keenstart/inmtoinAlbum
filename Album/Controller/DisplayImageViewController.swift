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
        // Do any additional setup after loading the view.
        
        if let album = self.albumPhoto {
            if let albumCollection = self.albumPhoto.albumContentArray[self.index] as AlbumContent! {
                if let urlImage = album.getCacheImage(uri: albumCollection.url!) {
                    self.displayImage?.image =  urlImage
                } else {
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
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
