import UIKit

final class MainCollectionViewWordCell: UICollectionViewCell {
    public static let identifier = "MainCollectionViewWordCell"

    private(set) var word: Word?

    private var label: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initViews() {
        contentView.backgroundColor = UIColor(hex: "#F9F9F9")

        label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        label.textColor = .black
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(11)
            make.trailing.equalToSuperview().offset(-11)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.layer.cornerRadius = contentView.frame.height / 4
    }

    public func configure(for word: Word) {
        self.word = word

        label.text = word.string
    }
}
