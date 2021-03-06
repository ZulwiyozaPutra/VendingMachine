//
//  VendingMachine.swift
//  VendingMachine
//
//  Created by Zulwiyoza Putra on 9/5/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation
import UIKit

//Protocols

protocol ItemType {
    var price: Double { get }
    var quantity: Double { get set }
}

protocol VendingMachineType {
    var selection: [VendingSelection] { get }
    var inventory: [VendingSelection: ItemType] { get set}
    var amountDeposited: Double { get set }
    init(inventory : [VendingSelection: ItemType])
    func vend(selection: VendingSelection, quantity: Double) throws
    func deposit(amount: Double)
    func itemForCurrentSelection(selection: VendingSelection) -> ItemType?
}

//Error Types

enum InventoryError: Error {
    case InvalidResource
    case ConversionError
    case InvalidKey
}

enum VendingMachineError: Error {
    case InvalidSelection
    case OutOfStock
    case InsufficientFunds(required: Double)
}


//Helper Classes

class PlistConverter {
    class func dictionaryFromFile(resource: String, ofType type: String) throws -> [String: AnyObject] {
        guard let path = Bundle.main.path(forResource: resource, ofType: type) else {
            throw InventoryError.InvalidResource
        }
        guard let dictionary = NSDictionary(contentsOfFile: path),
        let castDictionary = dictionary as? [String: AnyObject] else {
            throw InventoryError.ConversionError
        }
        return castDictionary
    }
}

class InventoryUnarchiver {
    class func vendingInventoryFromDictionary(dictionary: [String: AnyObject]) throws  -> [VendingSelection: ItemType] {
        var inventory: [VendingSelection: ItemType] = [:]
        for (key, value) in dictionary {
            if let itemDict = value as? [String: Double],
            let price = itemDict["price"],
            let quantity = itemDict["quantity"] {
                let item = VendingItem(price: price, quantity: quantity)
                guard let key = VendingSelection(rawValue: key) else {
                    throw InventoryError.InvalidKey
                }
                inventory.updateValue(item, forKey: key)
            }
        }
        return inventory
    }
}

//ConcreteTypes

enum VendingSelection: String {
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
    
    func icon() -> UIImage {
        if let image = UIImage(named: self.rawValue) {
            return image
        } else {
            return UIImage(named: "Default")!
        }
    }
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
        guard var item = inventory[selection] else {
            throw VendingMachineError.InvalidSelection
        }
        guard item.quantity > quantity else {
            throw VendingMachineError.OutOfStock
        }
        item.quantity = item.quantity - quantity
        let totalPrice = item.price * quantity
        if amountDeposited >= totalPrice {
            amountDeposited = amountDeposited - totalPrice
        } else {
            let amountRequired = totalPrice - amountDeposited
            throw VendingMachineError.InsufficientFunds(required: amountRequired)
        }
    }
    func itemForCurrentSelection(selection: VendingSelection) -> ItemType? {
        return inventory[selection]
    }
    
    func deposit(amount: Double) {
        //add code
    }
}


