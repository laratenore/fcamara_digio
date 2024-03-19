import Foundation
import UIKit

protocol HomePageViewDelegate: AnyObject {
    func didSelectBanner(productId: String)
}

protocol HomePageViewInterface: AnyObject {
    var delegate: HomePageViewDelegate? { get set }
    
    func build(configuration: HomePageView.Configuration)
}

class HomePageView: UIView, HomePageViewInterface {
    weak var delegate: HomePageViewDelegate?
    private var configuration: HomePageView.Configuration?
    
    // MARK: Views
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = Constants.topLabelText
        label.font = UIFont.systemFont(ofSize: Constants.smallLabelSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let spotlightBanner: BannerView = {
        let banner = BannerView()
        banner.translatesAutoresizingMaskIntoConstraints = false
        return banner
    }()
    
    private let cashBanner: BannerView = {
        let banner = BannerView()
        banner.translatesAutoresizingMaskIntoConstraints = false
        return banner
    }()
    
    private let productBanner: BannerView = {
        let banner = BannerView()
        banner.translatesAutoresizingMaskIntoConstraints = false
        return banner
    }()
    
    private let cashLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = Constants.cashLabelText
        label.font = UIFont.boldSystemFont(ofSize: Constants.largeLabelSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let digioLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = Constants.digioLabelText
        label.font = UIFont.boldSystemFont(ofSize: Constants.largeLabelSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = Constants.productsLabelText
        label.font = UIFont.boldSystemFont(ofSize: Constants.largeLabelSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Life cycle

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = .white
        
        addSubviews()
        defineSubviewsConstraints()
    }

    private func addSubviews() {
        addSubview(topLabel)
        addSubview(spotlightBanner)
        addSubview(digioLabel)
        addSubview(cashLabel)
        addSubview(cashBanner)
        addSubview(productsLabel)
        addSubview(productBanner)
        
        spotlightBanner.delegate = self
        cashBanner.delegate = self
        productBanner.delegate = self
    }
    
    private func defineSubviewsConstraints() {
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15),
            topLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            topLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            spotlightBanner.topAnchor.constraint(equalTo: self.topLabel.topAnchor, constant: 24),
            spotlightBanner.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            spotlightBanner.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            digioLabel.topAnchor.constraint(equalTo: self.spotlightBanner.bottomAnchor, constant: 24),
            cashLabel.topAnchor.constraint(equalTo: self.spotlightBanner.bottomAnchor, constant: 24),
            digioLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            cashLabel.leadingAnchor.constraint(equalTo: self.digioLabel.trailingAnchor, constant: 8),
            cashLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            digioLabel.centerYAnchor.constraint(equalTo: cashLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cashBanner.topAnchor.constraint(equalTo: self.digioLabel.bottomAnchor, constant: 16),
            cashBanner.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            cashBanner.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            productsLabel.topAnchor.constraint(equalTo: self.cashBanner.bottomAnchor, constant: 24),
            productsLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            productsLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            productBanner.topAnchor.constraint(equalTo: self.productsLabel.bottomAnchor, constant: 16),
            productBanner.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            productBanner.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            productBanner.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: View Configuration

extension HomePageView {
    struct Configuration {
        let banners: [BannerView.Configuration]
    }

    public func build(configuration: Configuration) {
        self.configuration = configuration
        configuration.banners.forEach({ item in
            switch item.type {
            case .spotlight:
                spotlightBanner.build(configuration: item)
            case .product:
                productBanner.build(configuration: item)
            case .cash:
                cashBanner.build(configuration: item)
            }
        })
    }
}

extension HomePageView: BannerViewDelegate {
    func didSelectBanner(productId: String) {
        //TODO: delegate do ViewController didTapBanner
    }
}

private extension HomePageView {
    enum Constants {
        static let topLabelText: String = "Olá, Maria"
        static let digioLabelText: String = "digio"
        static let cashLabelText: String = "Cash"
        static let productsLabelText: String = "Produtos"
        static let largeLabelSize: CGFloat = 25
        static let smallLabelSize: CGFloat = 15
    }
}
