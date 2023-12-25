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
            model: CountryListModel(
                presentation: CountryListModel.Presentation(
                    title: "Random countries",
                    countryList: []
                ),
                webservice: webservice
            )
        )
        countryView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(countryView)
        countryView.pinToSuperView()
    }
}

class CountryListView: UIView {

    private var subscriptions = Set<AnyCancellable>()

    let model: CountryListModel

    struct LocalConstant {
        static let CountrCellIdentifier = "CountryListCell"
        static let FavCountrCellIdentifier = "FavCountryListCell"
    }

    enum Section: CaseIterable {
        case country
        case favoriteCountry

        var identifier: String {
            switch self {
            case .country:
                return LocalConstant.CountrCellIdentifier
            case .favoriteCountry:
                return LocalConstant.FavCountrCellIdentifier
            }
        }
    }

    private lazy var dataSource = makeDataSource()

    private lazy var countryTableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = UITableView.automaticDimension
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
        self.model.fetchCountry()
    }

    private func setupView() {
        self.countryTableView.dataSource = self.dataSource
        self.addSubview(self.countryTableView)
    }

    private func setupConstraint() {
        self.countryTableView.pinToSuperView()
    }

    private func updateUI(presentation: CountryListModel.Presentation) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Country>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(presentation.countryList, toSection: .country)
        dataSource.apply(snapshot, animatingDifferences: true)

    }
    private func bindToModel() {
        let subcription = self.model.$presentation.sink { presentation in
            self.updateUI(presentation: presentation
            )
        }
        self.subscriptions.insert(subcription)
    }

    private func makeDataSource() -> UITableViewDiffableDataSource<Section, Country> {
        return UITableViewDiffableDataSource(
            tableView: countryTableView) { tableView, indexPath, country in
                let cell = self.countryTableView.dequeueReusableCell(
                    withIdentifier: LocalConstant.CountrCellIdentifier,
                    for: indexPath) as! CountryListCell
                cell.presentation = CountryListCell.Presentation(name: country.name,
                                                                 capital: country.capital?.first ?? "",
                                                                 imageURL: URL(string: country.flagURL))
                return cell
            }
    }

    init(
        subscriptions: Set<AnyCancellable> = Set<AnyCancellable>(),
         model: CountryListModel
    ) {
        self.subscriptions = subscriptions
        self.model = model
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CountryListModel: ObservableObject {

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


class CountryListCell: UITableViewCell {

    struct LocalConstant {
        static let internalMargin = 8.0
        static let flagDimensions = 48.0
    }

    struct Presentation: Equatable {
        let name: String
        let capital: String
        let imageURL: URL?
    }

    var presentation: Presentation? {
        didSet {
            guard self.presentation != oldValue else { return }
            updateUI()
        }
    }

    private lazy var flagView: UIImageView = {
        let view = UIImageView(frame: .zero)
        return view
    }()

    private lazy var nameView: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = .systemFont(ofSize: 16, weight: .bold)
        return view
    }()

    private lazy var capitalView: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = .systemFont(ofSize: 12, weight: .semibold)
        return view
    }()

    private lazy var container: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = LocalConstant.internalMargin
        return view
    }()

    private lazy var infoContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = LocalConstant.internalMargin
        return view
    }()

    private func setupView() {
        self.addSubview(self.container)
        [self.nameView, self.capitalView].forEach {
            infoContainer.addArrangedSubview($0)
        }

        [self.flagView, self.infoContainer].forEach {
            container.addArrangedSubview($0)
        }
        self.setupConstraint()
    }

    private func setupConstraint() {
        self.container.pinToSuperView()
        NSLayoutConstraint.activate([
            self.flagView.heightAnchor.constraint(equalToConstant: LocalConstant.flagDimensions),
            self.flagView.widthAnchor.constraint(equalToConstant: LocalConstant.flagDimensions)
        ])
    }

    private func updateUI() {
        guard let presentation = self.presentation else { return }
        self.nameView.text = presentation.name
        self.capitalView.text = presentation.capital

        if let url = presentation.imageURL {
            self.imageView?.load(url: url)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
        self.setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
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


extension UIView {
    func pinToSuperView() {
        guard let superView = self.superview else { return }
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalTo: superView.heightAnchor),
            self.widthAnchor.constraint(equalTo: superView.widthAnchor),
            self.centerXAnchor.constraint(equalTo: superView.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: superView.centerYAnchor)
        ])
    }
}
