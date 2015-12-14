//
//  DataService.swift
//  myHood
//
//  Created by Killian Jackson on 11/26/15.
//  Copyright © 2015 Killian Jackson. All rights reserved.
//

import Foundation
import UIKit

// purpose of a singleton is there is one instance of it in memory and it is globally accessible
class DataService {
    
    let KEY_POSTS = "posts"
    
    // only ever create one instance. "Instance" is just a variable name to identify the singleton
    static let instance = DataService()
    
    private var _loadedPosts = [Post]()
    
    var loadedPosts: [Post]{
        return _loadedPosts
    }
    
    func savePosts() {
        
        // converting _loadedPosts into data that can be stored in postsData that can be identified by key "posts"
        let postsData = NSKeyedArchiver.archivedDataWithRootObject(_loadedPosts)
        NSUserDefaults.standardUserDefaults().setObject(postsData, forKey: KEY_POSTS)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func loadPosts() {
        
        // going to our standard user defaults and grabbing the object for the key "posts"
        if let postsData = NSUserDefaults.standardUserDefaults().objectForKey(KEY_POSTS) as? NSData {
            if let postsArray = NSKeyedUnarchiver.unarchiveObjectWithData(postsData) as? [Post] {
                _loadedPosts = postsArray
            }
        }
        
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "postsLoaded", object: nil))
    }
    
    func saveImageAndCreatePath(image: UIImage) -> String {
        let imgData = UIImagePNGRepresentation(image)
        let imgPath = "image\(NSDate.timeIntervalSinceReferenceDate()).png"
        let fullPath = documentsPathForFileName(imgPath)
        imgData?.writeToFile(fullPath, atomically: true)
        return imgPath
    }
    
    func imageForPath(path: String) -> UIImage? {
        let fullPath = documentsPathForFileName(path)
        let image = UIImage(named: fullPath)
        return image
    }
    
    func addPost(post: Post) {
        _loadedPosts.append(post)
        savePosts()
        loadPosts()
    }
    
    func documentsPathForFileName(name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let fullpath = paths[0] as NSString
        return fullpath.stringByAppendingPathComponent(name)
    }
}