//
//  ViewController3.swift
//  Stock Watch
//
//  Created by DERMALOG on 05/03/2021.
//

import UIKit

class ViewController3: UITableViewController {
    
    var array = [Setting]()
    let outputs = ["Compact", "Full"]
    let intervals = ["1min (1 minute)", "5min (5 minutes)", "15min (15 minutes)", "30min (30 minutes)", "60min (60 minutes)"]
    
    override func viewDidLoad() {
        array.append(Setting(title: "General"))
        array.append(Setting(title: "API Key", description: "demo"))
        array.append(Setting(title: "Output Size", description: "Compact"))
        array.append(Setting(title: "Intra Day"))
        array.append(Setting(title: "Interval", description: intervals[1]))
        
        if let key = KeyChain.shared[StorageUtils.KEY_APIKEY] {
            array[1].description = key
        }
        
        if let defaultInterval = StorageUtils.get(key: StorageUtils.KEY_INTERVAL) {
            var mIndex = 1
            for (index, item) in intervals.enumerated() {
                if (item.contains(defaultInterval)) {
                    mIndex = index
                    break
                }
            }
            array[4].description = intervals[mIndex]
        }
        
        if let defaultOutputSize = StorageUtils.get(key: StorageUtils.KEY_OUTPUTSIZE) {
            array[2].description = defaultOutputSize.capitalized
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = array[indexPath.row]
        switch item.type {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Header3", for: indexPath) as! Header3
            cell.labelHeader.text = item.title
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! Cell3
            cell.labelTitle.text = item.title
            cell.labelDescription.text = item.description
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 1:
            let ac = UIAlertController(title: "Enter API Key", message: nil, preferredStyle: .alert)
            ac.addTextField()
            let submitAction = UIAlertAction(title: "Save", style: .default) { [unowned ac] _ in
                let string = ac.textFields![0].text
                KeyChain.shared[StorageUtils.KEY_APIKEY] = string
                self.array[indexPath.row].description = string!
                tableView.reloadData()
            }
            ac.addAction(submitAction)
            present(ac, animated: true)
        case 2:
            let actionSheetController: UIAlertController = UIAlertController(title: "Output Size", message: "Please select a output option", preferredStyle: .actionSheet)
            let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel)
            actionSheetController.addAction(cancelActionButton)
            for option in outputs {
                let actionOption = UIAlertAction(title: option, style: .default) { [self] _ in
                    StorageUtils.set(key: StorageUtils.KEY_OUTPUTSIZE, value: option.lowercased())
                    self.array[indexPath.row].description = option
                    tableView.reloadData()
                }
                actionSheetController.addAction(actionOption)
            }
            self.present(actionSheetController, animated: true, completion: nil)
        default:
            let actionSheetController: UIAlertController = UIAlertController(title: "Interval", message: "Please select a interval option", preferredStyle: .actionSheet)
            let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel)
            actionSheetController.addAction(cancelActionButton)
            for option in intervals {
                let actionOption = UIAlertAction(title: option, style: .default) { [self] _ in
                    StorageUtils.set(key: StorageUtils.KEY_INTERVAL, value: option.components(separatedBy: " ")[0])
                    self.array[indexPath.row].description = option
                    tableView.reloadData()
                }
                actionSheetController.addAction(actionOption)
            }
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
}
