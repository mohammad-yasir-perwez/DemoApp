//
//  ViewController.swift
//  DemoApp
//
//  Created by Mohammad Yasir Perwez on 09.12.23.
//

import UIKit
import Combine

class CountryListViewController: UIViewController {
    let webservice =  Webservice.live

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
    }

    func setupView() {
        let countryView = CountryListView(
            model: CountryListViewModel(
                presentation: CountryListViewModel.Presentation(
                    title: "Random countries",
                    countryList: []
                ),
                webservice: webservice
            )
        )
        countryView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(countryView)
        countryView.pinToSuperview(insets: UIEdgeInsets.margin8)
    }
}


/**
 #Preview("Countries") {
 let controllers = CountryListViewController()
 return controllers
 }

 #Preview("Countries1") {
 let controllers = CountryListViewController()
 return controllers
 }

 */


