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
    
    @IBOutlet weak var usernameView: UILabel!
    
    @IBOutlet weak var tweetView: UILabel!
    
    
    let api = APIController()
    var tweets = NSMutableDictionary.init()
    var tweetKey = 0
    var tweetToShow = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        api.delegate = self
        api.getTweet()
            }
        

    
    
    func addTweetToDisplay (results: NSDictionary) {
        tweets.setObject(results, forKey: tweetKey as NSCopying)
        tweetKey += 1
    }
    
    func showTweet(){
        
        if let tweetDict : NSDictionary = tweets.object(forKey: tweetToShow) as? NSDictionary{
        let username = tweetDict.object(forKey: "username")
        let text = tweetDict.object(forKey: "tweet")
        var tweetImage : UIImage
        
        tweetImage = UIImage()
     
        if tweetDict.object(forKey: "image") != nil{
            let urlString = tweetDict.object(forKey: "image") as? String
            print (urlString!)
            // Create an NSURL instance from the String URL we get from the API
            let imgURL = URL(string: urlString!)
        
        
            let task = URLSession.shared.dataTask(with: imgURL!) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded picture with response code \(res.statusCode)")
                    tweetImage = (UIImage(data: data! as Data)!)
                    self.appsImageView.image = tweetImage
                }
                else {
                    print("Couldn't get response code for some reason")
                }
            }
            }
            task.resume()
        }
        
        
        usernameView.text = username as? String
        tweetView.text = text as? String
        }
    }
    
    func deleteTweet() {
        tweets.removeObject(forKey: tweetToShow)
    }




    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func didReceiveAPIResults(results: NSDictionary) {
            self.addTweetToDisplay(results: results)
            self.showTweet()
            self.deleteTweet()
            self.tweetToShow += 1        
    }
    
    
}




    
