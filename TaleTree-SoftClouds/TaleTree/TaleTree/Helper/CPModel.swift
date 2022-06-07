//
//  ViewController.swift
//  TaleTree
//
//  Created by UFL on 16/12/20.
//  Copyright © 2020 UnfoldLabs. All rights reserved.
//
import Foundation


struct SharedData {
    
    static var data = SharedData()
    var feedsData: [feedsList]?
    var creationsDataRoom :[getDetailsForCreation]?
    
    var getHomeDetailFeed : homeDetailData?
    
}

struct loginToken: Codable {
    
    let access_token : String?
    let token_type : String?
    let expires_in : Int?
    let refresh_token: String?
    let scope : String?
    
}

struct userProfileDetails: Codable {
    
    var binky_count : Int?
    let challenge_count : Int?
    let creation_count : Int?
    let first_name : String?
    let id : Int?
    let last_name : String?
    let user_type: String?
    let username : String?
    
    let profile : profileDetail?
    
}
struct profileDetail: Codable {
    
    let birthdate : String?
    let camp_status : String?
    let gender : String?
    //  let picture_height : Int?
    let picture_url : String?
    //   let picture_width : Int?
    
    let favorites : [String]?
    
    let group : groupDetails?
}
struct groupDetails: Codable {
    
    let age_group:String?
    let day:String?
    let id:Int?
    let name : String?
    let time : String?
    let timezone : String?
    let zoom_link : String?
    
}

//Getting Camp members
struct campMemberDetails: Decodable {
    
    let id : Int?
    let name : String?
    let day : String?
    let time : String?
    let timezone : String?
    let age_group : String?
    let zoom_link: String?
    let dependent_count : Int?
    let dependents : [memberDetails]?
    
}
struct memberDetails: Codable {
    
    
    let id:Int?
    let username : String?
    let profile : profilePicUrl?
    
    
}
struct profilePicUrl: Codable {
    
    let picture_url:String?
    
}

// This codable for getting MyCamp Member deatails by passing User Id
struct campMemDetailsFromMyCamp: Decodable {
    
    var binky_count : Int?
    let challenge_count : Int?
    let creation_count : Int?
    let first_name : String?
    let id : Int?
    let last_name : String?
    let user_type: String?
    let username : String?
    
    let profile : campProfileDetails?
    
}
struct campProfileDetails: Codable {
    
    let birthdate : String?
    let camp_status : String?
    let gender : String?
    //    let picture_height : Int?
    let picture_url : String?
    //   let picture_width : Int?
    
    let favorites : [String]?
    
    let group : campGroupDetails?
}
struct campGroupDetails: Codable {
    
    let age_group:String?
    let day:String?
    let id:Int?
    let name : String?
    let time : String?
    let timezone : String?
    let zoom_link : String?
    
}

struct ApiPayStatus: Decodable {
    
    let result_code : Int?
    let error_info : String?
    let has_more : Bool?
    let data: [getDetailsForCreation]?
}

struct getDetailsForCreation: Codable {
    
    var binky_count: Int?
    var comment_count:Int?
    let media_count:Int?
    let id : Int?
    var binky_id: Int?
    
    //   let challenge_id : String?
    let challenge: challengeChar?
    
    //  let title: String?
    // let description :  String?
    
    let media : [getPicdetails]?
    
    let user : creationUser?
    
}
struct challengeChar: Codable {
    let id :  Int?
    let character_type : String?
}

struct creationUser: Codable {
    
    let id :  Int?
    
}

struct getPicdetails: Codable {
    
    let id :  Int?
    let url :  String?
    let s640_height: Int?
    let s640_url : String?
    let s640_width : Int?
    
}

struct challengesAPIStatus: Decodable {
    
    let result_code : Int?
    let error_info : String?
    let data: [challengesList]?
}

struct challengesList: Codable {
    
    let id :  Int?
    let picture_url :  String?
    let description : String?
    let title :  String?
    let has_submitted :  Bool?
    let character_type :  String?
    
    
}
struct challengeDetailData: Codable {
    
    let has_submitted : Bool?
    let creation_count : Int?
    let id : Int?
    let description : String?
    let picture_url: String?
    let title : String?
    let character_type : String?
    
}

struct submissionAPIStatus: Decodable {
    
    let result_code : Int?
    let error_info : String?
    let has_more : Bool?
    let data: [getAllSubmissions]?
}
struct getAllSubmissions: Codable {
    
    let binky_count: Int?
    var comment_count:Int?
    let media_count:Int?
    let id : Int?
    let challenge_id : Int?
    var binky_id : Int?
    
    let media : [getSubmissionPics]?
    
    let user : challengeUser?
}
struct challengeUser: Codable {
    
    let id :  Int?
    let username :  String?
    
}
struct getSubmissionPics: Codable {
    
    let id :  Int?
    let url :  String?
    let s640_url : String?
    
}

struct feedsAPIStatus: Decodable {
    
    let result_code : Int?
    let error_info : String?
    let data: [feedsList]?
}
struct feedsList: Codable {
    
    var binky_id: Int?
    
    let creation_id : Int?
    var binky_count :  Int?
    let description : String?
    let title :  String?
    var comment_count :Int?
    let media_count : Int?
    var user : userAllDetails?
    let media : [getMediaDetails]?
    
}
struct userAllDetails : Codable {
    var user_id : Int?
    let username: String?
    let profile: getProfileInnerDetails?
}
struct getProfileInnerDetails: Codable {
    let picture_url :String?
    let favorites :[String]?
    let group : groupDetailsFetch?
}
struct groupDetailsFetch :Codable {
    let group_id :Int?
    let name :String?
}
struct getMediaDetails :Codable {
    let media_id : Int?
    let url:String?
    
    let s640_height: Int?
    let s640_url : String?
    let s640_width : Int?
    let original_width : Int?
    let original_height : Int?
    
}

struct homeDetailData: Codable {
    
    let id : Int?
    let description : String?
    // let picture_url: String?
    let title : String?
    var binky_id : Int?
    var binky_count : Int?
    var comment_count :  Int?
    let media_count : Int?
    
    let created_at_ts: Int?
    
    let user: homeDetailUser?
    
    let media: [homeDetailMedia]?
    
}

struct homeDetailMedia: Codable {
    let id : Int?
    let url : String?
    let s640_height: Int?
    let s640_url : String?
    let s640_width : Int?
    
    let original_width: Int?
    let original_height : Int?
}

struct homeDetailUser: Codable {
    
    
    let username : String?
    
    let gender : String?
    let group : grouphomeDetails?
    let favorites : [String]?
    let profile : detailHomeProfile?
}
struct detailHomeProfile: Codable {
    
    let picture_url: String?
    
    let gender : String?
    let group : grouphomeDetails?
    let favorites : [String]?
}

struct grouphomeDetails: Codable {
    
    let id :  Int?
    let name : String?
    
}

struct getCommentsAPIStatus: Decodable {
    
    let result_code : Int?
    let error_info : String?
    let has_more : Bool?
    let data: [getComments]?
}

struct getComments: Codable {
    
    let created_at:String?
    let created_at_ts : Int?
    
    let id : Int?
    let text : String?
    let dependent: dependentDetails?
    
}
struct dependentDetails: Codable {
    
    let first_name:String?
    let id : Int?
    let last_name : String?
    let username: String?
    // let text: String?
    let profile: profilePicDetails?
    
}
struct profilePicDetails: Codable {
    let picture_url:String?
    
    
}

struct NotificationAPIStatus: Decodable {
    
    let result_code : Int?
    let error_info : String?
    let has_more : Bool?
    let data: [notifcationDetailData]?
}

struct notifcationDetailData: Codable {
    let from_created_at_ts: Int?
    let id: Int?
    let from_object : String?
    let from_created_at : String?
    
    let from_dependent : noticationDepedent?
    let from_creation : noticationCreation?
    
}
struct noticationDepedent: Codable{
    
    let id: Int?
    let object: String?
    let username: String?
    let profile: profileNotification?
    
}
struct profileNotification: Codable{
    
    let picture_url: String?
}

struct noticationCreation: Codable{
    
    let id: Int?
    let object: String?
    let media: [noticationMedia]?
}

struct noticationMedia: Codable{
    
    let id: Int?
    let object: String?
    let url : String?
    let s640_url : String?
}
