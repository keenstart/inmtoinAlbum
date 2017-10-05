//
//  PhotoController.swift
//  Album
//
//  Created by Gareth Harris on 10/4/17.
//  Copyright © 2017 Gareth Harris. All rights reserved.
//

import UIKit

class PhotoController: UIViewController {
    
    var headerText:String?
    var albumPhotoArray:Album!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(albumPhotoArray.albumContentArray[0].title!)
        
        self.navigationItem.title = headerText
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
