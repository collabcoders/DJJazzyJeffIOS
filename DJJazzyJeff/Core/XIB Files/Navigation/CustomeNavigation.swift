//
//  CustomeNavigation.swift
//  BAYNOUNAH
//
//  Created by Jigar Khatri on 13/07/22.
//

import UIKit

class CustomeNavigation: UIView {

    @IBOutlet private weak var contentView: UIView!

    
    @IBOutlet weak var lblTitle: UILabel!

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
        clipsToBounds = true
        
        Bundle.main.loadNibNamed("CustomeNavigation", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        contentView.backgroundColor = .clear
        
        
        //SET FONT
//        self.setButton()
    }
    

}
