//
//  Constants.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-12.
//

import Foundation
import UIKit

let MOVIESKIP_ICON: UIImage = #imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysOriginal)


//MARK: - TMDB API 

let TMDB_API_KEY: String = "ab0e29ade2759c5fdac27207fe0ce0b8"
let TMDB_DISCOVER_BASE: String = "https://api.themoviedb.org/3/discover/movie?api_key=\(TMDB_API_KEY)"
let TMDB_MOVIE_BASE: String = "https://api.themoviedb.org/3/movie/"  // + MovieId?api_key=TMDB_API_KEY
let TMDB_IMAGE_BASE = "https://image.tmdb.org/t/p/w500" //Plus poster path
