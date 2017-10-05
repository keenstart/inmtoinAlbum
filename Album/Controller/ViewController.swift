//
//  ViewController.swift
//  albumplay
//
//  Created by Gareth Harris on 10/3/17.
//  Copyright © 2017 Gareth Harris. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    let urlString = "http://jsonplaceholder.typicode.com/photos"
    var albumArray = [Album]()
    var albumContentArray = [AlbumContent]()
    var album = Album()
    
    var PhotoController:PhotoController!
    
    var indexPath:NSIndexPath!
    var albumID:Int!
    
    
    //var cache = NSCache<AnyObject, AnyObject>()
    
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
                    var albumNoRepeat:Int = 0
                    
                    //Load all Images and assign it to it album's
                    for albumObj in jsonObject {
                        if let albumDict = albumObj as? NSDictionary {
                            
                            
                            
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
                            
                            //Add Images to it Album
                            let albumContentVal = AlbumContent(albumId: albumIdVal, id: idVal, title: titleVal, url: urlVal, thumbnailUrl: thumbnailUrlVal)
                            self.albumArray[albumIdVal-1].appendAlbum(albumContent: albumContentVal)

                        }
                    }
                }
                
            } catch let jsonError {
                print("Json error: \(jsonError)")
            }
            
            //Reload UI on the main thread
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }

        }.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "photoSegue") {
             self.PhotoController = segue.destination as? PhotoController
        }
    }
    
    //MARK: TableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("I selected table \(indexPath.row)")

        self.PhotoController.headerText = "Album \(String(describing: self.albumArray[indexPath.row].albumId!))"
        self.PhotoController.albumPhotoArray = self.albumArray[indexPath.row]
    }
    
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My Albums"
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albumArray.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableCell
        cell.albumName.text = "Album \(String(describing: self.albumArray[indexPath.row].albumId!))"
        self.indexPath = indexPath as NSIndexPath
        
        print("tableView: I selected self.indexPath:\(self.indexPath.row) indexPath.row:\(indexPath.row)")
        
        cell.tableCollection.reloadData()
        return cell
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionCell {
            
            print("I selected Collection tag: \(cell.imageCollection.tag) row:\(indexPath.row)")
            
            self.PhotoController.headerText = "Album \(String(describing: self.albumArray[cell.imageCollection.tag].albumId!))"
            self.PhotoController.albumPhotoArray = self.albumArray[cell.imageCollection.tag]
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albumArray[section].albumContentArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForItemAt: I selected album section:\(self.indexPath.row) row:\(indexPath.row)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionCell
       
        let album = self.albumArray[self.indexPath.row]
        let albumCollection = self.albumArray[self.indexPath.row].albumContentArray[indexPath.row]
        
        if let urlImage = album.getCacheImage(uri: albumCollection.thumbnailUrl!) {
            cell.imageCollection.image =  urlImage
        } else {
            DispatchQueue.global().async {
                album.setCacheImage(uri: albumCollection.thumbnailUrl!)
                DispatchQueue.main.async {
                    cell.imageCollection.image =  album.getThumbnailUrls(thumbnailUrl: albumCollection.thumbnailUrl!)
                }
            }
        }
        
        //Assigned Tableview row index
        cell.imageCollection.tag = self.indexPath.row
        
        return cell
    }
}


