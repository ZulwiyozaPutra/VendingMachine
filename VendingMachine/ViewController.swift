//
//  ViewController.swift
//  VendingMachine
//
//  Created by Pasan Premaratne on 1/19/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit

private let reuseIdentifier = "vendingItem"
private let screenWidth = UIScreen.mainScreen().bounds.width

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    let vendingMachine: VendingMachineType
    var currentSelection: VendingSelection?
    var quantity: Double = 1.0
    
    required init?(coder aDecoder: NSCoder) {
        do {
            let dictionary = try PlistConverter.dictionaryFromFile("VendingInventory", ofType: "plist")
            let inventory = try InventoryUnarchiver.vendingInventoryFromDictionary(dictionary)
            self.vendingMachine = VendingMachine(inventory: inventory)
        } catch let error {
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupCollectionViewCells()
        print(vendingMachine.inventory)
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        updateQuantityLabel()
        updateBalanceLabel()
    }
    
    // MARK: - UICollectionView 

    func setupCollectionViewCells() -> Void {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        let padding: CGFloat = 10
        layout.itemSize = CGSize(width: (screenWidth / 3) - padding, height: (screenWidth / 3) - padding)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        collectionView.collectionViewLayout = layout
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vendingMachine.selection.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! VendingItemCell
        let item = vendingMachine.selection[indexPath.row]
        cell.iconView.image = item.icon()
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) -> Void {
        updateCellBackgroundColor(indexPath, selected: true)
        currentSelection = vendingMachine.selection[indexPath.row]
        updateTotalPriceLabel()
        reset()
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) -> Void {
        updateCellBackgroundColor(indexPath, selected: false)
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) -> Void {
        updateCellBackgroundColor(indexPath, selected: true)
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) -> Void {
        updateCellBackgroundColor(indexPath, selected: false)
    }
    
    func updateCellBackgroundColor(indexPath: NSIndexPath, selected: Bool) -> Void {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            cell.contentView.backgroundColor = selected ? UIColor(red: 41/255.0, green: 211/255.0, blue: 241/255.0, alpha: 1.0) : UIColor.clearColor()
        }
    }
    
    // MARK: - Helper Methods
    
    @IBAction func purchase() -> Void {
        if let currentSelection = currentSelection {
            do {
                try vendingMachine.vend(currentSelection, quantity: quantity)
                updateBalanceLabel()
            } catch VendingMachineError.OutOfStock {
                showAlert()
            } catch {
                //FIXME: Error Handling Catch Code
            }
        } else {
            //FIXME: Alert User to no selection
        }
    }
    @IBAction func updateQuantity(sender: UIStepper) -> Void {
        print(sender.value)
        quantity = sender.value
        updateTotalPriceLabel()
        updateQuantityLabel()
    }
    func updateTotalPriceLabel() -> Void {
        if let currentSelection = currentSelection,
            let item = vendingMachine.itemForCurrentSelection(currentSelection) {
            totalLabel.text = "$\(item.price * quantity)"
        }
    }
    func updateQuantityLabel() -> Void {
        quantityLabel.text = "\(Int(quantity))"
    }
    func updateBalanceLabel() -> Void {
        balanceLabel.text = "$\(vendingMachine.amountDeposited)"
    }
    func reset() -> Void {
        quantity = 1
        updateQuantityLabel()
        updateTotalPriceLabel()
    }
    func showAlert() -> Void {
        let alertController = UIAlertController(title: "Out of Stock", message: "We are sorry the item you want is out of stock", preferredStyle: UIAlertControllerStyle.Alert)
        presentViewController(alertController, animated: true, completion: nil)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: dismissAlert)
        alertController.addAction(okAction)
    }
    func dismissAlert(sender: UIAlertAction) -> Void {
        reset()
    }
    
}

