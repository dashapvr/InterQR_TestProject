//
//  DoorCell.swift
//  InterQR_TestProject
//
//  Created by Дарья Пивовар on 08.01.2023.
//

import UIKit

protocol StatusButtonDelegate {
    func changeStatus(cell: DoorCell)
}

class DoorCell: UITableViewCell {
    
    var delegate: StatusButtonDelegate?
    
    let titleLbl = UILabel()
    let positionLbl = UILabel()
    let statusBtn = UIButton()
    let shieldImage = UIImageView()
    let doorImage = UIImageView()
    let loadCircle = CircleAnimation()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        configureContentView()
        
        configureTitleLbl()
        configurePositionLbl()
        configureStatusBtn()
        configureShieldImage()
        configureDoorImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLoadAnimation() {
        doorImage.addSubview(loadCircle)
        loadCircle.snp.makeConstraints { make in
            make.top.equalTo(doorImage.snp_topMargin)
            make.bottom.equalTo(doorImage.snp_bottomMargin)
            make.right.equalTo(doorImage.snp_rightMargin)
            make.left.equalTo(doorImage.snp_leftMargin)
            make.size.equalTo(22)
        }
    }
    
    func threeDotsAnim() {
        let lay = CAReplicatorLayer()
        lay.frame = CGRect(x: 8, y: 18, width: 15, height: 7) //yPos == 12
        let circle = CALayer()
        circle.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
        circle.cornerRadius = circle.frame.width / 2
        circle.backgroundColor = UIColor.white.cgColor
        lay.addSublayer(circle)
        lay.instanceCount = 3
        lay.instanceTransform = CATransform3DMakeTranslation(10, 0, 0)
        let anim = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        anim.fromValue = 1.0
        anim.toValue = 0.2
        anim.duration = 1
        anim.repeatCount = .infinity
        circle.add(anim, forKey: nil)
        lay.instanceDelay = anim.duration / Double(lay.instanceCount)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            lay.removeFromSuperlayer()
        }
        shieldImage.layer.addSublayer(lay)
    }
    
    func configureCell(door: Door) {
        titleLbl.text = door.title
        positionLbl.text = door.position
        statusBtn.setTitle(door.status, for: .normal)
    }
    
    func unlockingDoor() {
        shieldImage.image = UIImage(named: Values.StatusImagesNames.shieldUnlocking)
        threeDotsAnim()
        statusBtn.setTitleColor(#colorLiteral(red: 0.8313726783, green: 0.8313726187, blue: 0.8313726187, alpha: 1), for: .normal)
        
        doorImage.image = UIImage(named: Values.StatusImagesNames.doorUnlocking)
        configureLoadAnimation()
        loadCircle.animate()
    }
    
    func unlockDoor() {
        doorImage.image = UIImage(named: Values.StatusImagesNames.doorUnlocked)
        loadCircle.removeFromSuperview()
        
        shieldImage.layer.removeAllAnimations()
        shieldImage.image = UIImage(named: Values.StatusImagesNames.shieldUnlocked)
        
        statusBtn.setTitleColor(#colorLiteral(red: 0.5039272904, green: 0.6311599612, blue: 0.7736265063, alpha: 1), for: .normal)
        statusBtn.setTitle(Values.DoorStatus.unlocked, for: .normal)
    }
    
    func lockDoor() {
        shieldImage.image = UIImage(named: Values.StatusImagesNames.shieldLocked)
        doorImage.image = UIImage(named: Values.StatusImagesNames.doorLocked)
        statusBtn.setTitleColor(#colorLiteral(red: 0.0002588513307, green: 0.2672565579, blue: 0.544146657, alpha: 1), for: .normal)
        statusBtn.setTitle(Values.DoorStatus.locked, for: .normal)
    }
    
    func configureDoorImage() {
        contentView.addSubview(doorImage)
        doorImage.image = UIImage(named: Values.StatusImagesNames.doorLocked)
        doorImage.clipsToBounds = true
        doorImage.contentMode = .scaleAspectFill
    }
    
    func configureShieldImage() {
        contentView.addSubview(shieldImage)
        shieldImage.image = UIImage(named: Values.StatusImagesNames.shieldLocked)
        shieldImage.clipsToBounds = true
        shieldImage.contentMode = .scaleAspectFill
    }
    
    func configureStatusBtn() {
        contentView.addSubview(statusBtn)
        statusBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        statusBtn.setTitleColor(#colorLiteral(red: 0.0002588513307, green: 0.2672565579, blue: 0.544146657, alpha: 1), for: .normal)
        statusBtn.titleLabel?.textColor = #colorLiteral(red: 0.0002588513307, green: 0.2672565579, blue: 0.544146657, alpha: 1)
        statusBtn.addTarget(self, action: #selector(changeDoorStatus), for: .touchUpInside)
    }
    
    @objc func changeDoorStatus() {
        delegate?.changeStatus(cell: self)
    }
    
    func configurePositionLbl() {
        contentView.addSubview(positionLbl)
        positionLbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        positionLbl.textColor = #colorLiteral(red: 0.725490272, green: 0.7254902124, blue: 0.725490272, alpha: 1)
    }
    
    func configureTitleLbl() {
        contentView.addSubview(titleLbl)
        titleLbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLbl.textColor = #colorLiteral(red: 0.1962750554, green: 0.2163220048, blue: 0.334228158, alpha: 1)
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
        
        shieldImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(27)
            make.top.equalToSuperview().offset(18)
        }
        
        doorImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-28)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(22)
            make.left.equalTo(shieldImage).offset(55)
        }
        
        positionLbl.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp_bottomMargin).offset(8)
            make.left.equalTo(shieldImage).offset(55)
        }
        
        statusBtn.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).offset(-14)
            make.centerX.equalTo(contentView)
        }
    }
}

