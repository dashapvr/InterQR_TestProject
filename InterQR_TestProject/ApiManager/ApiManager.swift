//
//  ApiManager.swift
//  InterQR_TestProject
//
//  Created by Дарья Пивовар on 08.01.2023.
//

import Foundation

protocol ApiGetDelegate {
    func didLoadDoors(_ apiManager: ApiManager, doors: [Door])
}

protocol ApiChangeStatusDelegate {
    func didChangeStatus(_ apiManager: ApiManager, status: String, index: Int)
}


struct ApiManager {
    var getDelegate: ApiGetDelegate?
    var changeStatusDelegate: ApiChangeStatusDelegate?
    let apiUrl = "https://api.doors.com"
    
    func fetchDoors() {
        let correctUrl = "\(apiUrl)/data/for/user/dashapvr"
        performGetRequest(urlString: correctUrl)
    }
    
    func fetchStatus(status: String, index: Int) {
        let correctUrl = "\(apiUrl)/status/change/for/user/dashapvr"
        performStatusRequest(urlString: correctUrl, status: status, index: index)
    }
    
    func performGetRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                let imitError: Error? = nil
                let imitData: [Door]? = DoorData.instance.getDoors()
                
                if imitError != nil {
                    print(imitError?.localizedDescription)
                    return
                }
                
                if let safeData = imitData {
                    if let doors = parseJSON(apiData: safeData) {
                        getDelegate?.didLoadDoors(self, doors: doors)
                    }
                }
            }
            task.resume()
        }
    }
    
    func performStatusRequest(urlString: String, status: String, index: Int) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            let session = URLSession(configuration: .default)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            do {
                let body = try JSONEncoder().encode(status)
                request.httpBody = body
                
                let task = session.dataTask(with: request) { data, response, error in
                    let imitError: Error? = nil
                    let imitData: [Door]? = DoorData.instance.getDoors()
                    let imitResponse: URLResponse
                    let imitResponseStatusCode = 200
                    
                    if imitError != nil {
                        print(imitError?.localizedDescription)
                    }
                    
                    guard imitData != nil else {
                        print("Error - in performStatusRequest data response check")
                        return
                    }
                    
                    do {
                        if imitResponseStatusCode == 200 {
                            changeStatusDelegate?.didChangeStatus(self, status: status, index: index)
                        } else {
                            print("Status code error")
                        }
                    } catch {
                        print("change status error")
                    }
                }
            } catch {
                print("Request error")
            }
        }
    }
    
    func parseJSON(apiData: [Door]) -> [Door]? {
        let decoder = JSONDecoder()
        do {
            // if real case
            //let decodedData = try decoder.(Door.self, from: apiData)
            
            // imitation
            let decodedData = apiData
            return decodedData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
