import UIKit

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
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
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
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var infoContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = LocalConstant.internalMargin
        return view
    }()

    private func setupView() {
        self.contentView.addSubview(self.container)
        self.setupContainerStack()
        self.setupInfoContainerStact()
        self.setupConstraint()
    }

    private func setupConstraint() {
        self.container.pinToSuperview()
        NSLayoutConstraint.activate([
            self.flagView.widthAnchor.constraint(equalToConstant: LocalConstant.flagDimensions).withPriority(.required)
        ])
    }
    
    private func setupContainerStack() {
        [self.nameView, self.capitalView].forEach {
            infoContainer.addArrangedSubview($0)
        }
    }

    private func setupInfoContainerStact() {
        [self.flagView, self.infoContainer].forEach {
            container.addArrangedSubview($0)
        }
    }

    private func updateUI() {
        guard let presentation = self.presentation else { return }
        self.nameView.text = presentation.name
        self.capitalView.text = presentation.capital

        if let url = presentation.imageURL {
            self.flagView.load(url: url)
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


#Preview("Countries1") {
    return CountryListView(
        model: CountryListViewModel(
            presentation: CountryListViewModel.Presentation(
                title: "Random countries",
                countryList: []
            ),
            clientApi: CountryListViewClientAPIMock(mock: {
                return [
                    Country(
                        name: "Yasir",
                        population: 100,
                        capital: ["Perwez"],
                        flagURL: "https://flagcdn.com/w320/cx.png"
                    )
                ]
            })
        )
    )
    }
