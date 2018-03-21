//
//  Constants.swift
//  Help Me Help You
//
//  Created by Feras Allaou on 3/7/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation
import Firebase

struct fourSquare {
    let clientID = "JMATOSMAUVVTRKTF33QBEH5TEUJ0CGXUYIT55ZEGEDNAB3EY"
    let clientSecret = "2S02ACEESIZFOSVC4P1LRTZRQGQK04WPROZDTYIBBDFG2RBE"
    let getVenus = "https://api.foursquare.com/v2/venues/explore"
    let getVenueDetails = "https://api.foursquare.com/v2/venues"
}

struct googleMaps{
    let APIKey = "AIzaSyBndS9GFN7CI9DC8_WwwujYYFzYTcYWpCo"
    let APIUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng="
}

struct Question {
    var cityCoordinates: GeoPoint
    var cityName: String
    var postedAt: Date
    var question: String
    var userid: String
    var docID: String
    var userReference: DocumentReference
    var suggestions: Int
}

struct Venues {
    var id: String
    var name: String
    var lat: Double
    var lng: Double
    var url: String
    var category: String
    //var questionRef: DocumentReference
}

