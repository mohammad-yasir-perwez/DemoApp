//
//  CountryListViewModel.swift
//  DemoApp
//
//  Created by Mohammad Yasir Perwez on 25.12.23.
//

import Combine

class CountryListViewModel: ObservableObject {

    struct Presentation: Equatable {
        let title: String
        var countryList: [Country]
    }

    @Published var presentation: Presentation
    let webservice: Webservice

    init(presentation: Presentation,
         webservice: Webservice
    ) {
        self.presentation = presentation
        self.webservice = webservice
    }
    
    func fetchCountry() {
        Task {
            do {
                self.presentation.countryList = try await webservice.fetch(
                    request: RequestBuilder.getAllCountries()
                )
            } catch {
                print(error)
            }
        }
    }
}
