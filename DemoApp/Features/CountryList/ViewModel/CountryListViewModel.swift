
import Combine

class CountryListViewModel: ObservableObject {

    struct Presentation: Equatable {
        let title: String
        var countryList: [Country]
    }

    @Published var presentation: Presentation
    let clientApi: CountryListViewClientAPI


    init(presentation: Presentation,
         clientApi: CountryListViewClientAPI
    ) {
        self.presentation = presentation
        self.clientApi = clientApi
    }
    
    func fetchCountry() {
        Task {
            do {
                self.presentation.countryList = try await clientApi.fetchCountry()
            } catch {
                print(error)
            }
        }
    }
}

protocol CountryListViewClientAPI {
    func fetchCountry() async throws -> [Country]
}


struct CountryListViewClientAPILive: CountryListViewClientAPI {
    let webService: WebService
    func fetchCountry() async throws -> [Country] {
        try await webService.fetch(request: RequestBuilder.getAllCountries())
    }
}


struct CountryListViewClientAPIMock: CountryListViewClientAPI {
    var mock: () throws -> [Country]

    func fetchCountry() async throws -> [Country] {
        try await Task {
            return try mock()
        }.value
    }

    init(mock: @escaping () throws -> [Country]) {
        self.mock = mock
    }
}
