import UIKit
import Combine

class CountryListView: UIView {
    
    private var subscriptions = Set<AnyCancellable>()
    private let viewModel: CountryListViewModel

    struct LocalConstant {
        static let cellHeight = 60.0
    }
    
    enum Section: CaseIterable {
        case country
//        case favoriteCountry
    }
    
    private lazy var countryTableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(CountryListCell.self,
                      forCellReuseIdentifier: String(
                        describing: CountryListCell.self
                      )
        )
        return view
    }()
    
    
    private func setup() {
        self.setupView()
        self.setupConstraint()
        self.bindToModel()
        self.viewModel.fetchCountry()
    }
    
    private func setupView() {
        self.countryTableView.dataSource = self
        self.countryTableView.delegate = self
        self.addSubview(self.countryTableView)
    }
    
    private func setupConstraint() {
        self.countryTableView.pinToSuperview()
    }
    
    private func updateUI(
        presentation: CountryListViewModel.Presentation
    ) {
        self.countryTableView.reloadData()
    }

    private func bindToModel() {
        let subcription = self.viewModel.$presentation.sink { presentation in
            DispatchQueue.main.async {
                self.updateUI(presentation: presentation)
            }
        }
        self.subscriptions.insert(subcription)
    }
    
    init(
        subscriptions: Set<AnyCancellable> = Set<AnyCancellable>(),
        model: CountryListViewModel
    ) {
        self.subscriptions = subscriptions
        self.viewModel = model
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CountryListView: UITableViewDataSource,
                           UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        self.viewModel.presentation.countryList.count
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        LocalConstant.cellHeight
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = self.viewModel.presentation.countryList[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: CountryListCell.self),
            for: indexPath) as! CountryListCell
        cell.presentation = CountryListCell.Presentation(
            name: country.name,
            capital: country.capital?.first ?? "",
            imageURL: URL(string: country.flagURL)
        )
        return cell
    }
}
