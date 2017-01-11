//
//  AppUtils.swift
//  CrossPlatformDev-iOS
//
//  Created by Zachary Gover on 1/10/17.
//  Copyright © 2017 Zachary Gover. All rights reserved.
//

import Foundation
import UIKit

class AppUtils {

	private static var loadingContainer:UIView!

	public static func showAlertNotification(title: String, message: String, context: UIViewController) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		context.present(alert, animated: true, completion: nil)
	}

	public static func showLoadingScreen(view: UIView) {
		// Background
		let container: UIView = UIView()
		container.frame = view.frame
		container.center = view.center
		container.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)

		// Spinner and label background
		let loadingView: UIView = UIView()
		loadingView.frame = CGRect.init(x: 0, y: 0, width: 120, height: 120)
		loadingView.center = view.center
		loadingView.backgroundColor = UIColor.init(red: 68/255, green: 68/255, blue: 68/255, alpha: 0.7)
		loadingView.clipsToBounds = true
		loadingView.layer.cornerRadius = 10

		// Spinner icon to indicate loading
		let spinner: UIActivityIndicatorView = UIActivityIndicatorView()
		spinner.frame = CGRect.init(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
		spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
		spinner.center = CGPoint.init(x: loadingView.frame.size.width / 2,
		                              y: loadingView.frame.size.height / 3);

		// Loading label
		let label: UILabel = UILabel()
		label.text = "Loading..."
		label.textAlignment = NSTextAlignment.center
		label.textColor = UIColor.white
		label.frame = CGRect.init(x: 0.0, y: 0.0, width: 80.0, height: 30.0)
		label.center = CGPoint.init(x: loadingView.frame.size.width / 2,
									y: loadingView.frame.size.height - (label.frame.size.height));

		// Add all of the views to their parent
		loadingView.addSubview(spinner)
		loadingView.addSubview(label)
		container.addSubview(loadingView)
		view.addSubview(container)
		spinner.startAnimating()
		loadingContainer = container
	}

	public static func closeLoadingScreen() {
		if loadingContainer != nil {
			// If loading screen is present remove it and destroy the reference
			loadingContainer.removeFromSuperview()
			loadingContainer = nil
		}
	}

}
