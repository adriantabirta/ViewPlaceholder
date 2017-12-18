//
//  ViewController.swift
//  TableViewPlaceholder
//
//  Created by Adrian Tabirta on 18.12.2017.
//  Copyright © 2017 Adrian Tabirta. All rights reserved.
//

import UIKit

final class SecoundViewController: UIViewController {

	@IBOutlet var mainLabel: 	UILabel?

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	func configureData(_ string: String) -> Self {
		mainLabel?.text = string
		return self
	}
}


