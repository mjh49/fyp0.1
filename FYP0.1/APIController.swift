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
    
    func searchItunesFor(searchTerm: String) {
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let itunesSearchTerm = searchTerm.replacingOccurrences(of:" ", with: "+", options: NSString.CompareOptions.caseInsensitive, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        if let escapedSearchTerm = itunesSearchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            let url = URL(string: "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software")!
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) -> Void in
                print("Task completed")
                if let data = data {
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                                
                                if let results: NSArray = jsonResult["results"] as? NSArray {
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
            
            // The task is just an object with all these properties set
            // In order to actually make the web request, we need to "resume"
            task.resume()
        }
        
        
        
    }

}

protocol APIControllerProtocol {
    func didReceiveAPIResults(results: NSArray)
}
