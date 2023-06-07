import UIKit

final class SearchView: UIView {
    var textField: UITextField!
    var loupeButton: UIButton!

    var backgroundLayer: CALayer!

    override init(frame: CGRect) {
        super.init(frame: frame)

        initViews()
        constraintViews()

        initLayers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        resizeLayers()
    }

    private func initViews() {
        textField = UITextField()
        textField.delegate = self
        textField.placeholder = "Search"
        addSubview(textField)

        let loupeImage = UIImage(systemName: "magnifyingglass")
        loupeButton = UIButton()
        loupeButton.setImage(loupeImage, for: .normal)
        loupeButton.imageView?.tintColor = UIColor(hex: "#9A9A9A")
        loupeButton.imageView?.contentMode = .scaleAspectFit
        addSubview(loupeButton)
    }

    private func constraintViews() {
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.right.equalTo(loupeButton.snp.left).offset(-3)
            make.height.equalTo(39)
        }

        loupeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalTo(textField)
            make.height.equalTo(22)
            make.width.equalTo(20)
        }
    }

    private func initLayers() {
        layer.masksToBounds = false

        backgroundLayer = CALayer()
        backgroundLayer.masksToBounds = false
        backgroundLayer.backgroundColor = UIColor(hex: "#FCFCFC")?.cgColor
        backgroundLayer.shadowColor = UIColor.black.cgColor
        backgroundLayer.shadowOpacity = 0.35
        backgroundLayer.shadowRadius = 1
        backgroundLayer.shadowOffset = CGSize(width: 0, height: 0.5)
        layer.insertSublayer(backgroundLayer, at: 0)
    }

    private func resizeLayers() {
        let backgroundLayerOrigin = CGPoint.zero
        let backgroundLayerSize = CGSize(width: bounds.width, height: 39)
        backgroundLayer.frame = CGRect(origin: backgroundLayerOrigin, size: backgroundLayerSize)
        backgroundLayer.cornerRadius = backgroundLayerSize.height / 2
    }
}

extension SearchView: UITextFieldDelegate {

}
