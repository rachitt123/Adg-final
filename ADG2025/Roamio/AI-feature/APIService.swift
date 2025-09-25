//
//  APIService.swift
//  ADG2025
//
//  Created by Rachit Tibrewal on 25/09/25.
//

////
////  APIService.swift
////  adg trial
////
//
//import Foundation
//import Alamofire
//
//// MARK: - Response model
//struct PredictionResponse: Codable {
//    let predicted_class: String
//    let predicted_index: Int
//    let probabilities: [Double]
//}
//
//// MARK: - API Service
//class APIService {
//    static let shared = APIService()
//    private init() {}
//
//    func uploadImage(_ imageData: Data, completion: @escaping (Result<PredictionResponse, Error>) -> Void) {
//        let apiUrl = "https://cyril-sabu-modelgravitasspace.hf.space/predict"
//
//        AF.upload(
//            multipartFormData: { formData in
//                formData.append(imageData,
//                                withName: "file",
//                                fileName: "image.jpg",
//                                mimeType: "image/jpeg")
//            },
//            to: apiUrl
//        )
//        .responseData { response in
//            switch response.result {
//            case .success(let data):
//                do {
//                    let result = try JSONDecoder().decode(PredictionResponse.self, from: data)
//                    completion(.success(result))
//                } catch {
//                    completion(.failure(error))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//}

//
//  APIService.swift
//  adg trial
//

import Foundation
import UIKit   // UIImages

class APIService {  // handle talking to server
    
    static let shared = APIService()   // helper to send to the model and we need only 1 helper
    private init() {} // no one else can make a api service
    
    
    func uploadImage(_ image: UIImage, completion: @escaping (Result<PredictionResponse, Error>) -> Void) {
        guard let apiUrl = URL(string: "https://cyril-sabu-modelgravitasspace.hf.space/predict"),
              let imageData = image.jpegData(compressionQuality: 0.8)
        else {
            completion(.failure(NSError(domain: "RequestError", code: -1,
                                        userInfo: [NSLocalizedDescriptionKey: "Invalid image or URL"])))
            return
        }

        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        
        // body wehre we put the image inside the request env
        var body = Data()// empty box will fill now
        body.appendString("--\(boundary)\r\n") // new section (bound tells a new section of code begins)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n")  //label/tag for the file inside the form.
        
        body.appendString("Content-Type: image/jpeg\r\n\r\n") // tells what kind of file it is
        body.append(imageData) // puts actual image bytes in the data
        body.appendString("\r\n") //line breaker
        body.appendString("--\(boundary)--\r\n") // closing boundary

        URLSession.shared.uploadTask(with: request, from: body) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return // stop here
            }
            guard let data = data
            else {
                completion(.failure(NSError(domain: "ResponseError", code: -1,
                                            userInfo: [NSLocalizedDescriptionKey: "No data from server"])))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(PredictionResponse.self, from: data)
                completion(.success(decoded))
                // JSONDecoder - helper to read json
                // decode(PredictionResponse.self, from: data)- Try to convert the raw data (server’s JSON reply)
              //  Into your Swift struct PredictionResponse.
                // PredictionResponse.self tells Swift: “I expect the data to match this struct’s format.”
                //completion(.success(decoded)) - passes the PredictionResponse back to your UI
            } catch {
                let raw = String(data: data, encoding: .utf8) ?? "<non-text>" // tries to convert raw data to string else non text
                
                print(" Raw server response:", raw) //prints raw server response
                completion(.failure(error)) // reports back to app that decode fails
            }
        }.resume() // imp  upload task created in pause state resumes it now
    }
}
// MARK: - Helper for multipart
fileprivate extension Data {
    mutating func appendString(_ string: String) // new func ,mutating = modifies itself() and only takes in a string
    {
        if let data = string.data(using: .utf8) { // converts string into computer readable bytes
            append(data)
            
            
            //string.data(using: .utf8) → turns the text into a Data object.
            //Example: "Hello" → [72, 101, 108, 108, 111].

           // append(data) → adds those bytes to the end of your existing body Data
        }
    }
}
