//
//  EmptyDataView.swift
//  BAYNOUNAH
//
//  Created by Jigar Khatri on 22/06/22.
//

import UIKit

class EmptyDataView: UIView {

    @IBOutlet private weak var contentView: UIView!
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func commonInit() {
        
        backgroundColor = .clear
        
        Bundle.main.loadNibNamed("EmptyDataView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        contentView.backgroundColor = .clear
        
        contentView.widthAnchor.constraint(lessThanOrEqualToConstant: 280).isActive = true

        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

        subtitleLabel.configureLable(textColor: UIColor.secondary, fontName: GlobalConstants.APP_FONT_Medium, fontSize: 12.0, text: "")
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        
//        imageView.isHidden = true
        titleLabel.isHidden = true
        subtitleLabel.isHidden = true
    }
    
    private func configure(imageName: String = "", title: String = "", subtitle: String = "", tintColor : UIColor?){
        
        imageView.backgroundColor = .clear
//        imageView.isHidden = imageName.count == 0
        imageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = tintColor
        
        titleLabel.configureLable(textColor: tintColor, fontName: GlobalConstants.APP_FONT_Bold, fontSize: 20.0, text: "")
        titleLabel.isHidden = title.count == 0
        titleLabel.text = title
        titleLabel.textAlignment = .center

        subtitleLabel.isHidden = subtitle.count == 0
        subtitleLabel.text = subtitle
        subtitleLabel.textAlignment = .center

        contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}

extension EmptyDataView{


}


