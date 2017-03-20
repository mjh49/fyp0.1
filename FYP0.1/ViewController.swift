//
//  ViewController.swift
//  FYP0.1
//
//  Created by Matthew Hemstock on 14/03/2017.
//  Copyright © 2017 Matthew Hemstock. All rights reserved.
//

import UIKit

class ViewController: UIViewController, APIControllerProtocol {
    
    @IBOutlet var appsImageView: UIImageView!
    var imageCache = [String:UIImage]()
    var imageData = [] as NSArray
    let api = APIController()
    var imageCount = 0
    var images = [] as NSMutableArray


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        api.delegate = self
        api.searchItunesFor(searchTerm: "Temple")
    }
    
    func imageView( imageView: UIImageView){
        print("running")
        imageCount = imageData.count
        for i in 0...(imageCount - 1){
            if let info: NSDictionary = self.imageData[i] as? NSDictionary,
            // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
            let urlString = info["artworkUrl60"] as? String,
            // Create an NSURL instance from the String URL we get from the API
                let imgURL = URL(string: urlString){
                
                images[i] = UIImage(named: "Blank52")!

                if let img = imageCache[urlString] {
                    images[i] = img
                } else {
                    let task = URLSession.shared.dataTask(with: imgURL) { (data, response, error) in
                        // The download has finished.
                        if let e = error {
                            print("Error downloading cat picture: \(e)")
                        } else {
                            // No errors found.
                            // It would be weird if we didn't have a response, so check for that too.
                            if let res = response as? HTTPURLResponse {
                                print("Downloaded picture with response code \(res.statusCode)")
                                self.images[i] = (UIImage(data: data! as Data)!)
                                self.appsImageView.animationImages = self.images as NSArray as? [UIImage]
                                self.appsImageView.startAnimating()
                                
                                }
                         else {
                                print("Couldn't get response code for some reason")
                            }
                        }
                    }
                task.resume()
                }}}
        self.appsImageView.animationDuration = 25
        
        
        
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func didReceiveAPIResults(results: NSArray) {
        DispatchQueue.main.async(execute: {
            self.imageData = results
            self.imageView(imageView: self.appsImageView)
            
        
                                            })
    }
    
    
}




    
