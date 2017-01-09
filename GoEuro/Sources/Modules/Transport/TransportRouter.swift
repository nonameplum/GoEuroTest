//
//  TransportRouter.swift
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2017 Łukasz Śliwiński. All rights reserved.
//

import UIKit

@objc public protocol TransportRouting {
    func presentTransportDetailsFor(transportCellViewModel: TransportTableCellViewModel)
}

class TransportRouter: NSObject, TransportRouting {

    // mark: - Properties
    fileprivate let controller: TransportViewController

    // mark: - Initialization
    init(controller: TransportViewController) {
        self.controller = controller
    }

    // mark: - Methods
    func presentTransportDetailsFor(transportCellViewModel: TransportTableCellViewModel) {
        var title = ""
        if let priceIntegerPart = transportCellViewModel.priceIntegerPart,
            let priceDecimalPart = transportCellViewModel.priceDecimalPart {
            title = "\(priceIntegerPart)\(priceDecimalPart)"
        }
        let alertView = UIAlertView(title: title, message: "Offer details are not yet implemented!", delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
}
