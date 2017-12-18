//
//  SecoundViewController.swift
//  TableViewPlaceholder
//
//  Created by Adrian Tabirta on 18.12.2017.
//  Copyright © 2017 Adrian Tabirta. All rights reserved.
//

import UIKit

final class FirstViewController: UIViewController {

	@IBOutlet var tableview: 	UITableView?
	
	var elements: [Int] = [1] 
	fileprivate lazy var emptyPlaceholder = ViewPlaceholder(frame: CGRect.zero).onRetry { [weak self] in self?.refreshData() }
	
	fileprivate lazy var refreshControl: UIRefreshControl = {
		$0.tintColor = .red
		$0.addTarget(self, action: #selector(refreshData), for: .valueChanged)
		return $0
	}(UIRefreshControl())
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableview?.addSubview(refreshControl)
		tableview?.tableFooterView 	= UIView()
		tableview?.backgroundView 	= emptyPlaceholder
		refreshData()
    }
	
	func loadMore() {
		loadDataWithProbability40({ success, total in
			self.emptyPlaceholder.handleRespunse(status: success, total: total)
		})
	}
	
	@objc func refreshData() {
		refreshControl.endRefreshing()
		elements.removeAll()
		tableview?.reloadData()
		emptyPlaceholder.startLoading()
		loadDataWithProbability40({ success, total in
			self.emptyPlaceholder.handleRespunse(status: success, total: total)
		})
	}
}

// MARK: - Private methods

extension FirstViewController {
	
	/// Simulated random server response with delay of 2 sec .
	func loadDataWithProbability40(_ callback: @escaping (Bool, Int) -> Void) {
		
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
			switch Int.random(min: 0, max: 2) {
			case 0:
				/*
					Simulate netwok failure.
				*/
				callback(false, 0)
				
			case 1:
				/*
					Simulate success network request
					with no data returned.
				*/
				callback(true, 0)
				
			default:
				/*
					Simulate success.
					Add 10 elements to array.
				*/
				self.elements.append(contentsOf: (0..<10))
				self.tableview?.reloadData()
				callback(true, 10)
			}
		}
	}
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension FirstViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return elements.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		cell.textLabel?.text = indexPath.row.description
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = (UIStoryboard(name: "Main", bundle: nil)
			.instantiateViewController(withIdentifier: "SecoundViewController") as! SecoundViewController)
			.configureData("Selected cell: " + elements[indexPath.row].description)
		navigationController?.pushViewController(vc, animated: true)
	}
}



public extension Int {
	
	/// Returns a random Int point number between 0 and Int.max.
	public static var random: Int {
		return Int.random(n: Int.max)
	}
	
	/// Random integer between 0 and n-1.
	///
	/// - Parameter n:  Interval max
	/// - Returns:      Returns a random Int point number between 0 and n max
	public static func random(n: Int) -> Int {
		return Int(arc4random_uniform(UInt32(n)))
	}
	
	///  Random integer between min and max
	///
	/// - Parameters:
	///   - min:    Interval minimun
	///   - max:    Interval max
	/// - Returns:  Returns a random Int point number between 0 and n max
	public static func random(min: Int, max: Int) -> Int {
		return Int.random(n: max - min + 1) + min
		
	}
}




