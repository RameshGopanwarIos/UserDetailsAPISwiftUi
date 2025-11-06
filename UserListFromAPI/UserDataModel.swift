//
//  UserDataModel.swift
//  UserListFromAPI
//
//  Created by Ramesh Gopanwar on 16/08/25.
//


//Codable protocol has encode and decode features

//Encode-> while uploading data to server
//Decode->Downloading data from server

//Working with codable--> propertyNames must match with json data keys

struct UserData: Codable {
    let login: String
    let avatar_url: String
    let bio: String
}
