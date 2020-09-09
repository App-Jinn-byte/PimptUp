//
//  Reachability.swift
//  PimptUp
//
//  Created by JanAhmad on 21/02/2020.
//  Copyright © 2020 jinnbyte. All rights reserved.
//

import Foundation
import Alamofire

public class Reachability {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
