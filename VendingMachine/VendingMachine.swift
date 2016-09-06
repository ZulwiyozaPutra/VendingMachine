//
//  VendingMachine.swift
//  VendingMachine
//
//  Created by Zulwiyoza Putra on 9/5/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation

//Protocols

protocol ItemType {
    var price: Double { get }
    var quantity: Double { get set }
}

protocol VendingMachineType {
    var selection: [VendingSelection] { get }
    var inventory: [VendingSelection: ItemType] { get set}
    var amountDeposited: Double { get set }
    init(inventory: [VendingSelection: ItemType])
    func vend(selection: VendingSelection, quantity: Double) throws
    func deposit(amount: Double)
}

//Error Types

enum InventoryError: ErrorType {
    case InvalidResource
    case ConversionError
}

//Helper Classes

class PlistConverter {
    class func dictionaryFromFile(resource: String, ofType type: String) throws -> [String: AnyObject] {
        guard let path = NSBundle.mainBundle().pathForResource(resource, ofType: type) else {
            throw InventoryError.InvalidResource
        }
        guard let dictionary = NSDictionary(contentsOfFile: path),
        let castDictionary = dictionary as? [String: AnyObject] else {
            throw InventoryError.ConversionError
        }
        return castDictionary
    }
}

//ConcreteTypes

enum VendingSelection {
    case Soda
    case DietSoda
    case Chips
    case Cookie
    case Sandwich
    case Wrap
    case CandyBar
    case PopTart
    case Water
    case FruitJuice
    case SportsDrink
    case Gum
}

struct VendingItem: ItemType {
    var price: Double
    var quantity: Double
    
}

class VendingMachine: VendingMachineType {
    let selection: [VendingSelection] = [
    VendingSelection.Soda,
    VendingSelection.DietSoda,
    VendingSelection.Chips,
    VendingSelection.Cookie,
    VendingSelection.Sandwich,
    VendingSelection.Wrap,
    VendingSelection.CandyBar,
    VendingSelection.PopTart,
    VendingSelection.Water,
    VendingSelection.FruitJuice,
    VendingSelection.SportsDrink,
    VendingSelection.Gum]
    var inventory: [VendingSelection : ItemType]
    var amountDeposited: Double = 10.0
    required init(inventory: [VendingSelection : ItemType]) {
        self.inventory = inventory
    }
    func vend(selection: VendingSelection, quantity: Double) throws {
        //add code
    }
    func deposit(amount: Double) {
        //add code
    }
}

