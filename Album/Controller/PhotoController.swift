//
//  PhotoController.swift
//  Album
//
//  Created by Gareth Harris on 10/4/17.
//  Copyright © 2017 Gareth Harris. All rights reserved.
//

import UIKit

class PhotoController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var headerText:String?
    var albumPhotoArray:Album!
    var DisplayImageViewController:DisplayImageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = headerText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "displaySegue") {
            self.DisplayImageViewController = segue.destination as? DisplayImageViewController
        }
    }
    
    
    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionCell {
           
            print("I selected photoImage tag: \(cell.photoImage.tag) row:\(indexPath.row)")
         
            self.DisplayImageViewController.albumPhoto = self.albumPhotoArray
            self.DisplayImageViewController.index = indexPath.row
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albumPhotoArray.albumContentArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print("cellForItemAt: I selected album section:\(self.indexPath.row) row:\(indexPath.row)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionCell
        
        if let album = self.albumPhotoArray {
            if let albumCollection = self.albumPhotoArray.albumContentArray[indexPath.row] as AlbumContent! {
                if let urlImage = album.getCacheImage(uri: albumCollection.url!) {
                    cell.photoImage.image =  urlImage
                } else {
                    DispatchQueue.global().async {
                        album.setCacheImage(uri: albumCollection.url!)
                        DispatchQueue.main.async {
                            cell.photoImage.image =  album.getImage(url: albumCollection.url!)  //getThumbnailUrls(thumbnailUrl: albumCollection.thumbnailUrl!)
                        }
                    }
                }
                cell.title.text = albumCollection.title
            }
        }
        
        //Assigned Tableview row index
        cell.photoImage.tag = indexPath.row
        
        return cell
    }


}
