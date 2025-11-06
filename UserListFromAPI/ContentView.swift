//
//  ContentView.swift
//  UserListFromAPI
//
//  Created by Ramesh Gopanwar on 16/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var user: UserData?
    var body: some View {
        VStack(spacing: 20) {
            
            AsyncImage(url: URL(string: user?.avatar_url ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .foregroundColor(.secondary)
            }
            .frame(width: 400, height: 200)

            
            
            Text(user?.login ?? "login")
                .bold()
                .font(.title)
            Text(user?.bio ?? "bio")
                .padding()
            
            Spacer()
        }
        .padding()
        //task here is useful for adding asynchronous task to perform before this view appears
        .task {
            do {
                user = try await getUserDetails()
            } catch {
                print("invalid user address")
            }
        }
        
        
    }
    //Network call requests 4 types
    //GET->pulling down data -> read onlt
    //POST -> create new data and upload
    //PUT -> Update existing data
    //DELETE -> deleting something
    func getUserDetails() async throws -> UserData {
        let endPoint = "https://api.github.com/users/RameshGopanwarIos"
        
        guard let url = URL(string: endPoint) else { throw ServerError.invalidURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        //response -> response from url like 404 error found, 500, 200 etc
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw ServerError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            //for making sure all keys are matching with camelCase from snakeCase
            //decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(UserData.self, from: data)
            
        } catch {
            throw ServerError.invalidData
        }
        
        
        
    }
}


enum ServerError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
#Preview {
    ContentView()
}
