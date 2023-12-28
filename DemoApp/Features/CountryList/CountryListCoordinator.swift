//
//  CountryListCoordinator.swift
//  DemoApp
//
//  Created by Mohammad Yasir Perwez on 28.12.23.
//

import UIKit

class CountryListCoordinator: Coordinator {
    var baseViewController: UIViewController?

    init(webService: WebService) {
        baseViewController = CountryListViewController(
            viewModel: CountryListViewModel(
                presentation: CountryListViewModel.Presentation(
                    title: "Countries",
                    countryList: []
                ),
                clientApi: CountryListViewClientAPILive(
                    webService: webService
                )
            )
        )
    }
}
