//
//  ViewPlaceholder.swift
//  TableViewPlaceholder
//
//  Created by Adrian Tabirta on 18.12.2017.
//  Copyright © 2017 Adrian Tabirta. All rights reserved.
//

import UIKit

final class ViewPlaceholder: UIView {

	enum PlaceholderState {
		case noConnection
		case loading
		case empty
		case none
	}
	
	@IBOutlet weak var contentView: UIView!

	@IBOutlet var noConnectionView: 			UIView?
	@IBOutlet var noConnectionTitleLabel: 		UILabel?
	@IBOutlet var noConnectionSubtitleLabel:	UILabel?
	@IBOutlet var noConnectionRetryButton:		UIButton?

	@IBOutlet var loadingView: 		UIView?
	
	@IBOutlet var noDataView:	 		UIView?
	@IBOutlet var noDataTitleLabel: 	UILabel?
	@IBOutlet var noDataSubtitleLabel:	UILabel?
	
	@IBOutlet var noneView: 		UIView?

	fileprivate lazy var retryClosure: () -> Void = { }
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		customInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		customInit()
	}
	
	private func customInit() {
		Bundle.main.loadNibNamed("ViewPlaceholder", owner: self, options: nil)
		addSubview(contentView)
		contentView.frame = self.bounds
		contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		configure(state: .none)
		configureTitles()
	}
	
	private func configureTitles() {
		// todo: localize strings
		
		noConnectionTitleLabel?.text 		= "No connetion"
		noConnectionSubtitleLabel?.text 	= "Oops! Looks like we don`t have connection. Try once again."
		noConnectionRetryButton?.setTitle("Try again", for: .normal)
		noDataTitleLabel?.text 				= "No data"
		noDataSubtitleLabel?.text			= "Oops! Looks like we don`t have any data to show you.  o_O"
	}
	
	private func configure(state: PlaceholderState) {
		switch state {
		case .noConnection:
			noConnectionView?.isHidden 	= false
			loadingView?.isHidden 		= true
			noDataView?.isHidden 		= true
			noneView?.isHidden			= true
			
		case .loading:
			noConnectionView?.isHidden 	= true
			loadingView?.isHidden 		= false
			noDataView?.isHidden 		= true
			noneView?.isHidden			= true
			
		case .empty:
			noConnectionView?.isHidden 	= true
			loadingView?.isHidden 		= true
			noDataView?.isHidden 		= false
			noneView?.isHidden			= true
			
		case .none:
			noConnectionView?.isHidden 	= true
			loadingView?.isHidden 		= true
			noDataView?.isHidden 		= true
			noneView?.isHidden			= false
		}
	}
	
	@IBAction fileprivate func retryAction(_ sender: UIButton) {
		retryClosure()
	}
}

// MARK: Public methods

extension ViewPlaceholder {
	
	/// Show loading view.
	@discardableResult
	func startLoading() -> Self {
		configure(state: .loading)
		return self
	}
	
	/// Fired when "No connection retry" is called.
	@discardableResult
	func onRetry(_ callback: @escaping () -> Void) -> Self {
		retryClosure = callback
		return self
	}
	
	/// Handle server response and show specific view.
	func handleRespunse(status: Bool, total: Int) {
		switch (status, total == 0) {
		case (true, false): configure(state: .none)
		case (true, true): configure(state: .empty)
		case (false, true): configure(state: .noConnection)
		default: configure(state: .none)
		}
	}
}
