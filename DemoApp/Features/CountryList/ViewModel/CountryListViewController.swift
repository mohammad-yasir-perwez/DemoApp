import UIKit
import Combine

class CountryListViewController: UIViewController {
    let viewModel: CountryListViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
    }

    func setupView() {
        let countryView = CountryListView(
            model: viewModel
        )
        countryView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(countryView)
        countryView.pinToSuperview(insets: UIEdgeInsets.margin8)
    }
    init(viewModel: CountryListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview("Countries") {
    let controllers = CountryListViewController(
        viewModel: CountryListViewModel(
            presentation: CountryListViewModel.Presentation(
                title: "Countries",
                countryList: []
            ),
            clientApi: CountryListViewClientAPILive(
                webService: WebService.live
            )
        )
    )
    return controllers
}



