import Foundation
import UIKit

enum BannerType: CaseIterable {
    case spotlight
    case cash
    case product
}
public protocol BannerViewDelegate: AnyObject {
    func didSelectBanner(productId: String)
}

public protocol BannerViewInterface {
    func build(configuration: BannerView.Configuration)
}

public final class BannerView: UIView, BannerViewInterface {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.cellVerticalMargin
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var itemsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let itemsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constants.cellHorizontalMargin
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    public weak var delegate: BannerViewDelegate?
    private var configuration: BannerView.Configuration?

    public init() {
        super.init(frame: .zero)
        addSubviews()
        defineSubviewsConstraints()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("Not implemented") }

    func populateBanners() {
        guard let configuration = configuration else {
            return
        }
        itemsStackView.removeAllArrangedSubviews()
        
        let products = configuration.products
        for product in products {
            let view = view(for: product)
            itemsStackView.addArrangedSubview(view)
        }
    }

    func view(for productData: ProductData) -> UIImageView {
        let view = getUIImageView()
        
        self.displayImageFromURL(productData.productURL) { result in
            switch result {
            case .success(let image):
                var screenWidth = UIScreen.main.bounds.width - 50
                var height = screenWidth / 2
                if productData.productType == .product {
                    screenWidth = UIScreen.main.bounds.width / 4
                    height = screenWidth
                }
                // Gesture for BannerClicking
                let gesture = UITapGestureRecognizer(target: self, action: #selector(self.bannerTapped(_:)))
                view.addGestureRecognizer(gesture)
                view.image = image
                view.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: screenWidth))
                view.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height))
            case .failure(let error):
                print(error)
            }
        }
        return view
    }
    
    @objc
    private func bannerTapped(_ gesture: UITapGestureRecognizer) {
       // TODO: delegate do HomePageView 
    }
    
    private func getUIImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = view.frame.height / 2
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4.0
        return view
    }

    private func displayImageFromURL(_ urlString: String, _ completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                let error = NSError(domain: "Error downloading image: \(error)", code: 0, userInfo: nil)
                completion(.failure(error))
            }
            
            guard let imageData = data else {
                print("No data received")
                return
            }
            if let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            } else {
                print("Unable to create image from data")
            }
        }.resume()
    }
}


public extension BannerView {
    struct Configuration {
        let type: ProductType
        let products: [ProductData]
    }

    func build(configuration: Configuration) {
        self.configuration = configuration
        if configuration.products.count <= 1 {
            itemsScrollView.isScrollEnabled = false
        }
        populateBanners()
    }
}

extension BannerView {
    public func addSubviews() {
        addSubview(stackView)
        itemsScrollView.addSubview(itemsStackView)
        stackView.addArrangedSubview(itemsScrollView)
    }

    public func defineSubviewsConstraints() {
        let spacing = Constants.horizontalMargin
        
        NSLayoutConstraint.activate([
            itemsStackView.leadingAnchor.constraint(equalTo: self.itemsScrollView.leadingAnchor, constant: spacing),
            itemsStackView.trailingAnchor.constraint(equalTo: self.itemsScrollView.trailingAnchor, constant: -spacing),
            itemsStackView.centerYAnchor.constraint(equalTo: self.itemsScrollView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            itemsScrollView.heightAnchor.constraint(equalTo: self.itemsStackView.heightAnchor),
            itemsScrollView.topAnchor.constraint(equalTo: self.stackView.topAnchor),
            itemsScrollView.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor),
            itemsScrollView.bottomAnchor.constraint(equalTo: self.stackView.bottomAnchor)
        ])
            
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 24),
            stackView.bottomAnchor.constraint(greaterThanOrEqualTo: self.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension BannerView {
    private enum Constants {
        static let cellHorizontalMargin: CGFloat = 12
        static let cellVerticalMargin: CGFloat = 8
        static let productCardWidth: CGFloat = 104
        static let horizontalMargin: CGFloat = 16
    }
}

extension UIStackView {
    @discardableResult
    func removeAllArrangedSubviews() -> [UIView] {
        return arrangedSubviews.reduce([UIView]()) { $0 + [removeArrangedSubViewProperly($1)] }
    }

    func removeArrangedSubViewProperly(_ view: UIView) -> UIView {
        removeArrangedSubview(view)
        NSLayoutConstraint.deactivate(view.constraints)
        view.removeFromSuperview()
        return view
    }
}
