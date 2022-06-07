//
//  ViewController.swift
//  TaleTree
//
//  Created by UFL on 16/12/20.
//  Copyright © 2020 UnfoldLabs. All rights reserved.
//

import Foundation

struct Constants {
    
    //    static let alertTitle = ""
    //    static let colour = UIColor(hexString: "#4A3FF7")
    
}
struct API {
    
    
    //   static let ipAddress_dev = "https://taletree.io/api/v2/"
    
    static let ipAddress_dev = "https://taletree.io/api/v3/"
    
    static let runningIP = ipAddress_dev
    
    static let ClientIDStr = "CHWGjBL9S4ghwJeMx1QHmboBDyFAsihA9heKc6Jy"
    
    static let client_secret = "kp78SLBOCZFjzdD6b4BECN73ZTDe8YU2L13XrJaYEOEC1wNOIEPnOxDrTd4QAaDVy7tzDEuVsOjE7RfIPKsfGgyxCXQgq9jk5UbLm6anOlmAAO0BKPWzynQSle8Kd5XJ"
    
    static let loginTokenAPI = runningIP + "token"
    static let loadProfileUser = runningIP + "dependents/current"
    static let forgotPasswordAPI = runningIP + "dependent_reset_help"
    
    static let getFeedsAPI = runningIP + "feed"
    
    // static let signInPageRedirect = "https://taletree.io/account/signup"
    
    static let signInPageRedirect = "https://www.taletree.io/signup"
    
    static let favoritesAPI = runningIP + "dependents/"
    
    static let myCampMembers = "https://taletree.io/api/v2/groups/"
    static let loadCampMemberDetails = runningIP + "dependents/"
    
    static let uploadAPI = runningIP + "creations_media"
    
    
    static let allCreationsAPI = runningIP + "creations"
    
    static let nonCampPageredirect = "https://www.taletree.app/onlinecreativecamp"
    
    static let sendFeedback = runningIP + "feedback"
    static let uploadingProfilePic = runningIP + "dependents/"
    
    static let challengesAPI = runningIP + "challenges"
    
    static let challengesDetailAPI = runningIP + "challenges/"
    
    static let homeFeedsListAPI = runningIP + "feed"
    
    static let commentSendAPI = runningIP + "comments"
    
    static let getFeedDetailAPI = runningIP + "creations"
    
    static let getCommentsAPI = runningIP + "comments"
    
    
    static let deleteCeation = runningIP + "creations/"
    
    static let reportOnCreation = runningIP + "violations"
    
    static let binkyAPI = runningIP + "binkies"
    
    static let binkyDeleteAPI = runningIP + "binkies/"
    
    
    static let notificationAPI = runningIP + "notifications"
    
    
}

/*****User_Defaults USED****/

/*++++++++++++++++++++++++
 
 rememberme_id : Remember Me email ID
 rememberme_password : Remember Me Password
 profile_details : Login response (User details)
 
 ++++++++++++++++++++++++*/
