//
//  ExpandableItemCell.swift
//  ExpandableCollectionViewKit
//
//  Created by Astemir Eleev on 06/10/2019.
//  Copyright © 2019 Astemir Eleev. All rights reserved.
//

import UIKit

final class ExpandableItemCell: UICollectionViewCell, ReuseIdentifiable {
    
    // MARK: - Settings
    
    var chevronAnimationDuration: TimeInterval = 0.3
    
    // MARK: - Properties
    
    let label = UILabel()
    let subitemsLabel = UILabel()
    let containerView = UIView()
    let chevronImageView = UIImageView()
    let iconImageView = UIImageView()
    let selectionView = UIView()
    var subitems: Int = 0
    
    var isChevronVisible: Bool = true {
        didSet {
            chevronImageView.isHidden = !isChevronVisible
        }
    }
      
    var shouldDisplayItemsCount: Bool = false {
        didSet {
            onExpansionUpdate()
        }
    }
    
    var image: UIImage? {
        didSet {
            iconImageView.image = image
        }
    }
    
    var itemTintColor: UIColor? {
        didSet {
            updateTypeImageViewTintColor()
        }
    }
    
    var indentLevel: Int = 0 {
        didSet {
            indentContraint.constant = CGFloat(imageInset * indentLevel.cgFloat)
        }
    }
    var isExpanded = false {
        didSet {
            configureChevronImageView()
            configureTypeImageView()
            
            if shouldDisplayItemsCount {
                onExpansionUpdate()
            }
        }
    }
    var isGroup = false {
        didSet {
            configureChevronImageView()
            configureTypeImageView()
        }
    }
    override var isHighlighted: Bool {
        didSet {
            configureChevronImageView()
            updateSelection()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            configureChevronImageView()
            updateSelection()
        }
    }
    
    fileprivate var indentContraint: NSLayoutConstraint! = nil
    fileprivate let inset = CGFloat(12)
    fileprivate lazy var imageInset = CGFloat(24)
    fileprivate lazy var utilityInset = CGFloat(16)
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureChevronImageView()
        configureTypeImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        selectionView.frame = contentView.bounds
    }
}

// MARK: - Cell Configuration

extension ExpandableItemCell {
    
    func configure() {
        selectionView.layer.cornerRadius = 5
        contentView.addSubview(selectionView)
        
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(chevronImageView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        containerView.addSubview(label)
        
        subitemsLabel.translatesAutoresizingMaskIntoConstraints = false
        subitemsLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        subitemsLabel.textColor = .systemGray2
        subitemsLabel.adjustsFontForContentSizeCategory = true
        subitemsLabel.textAlignment = .right
        containerView.addSubview(subitemsLabel)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconImageView)
        
        indentContraint = containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset)
        NSLayoutConstraint.activate([
            indentContraint,
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: inset),
            iconImageView.heightAnchor.constraint(equalToConstant: imageInset),
            iconImageView.widthAnchor.constraint(equalToConstant: imageInset),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: subitemsLabel.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            
            subitemsLabel.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: utilityInset),
            subitemsLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -utilityInset),
            subitemsLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            subitemsLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -utilityInset),
            chevronImageView.heightAnchor.constraint(equalToConstant: utilityInset),
            chevronImageView.widthAnchor.constraint(equalToConstant: utilityInset),
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            ])
    }
    
    func configureTypeImageView() {
        iconImageView.image = image
        iconImageView.contentMode = .scaleAspectFit
        
        updateTypeImageViewTintColor()
    }
    
    func updateTypeImageViewTintColor() {
        let highlighted = isHighlighted || isSelected
        iconImageView.tintColor = highlighted ? .gray : itemTintColor
    }
    
    func configureChevronImageView() {
        let rtl = effectiveUserInterfaceLayoutDirection == .rightToLeft
        let chevron = rtl ? "chevron.left" : "chevron.right" // SFSymbols image name id
        let chevronSelected = rtl ? "chevron.left" : "chevron.right" // SFSymbols image name id
        let highlighted = isHighlighted || isSelected
        
        if isGroup {
            let imageName = highlighted ? chevronSelected : chevron
            let image = UIImage(systemName: imageName)
            
            chevronImageView.image = image
            chevronImageView.contentMode = .scaleAspectFit
            
            let rtlMultiplier = rtl ? CGFloat(-1.0) : CGFloat(1.0)
            let rotationTransform = isExpanded ?
                CGAffineTransform(rotationAngle: rtlMultiplier * CGFloat.pi / 2) :
                CGAffineTransform.identity
            
            UIView.animate(withDuration: chevronAnimationDuration) {
                self.chevronImageView.transform = rotationTransform
            }
        } else {
            chevronImageView.image = nil
        }
        
        chevronImageView.tintColor = highlighted ? .gray : .systemGray2
    }
    
    func onExpansionUpdate() {
        if subitems > 0, !isExpanded, shouldDisplayItemsCount {
            UIView.transition(with: subitemsLabel,
                              duration: chevronAnimationDuration,
                              options: .transitionFlipFromTop,
                              animations: { [weak self] in
                                guard let self = self else { return }
                                self.subitemsLabel.text = "\(self.subitems)"
            },
                              completion: nil)
        } else {
            subitemsLabel.text = ""
        }
    }
    
    func updateSelection() {
        let selectionVisible: Bool = isHighlighted || isSelected
        selectionView.backgroundColor = selectionVisible ? UIColor(white: 0.95, alpha: 1) : .clear
    }
}
