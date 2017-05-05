//
//  Movie.swift
//  popularTVmovie
//
//  Created by eric yu on 5/4/17.
//  Copyright © 2017 eric yu. All rights reserved.
//

import Foundation

class Movie {
    let pathPrefix = "https://image.tmdb.org/t/p/w500/"
    
    var title: String?
    var overview: String?
    var posterPath: String?
    
    init(movieDict: Dictionary<String,Any>){
        if let title = movieDict["title"] as? String {
            self.title = title
        }
        
        if let overview = movieDict["overview"] as? String {
            self.overview = overview
        }
        
        if let path = movieDict["poster_path"] as? String {
            self.posterPath = pathPrefix.appending(path)
        }
    }
    
    
}
