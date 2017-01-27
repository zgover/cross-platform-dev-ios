//
//  Network.swift
//  CrossPlatformDev-iOS
//
//  Created by Zachary Gover on 1/26/17.
//  Copyright © 2017 Zachary Gover. All rights reserved.
//

import Foundation
import SystemConfiguration

public class Network {

	public static func isConnected() -> Bool {
		var zeroAddress = sockaddr_in()
		zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
		zeroAddress.sin_family = sa_family_t(AF_INET)

		guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
			$0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
				SCNetworkReachabilityCreateWithAddress(nil, $0)
			}
		}) else {
			return false
		}

		var flags: SCNetworkReachabilityFlags = []
		if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
			return false
		}

		let isReachable = flags.contains(.reachable)
		let needsConnection = flags.contains(.connectionRequired)

		return (isReachable && !needsConnection)
	}
}
