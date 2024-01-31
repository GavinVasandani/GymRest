//
//  APICaller.swift
//  ICHackMenstraulGym
//
//  Created by Gavin Vasandani on 04/02/2023.
//
//Object responsible for calling API:

//APICaller where we pass in URL, an expecting object and completion handler so func used to call API

import Foundation

final class APICaller {
    static let shared = APICaller() //static property and privatize constructor:
    
    private struct Constants { //specific member variables assigned when making an api call
        static let apiKey = "cffdeghr01qvo1ah6po0cffdeghr01qvo1ah6pog"
        //static let sandboxApiKey = ""
        static let baseUrl = "https://finnhub.io/api/v1/"
        //URL format is: https://api.api-ninjas.com/v1/exercises?muscle=biceps
        //URL format is: https://finnhub.io/api/v1/search?q=apple&token=cffdeghr01qvo1ah6po0cffdeghr01qvo1ah6pog
    }
    
    private init() {}
    
    //Public member functions:
    //Testing:
    public func search (
        query: String,
        completion: @escaping (Result<SearchResponse, Error>) -> Void )
    {
        //Performing a request:
        //Request func is implemented using URLSession.shared, so just do request func call
        request(url: url(for: .search, queryParams:  ["q":query]), expecting: SearchResponse.self, completion: completion)

        /* Test function code
        //queryParams is ["muscle:query(chest)]
        guard let url = url(for: .exercises, queryParams: ["muscle":query]) else {return} //creates url, endpoint is at exercises and queryparams start at "muscle"
        */
    }
    
    //Get stock info
    //Search stocks
    
    //Private member functions:
    //API endpoints (ask what this is)
    private enum Endpoint: String {
        case search //value assigned to object of type Endpoint, searchis type string
    }
    //Create custom error type that is enum so is assigned specific error types:
    private enum APIError: Error {
        case invalidUrl //type of error assigned to object of type APIError
        case noDataReturned
    }
    
    //client requests info from the server via a URL, the server responds to the request with data.
    
    /*private func url( //a func that outputs URL, input param thats Endpoint type and queryparams (not sure)
        for endpoint: Endpoint,
        queryParams: [String: String] = [:] //unordered map DS with key, value types as string, string, initialized to empty map
    ) -> URL? { //we want to parse the URL from the query ?muscle onwards so this is the function to implement that
        var urlString = Constants.baseUrl + endpoint.rawValue //take base URL and add (append) with the endpoint onwards
        let queryString = queryParams.map{ "\($0.key)=\($0.value ?? "")" }.joined(separator: "&")
        urlString += "?" + queryString //this is urlString to send to server to search for the exercise for a given muscle
        print("\n\(urlString)\n") //prints request to server from client
        return URL(string:urlString);
    }
     */
    
    private func url(
        for endpoint: Endpoint,
        queryParams: [String: String] = [:]
    ) -> URL? {
        var urlString = Constants.baseUrl + endpoint.rawValue //adds stuff after search to URL
        var queryItems = [URLQueryItem]()
        
        //Add any parameters: so URL will work for any cases of the API calls
        for (name, value) in queryParams {
            queryItems.append(.init(name: name, value: value)) //same as calling URLQueryItem constructor, just making object with same input params as the default constructor .init
        }
        
        //Add token:
        queryItems.append(.init(name: "token", value: Constants.apiKey)) //URLQuery item constructor is called and input params is token and apiKey, this is appended to queryItems which contains all the URLQueries we do
        
        //Convert query items to suffix string and join with & operator which joins query and then token
        let queryString = queryItems.map{ "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
        
        urlString += "?" + queryString //this is urlString to send to server to search for the exercise for a given muscle
        print("\n\(urlString)\n") //prints request to server from client
        return URL(string:urlString);
        
        /*
        Code for API with headerFields or Tokens
        var urlComponents = URLComponents(string: Constants.baseUrl + endpoint.rawValue)!
        var queryItems = [URLQueryItem]()
        for (key, value) in queryParams {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            print("Error: Could not create URL from components: \(urlComponents)")
            return nil
        }
        var request = URLRequest(url: url)
        if let headerFields = headerFields {
            for (field, value) in headerFields {
                request.addValue(value, forHTTPHeaderField: field)
                //request.setValue("YOUR_API_KEY", forHTTPHeaderField: "X-Api-Key")
            }
        }
        print("\n\(request)\n")
        return request.url
    }
    */
    }
        
    //Converting json to object to be modified by program:
    //T is a type that can be used as an object type in the program, so converts json to an object
    //function output is: -> void
    private func request<T: Codable> (
        url: URL?,
        expecting: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = url //creating url constant that is assigned url input param, if url input param is nil so not assignable in swift then just execute else statement (error)
        else {
            completion(.failure(APIError.invalidUrl)) //so url doesn't = url so invalid url so send that as error type when calling completion handler. only possible value of object of type APIError is invalidUrl
            return
        } //if url isn't nil then we execute code below:
        //dataTask with url, completion handler is output of request and we also have error return of request
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { //checks if error in the conditional check data==data and error == nil, if error then execute else: (exit func)
                if let error = error { //we check if error is error, if so then send error to completion handler
                    completion(.failure(error))
                }
                else { //if error isn't nil (no error) or error then unknownError
                    completion(.failure(APIError.noDataReturned))
                }
                
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data) //decodes instances (expecting) of data type T.Type from JSON file(data) and assigns to result
                completion(.success((result))) //send to completion handler and send back results
            }
            catch { // if there's an error/exception we execute catch code (which sends error to completion handler)
                    completion(.failure(error))
            }
        }
            task.resume() //resumes task operation
    
    }
    
}

