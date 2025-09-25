//
//  PredictionResponse.swift
//  adg trial
//
//  Created by Rachit Tibrewal on 25/09/25.

//
//  PredictionResponse.swift
//  adg trial
//

import Foundation   // imports framework provides codable and json decoder

struct PredictionResponse: Codable {  // container/blueprint whenever we get json it stores
    let predicted_class: String // holds the name of the monument that the model thinks it is
    let predicted_index: Int   // position no tj is 1 rf is 2   so sends it like that to sys
    let probabilities: [Double]  // how confident the model is of the monument
}
// codable can be converted to json and json to this thingi

