//
//  LoadingDoorCell.swift
//  InterQR_TestProject
//
//  Created by Дарья Пивовар on 08.01.2023.
//

import UIKit

class LoadingDoorCell: UITableViewCell {
    
    let loadAnim = LoadingCellAnimation()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        configureContentView()
        configureLoadAnimation()
        loadAnim.animate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLoadAnimation() {
        contentView.addSubview(loadAnim)
        loadAnim.snp.makeConstraints { make in
            
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView)
            make.size.equalTo(52)
        }
    }
    
    func configureContentView() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = #colorLiteral(red: 0.8887098432, green: 0.91862005, blue: 0.9181008935, alpha: 1)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 15
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0))
    }
}

