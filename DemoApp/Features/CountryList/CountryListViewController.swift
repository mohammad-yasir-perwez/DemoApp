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
                clientApi: CountryListViewClientAPILive(webService: webservice)
            )
        )
        countryView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(countryView)
        countryView.pinToSuperview(insets: UIEdgeInsets.margin8)
    }
}

 #Preview("Countries") {
 let controllers = CountryListViewController()
 return controllers
 }



