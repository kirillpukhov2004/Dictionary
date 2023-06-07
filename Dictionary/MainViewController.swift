import UIKit
import Combine
import SnapKit

class MainViewController: UIViewController {
    var collectionView: UICollectionView!
    var collectionViewCompositionalLayout: UICollectionViewCompositionalLayout!
    var collectionViewDataSource: UICollectionViewDiffableDataSource<Int, Word>!

    var searchView: SearchView!

    var label: UILabel!
    var chevronImageView: UIImageView!

    var viewModel: MainViewModel
    var cancellables: Set<AnyCancellable>

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        self.cancellables = Set<AnyCancellable>()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground

        initViews()
        setupConstraints()
        setupBindings()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func initViews() {
        label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        view.addSubview(label)

        let chevronImage = UIImage(systemName: "chevron.down")
        chevronImageView = UIImageView(image: chevronImage)
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.tintColor = .black
        view.addSubview(chevronImageView)

        searchView = SearchView()
        view.addSubview(searchView)

        configureCollectionView()
    }

    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(5)
            make.centerX.equalTo(view)
            make.width.greaterThanOrEqualTo(8)
            make.height.equalTo(22)
        }

        chevronImageView.snp.makeConstraints { make in
            make.left.equalTo(label.snp.right).offset(5)
            make.centerY.equalTo(label)
            make.width.equalTo(14)
            make.height.equalTo(label)
        }

        searchView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(7)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(39)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(13)
            make.bottom.equalTo(view)
            make.left.equalTo(view).offset(16)
            make.right.equalTo(view).offset(-16)
        }
    }

    private func setupBindings() {
        viewModel.$languages
            .sink { languages in
                guard let language = languages.first else { return }
                self.label.text = language.string
            }
            .store(in: &cancellables)

        viewModel.$words
            .sink { [weak self] words in
                var snapshot = NSDiffableDataSourceSnapshot<Int, Word>()
                snapshot.appendSections([0])
                snapshot.appendItems(words)
                self?.collectionViewDataSource.apply(snapshot)
            }
            .store(in: &cancellables)
    }

    private func configureCollectionViewCompositionalLayout() {
        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                    heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)

        let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupLayoutSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8

        collectionViewCompositionalLayout = UICollectionViewCompositionalLayout(section: section)
    }

    private func configureCollectionViewDataSource() {
        let collectionViewCellProvider: UICollectionViewDiffableDataSourceReferenceCellProvider = { collectionView, indexPath, item in
            guard let word = item as? Word else { return UICollectionViewCell() }

            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MainCollectionViewWordCell.identifier,
                for: indexPath
            ) as? MainCollectionViewWordCell else {
                return UICollectionViewCell()
            }

            cell.configure(for: word)

            return cell
        }

        collectionViewDataSource = UICollectionViewDiffableDataSource<Int, Word>(collectionView: collectionView,
                                                                                 cellProvider: collectionViewCellProvider)
    }

    private func configureCollectionView() {
        configureCollectionViewCompositionalLayout()

        collectionView = UICollectionView(frame: view.frame,
                                          collectionViewLayout: collectionViewCompositionalLayout)
        collectionView.register(MainCollectionViewWordCell.self,
                                forCellWithReuseIdentifier: MainCollectionViewWordCell.identifier)

        view.addSubview(collectionView)

        configureCollectionViewDataSource()
    }

    private enum ChevronState {
        case up
        case down

        var image: UIImage {
            switch self {
            case .up:
                return UIImage(systemName: "chevron.up")!
            case .down:
                return UIImage(systemName: "chevron.down")!
            }
        }
    }
}
