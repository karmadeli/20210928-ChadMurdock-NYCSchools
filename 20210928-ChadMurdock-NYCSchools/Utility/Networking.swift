//
//  Networking.swift
//  20210928-ChadMurdock-NYCSchools
//
//  Created by Chad Murdock on 9/28/21.
//

import Foundation

typealias JSON = [String:Any]

extension String{
    static let token = "PU93hRCkNCQzDl5GVRHejfyVC"
    static let scoresUrl = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json"
    static let schoolsURL = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json"
}

struct NetWorking{
    
    /**
     Async request made to get the list of schools..
     - parameter completion: An array of Schools returned from the api request
     */
    static func getSchools(completion: @escaping ([School])->()){
        var comp = URLComponents(string: .schoolsURL)
        let params: [String: String] = ["$$app_token": .token]
        comp?.queryItems = params.map({ entry in
            return URLQueryItem(name: entry.key, value: entry.value)
        })
        guard let compURL = comp?.url else { return }
        let request = URLRequest(url: compURL)
        callOutForJSONArray(request: request) { results, error in
            guard error == nil else { completion([]); return }
            let schools = NetWorking.getSchoolsFrom(results)
            completion(schools)
        }
    }
    
    
    /**
     Async request made to get the school's SAT score.
     - parameter dbn:  The school's identifier.
     - parameter completion: An array of SchoolScores returned from the api request
     */
    static func getScores(dbn: String, completion: @escaping ([SchoolScore])->()){
        var comp = URLComponents(string: .scoresUrl)
        let params: [String: String] = ["$$app_token": .token, "dbn":dbn]
        comp?.queryItems = params.map({ entry in
            return URLQueryItem(name: entry.key, value: entry.value)
        })
        guard let compURL = comp?.url else { return }
        let request = URLRequest(url: compURL)
        callOutForJSONArray(request: request) { results, error in
            guard error == nil else { completion([]); return }
            let jsonData = NetWorking.getSchoolScoreFrom(results)
            completion(jsonData)
        }
    }
    
    
   private static func callOutForJSONArray(request: URLRequest, completion: @escaping (NSArray?, Error?)->()){
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { print(error as Any, " error"); completion(nil, error)
                ;return }
            var json: NSArray?
            do{
                json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSArray
                //print(json as Any, "JSON")
            }
            catch let err { print(err, "ERROR"); completion(nil, err) }
            completion(json, nil)
        }.resume()
    }
    
    private static func getSchoolScoreFrom(_ json: NSArray?)->[SchoolScore]{
        var result = [SchoolScore]()
        if let schools = json{
            for school in schools{
                var model = SchoolScore()
                if let schoolData = school as? JSON{
                    if let dbn = schoolData["dbn"] as? String{
                        model.dbn = dbn
                    }
                    if let testTakers = schoolData["num_of_sat_test_takers"] as? String{
                        model.testTakers = testTakers
                    }
                    if let reading = schoolData["sat_critical_reading_avg_score"] as? String{
                        model.reading = reading
                    }
                    if let math = schoolData["sat_math_avg_score"] as? String{
                        model.math = math
                    }
                    if let writing = schoolData["sat_writing_avg_score"] as? String{
                        model.writing = writing
                    }
                    if let schoolName = schoolData["school_name"] as? String{
                        model.schoolName = schoolName
                    }
                }
                result.append(model)
            }
        }
        return result
    }
    
    private static func getSchoolsFrom(_ json: NSArray?)->[School]{
        var result = [School]()
        if let schools = json {
            for school in schools{
                var model = School()
                if let schoolData = school as? JSON{
                    if let dbn = schoolData["dbn"] as? String{
                        model.dbn = dbn
                    }
                    if let borough = schoolData["borough"] as? String{
                        model.borough = borough
                    }
                    if let schoolName = schoolData["school_name"] as? String{
                        model.schoolName = schoolName
                    }
                    if let overview = schoolData["overview_paragraph"] as? String{
                        model.overview = overview
                    }
                    if let location = schoolData["location"] as? String{
                        model.location = location
                    }
                }
                result.append(model)
            }
        }
        return result.sorted { school0, school1 in
            return school0.schoolName < school1.schoolName
        }
    }
}
