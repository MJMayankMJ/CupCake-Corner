//
//  Order.swift
//  CupCake Corner
//
//  Created by Mayank Jangid on 10/16/24.
//
import SwiftUI

@Observable
class Order : Codable{
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _city = "city"
        case _streetAddress = "streetAddress"
        case _zip = "zip"
        // this is done so when u send encoded data to server the json contains type instead of _type, etc...
        //this is not a problem here cz the sites sends backs the same data and u store in _type but in real servers ---> name matters
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    var type = 0
    var quantity = 3

    var specialRequestEnabled = false{
        didSet{
            if specialRequestEnabled == false{
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    // first we'll check thro init if there is address stored in user default or not
    var name : String
    var streetAddress : String
    var city : String
    var zip : String
    
    var hasValidAddress: Bool{
        if streetAddress.trimmingCharacters(in: .whitespaces).isEmpty || city.trimmingCharacters(in: .whitespaces).isEmpty || zip.trimmingCharacters(in: .whitespaces).isEmpty || name.trimmingCharacters(in: .whitespaces).isEmpty{
            return false
        }
        return true
    }
    
    var cost: Decimal {
        //per cake base price
        var cost = Decimal(quantity) * 2

        // as aray increases the complexity in cake increases thus the cost increases
        cost += Decimal(type) / 2

        // $1/cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }

        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }

        return cost
    }
    init(){
        if let data = UserDefaults.standard.data(forKey: "Address") {
            if let decodedData = try? JSONDecoder().decode([String].self, from: data) {
                name = decodedData[0]
                streetAddress = decodedData[1]
                city = decodedData[2]
                zip = decodedData[3]
                return
            }
        }
        name = ""
        streetAddress = ""
        city = ""
        zip = ""
    }
}
