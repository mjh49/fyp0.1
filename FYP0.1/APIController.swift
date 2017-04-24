//
//  APIController.swift
//  SocialMediaGet
//
//  Created by Matthew Hemstock on 09/03/2017.
//  Copyright © 2017 Matthew Hemstock. All rights reserved.
//

import Foundation

class APIController {
    
    var delegate: APIControllerProtocol?
    
    init () {
    
    }
    
    func getTweet() {
        let url = URL(string: "https://users.sussex.ac.uk/~mjh49/FYP/test.php")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) -> Void in
            print("Task completed")
            if let data = data {
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        
                        print (jsonResult)
                        
                        if let first: NSDictionary = jsonResult as? NSDictionary {
                            print(first)
                            let results : NSDictionary = first.object(forKey: "results") as! NSDictionary
                            self.delegate?.didReceiveAPIResults(results: results)
                        }
                        
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }

}

protocol APIControllerProtocol {
    func didReceiveAPIResults(results: NSDictionary)
}
