//
//  ViewController.swift
//  albumplay
//
//  Created by Gareth Harris on 10/3/17.
//  Copyright © 2017 Gareth Harris. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let urlString = "https://jsonplaceholder.typicode.com/photos"
    var albumArray = [Album]()
    var albumContentArray = [AlbumContent]()
    var album = Album()
    
    var cache = NSCache<AnyObject, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        parseJsonFromUrl ()
    }
    
    func parseJsonFromUrl () {
        guard let url = URL(string:urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray {
                    //print(jsonObject)
                    var albumNoRepeat:Int = 0
                    for albumObj in jsonObject {
                        if let albumDict = albumObj as? NSDictionary {
                            
                            //Load all Image and assign it to it album
                            
                            let albumIdVal: Int = {
                                if let  albumId = albumDict.value(forKey: "albumId") as? Int {
                                    return albumId
                                }
                                return 0
                            }()
                            
                            let idVal: Int = {
                                if let  id = albumDict.value(forKey: "id") as? Int {
                                    return id
                                }
                                return 0
                            }()
                            
                            let titleVal: String = {
                                if let  title = albumDict.value(forKey: "title") as? String {
                                    return title
                                }
                                return ""
                            }()
                            
                            let urlVal: String = {
                                if let  url = albumDict.value(forKey: "url") as? String {
                                    return url
                                }
                                return ""
                            }()
                            
                            let thumbnailUrlVal: String = {
                                if let  thumbnailUrl = albumDict.value(forKey: "thumbnailUrl") as? String {
                                    return thumbnailUrl
                                }
                                return ""
                            }()
                            
                            
                            //Identify number of albums
                            if albumNoRepeat != albumIdVal {
                                albumNoRepeat = albumIdVal
                                self.album = Album()
                                self.album.setValues(albumId: albumIdVal, thumbnailUrl: thumbnailUrlVal)
                                self.albumArray.append(self.album)
                                print(albumIdVal)
                            }
                            
                            let albumContentVal = AlbumContent(albumId: albumIdVal, id: idVal, title: titleVal, url: urlVal, thumbnailUrl: thumbnailUrlVal)
                            self.albumArray[albumIdVal - 1].appendAlbum(albumContent: albumContentVal)
                            
                            OperationQueue.main.addOperation {
                                self.collectionView.reloadData()
                            }
                        }
                    }
                }
                
            } catch let jsonError {
                print("Json error: \(jsonError)")
            }
            }.resume()
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: collectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albumArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! AblumCell
        
        //var albumCollection = Album()
        let albumCollection = self.albumArray[indexPath.row]
        
        if let urlImage = self.cache.object(forKey: albumCollection.thumbnailUrl as AnyObject) {
            cell.ablumImageView.image =  urlImage as? UIImage
        } else {
            DispatchQueue.global().async {
                let dataUrl = NSData(contentsOf: URL(string: albumCollection.thumbnailUrl!)!)
                self.cache.setObject(UIImage(data: dataUrl! as Data)!, forKey: albumCollection.thumbnailUrl as AnyObject)
                DispatchQueue.main.async {
                    cell.ablumImageView.image =  UIImage(data: dataUrl! as Data)
                }
            }
        }
        
        
        //cell.ablumImageView.image = UIImage(named: array[indexPath.row] + ".jpg")
        
        
        return cell
    }
    
}


