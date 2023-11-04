//
//  ProfileEngagemenTitleSectionView.swift
//  SearchGithub
//
//  Created by Nicolas Nshuti on 04/11/2023.
//

import UIKit

class ProfileEngagemenTitleSectionView: UITableViewHeaderFooterView {
    static let identifier = "ProfileEngagemenTitleSectionView"
    var clickAction: (() -> ())?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupMainView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMainView() {
        addSubview(mainView)
        [titleLabel, viewAllButton].forEach { mainView.addArrangedSubview($0) }
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: topAnchor),
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private lazy var mainView: UIStackView = {
        let view = UIStackView()
        view.spacing = 10
        view.axis = .horizontal
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var viewAllButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.right")
        config.imagePlacement = .trailing
        config.title = "View all"
        config.imagePadding = 10
        config.baseForegroundColor = .systemBlue
        config.baseBackgroundColor = .clear
        let button = UIButton()
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openEngagementView), for: .touchUpInside)
        return button
    }()
    
    func updateContent(with category: String, count: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.titleLabel.text = "\(category)"
            // TODO: Remove the ViewAllButton when count is less than 10 - Implement that
//            if count < 10 {
//                self.mainView.removeArrangedSubview(viewAllButton)
//            }
        }
    }
    @objc func openEngagementView() {
        clickAction?()
    }
}
