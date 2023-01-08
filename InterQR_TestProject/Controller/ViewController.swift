//
//  ViewController.swift
//  InterQR_TestProject
//
//  Created by Дарья Пивовар on 08.01.2023.
//

import SnapKit
import UIKit

class ViewController: UIViewController, ApiChangeStatusDelegate {
    func didChangeStatus(_ apiManager: ApiManager, status: String, index: Int) {
        //
    }
    
    let tableView = UITableView()
    let stackView = UIStackView()
    
    var doors = [Door]()
    var firstLoad: Bool = true
    var apiManager = ApiManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.apiManager.fetchDoors()
        }
        apiManager.getDelegate = self
        apiManager.changeStatusDelegate = self
        
        setView()
        configureTableView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.firstLoad = false
            self.tableView.reloadData()
            self.tableView.allowsSelection = true
        }
    }
}

extension ViewController: ApiGetDelegate {
    func didLoadDoors(_ apiManager: ApiManager, doors: [Door]) {
        // DispatchQueue.main.async {
        self.doors = doors
        print(doors)
        // }
    }
}

extension ViewController {
    
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.register(DoorCell.self, forCellReuseIdentifier: Values.Cells.doorCell)
        tableView.register(LoadingDoorCell.self, forCellReuseIdentifier: Values.Cells.loadingCell)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 131
        tableView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.left.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo(stackView.snp_bottomMargin).offset(84)
        }
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DoorData.instance.getDoors().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if firstLoad {
            let cell = tableView.dequeueReusableCell(withIdentifier: Values.Cells.loadingCell, for: indexPath) as! LoadingDoorCell
            tableView.allowsSelection = false
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Values.Cells.doorCell, for: indexPath) as! DoorCell
            cell.delegate = self
            let door = doors[indexPath.row]
            
            if door.status == Values.DoorStatus.unlocking {
                apiManager.fetchStatus(status: Values.DoorStatus.unlocking, index: indexPath.row)
                cell.unlockingDoor()
                tableView.allowsSelection = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.apiManager.fetchStatus(status: Values.DoorStatus.unlocked, index: indexPath.row)
                    cell.unlockDoor()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.apiManager.fetchStatus(status: Values.DoorStatus.unlocked, index: indexPath.row)
                        cell.unlockDoor()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.apiManager.fetchStatus(status: Values.DoorStatus.locked, index: indexPath.row)
                            cell.lockDoor()
                            tableView.allowsSelection = true
                        }
                    }
                }
            }
            self.doors[indexPath.row].status = Values.DoorStatus.locked
            cell.configureCell(door: door)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        doors[indexPath.row].status = Values.DoorStatus.unlocking
        tableView.reloadData()
    }
}

extension ViewController: StatusButtonDelegate {
    func changeStatus(cell: DoorCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        doors[indexPath.row].status = Values.DoorStatus.unlocking
        tableView.reloadData()
    }
}

extension ViewController {
    func setView() {
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(77.3)
            make.right.equalToSuperview().inset(27.0)
            make.left.equalToSuperview().inset(24.0)
        }
        
        // logo and settings stack
        let logoAndSettingStack = UIStackView()
        view.addSubview(logoAndSettingStack)
        logoAndSettingStack.axis = .horizontal
        logoAndSettingStack.distribution = .equalSpacing
        stackView.addArrangedSubview(logoAndSettingStack)
        
        // logo
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: Values.Elements.interQR)
        logoImageView.contentMode = .scaleAspectFit
        logoAndSettingStack.addArrangedSubview(logoImageView)
        
        // settings button
        let settingBtn = UIButton()
        settingBtn.setImage(UIImage(named: Values.Elements.settings), for: .normal)
        logoAndSettingStack.addArrangedSubview(settingBtn)
        
        // welcome and home stack
        let welcomeAndHomeStack = UIStackView()
        view.addSubview(welcomeAndHomeStack)
        welcomeAndHomeStack.axis = .horizontal
        welcomeAndHomeStack.distribution = .equalSpacing
        welcomeAndHomeStack.spacing = 50
        stackView.addArrangedSubview(welcomeAndHomeStack)
        
        // welcome Lbl
        let welcomeLbl = UILabel()
        welcomeLbl.text = Values.Elements.welcome
        welcomeLbl.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        welcomeAndHomeStack.addArrangedSubview(welcomeLbl)
        
        // home image
        let homeImageView = UIImageView()
        homeImageView.image = UIImage(named: Values.Elements.home)
        homeImageView.contentMode = .scaleAspectFill
        welcomeAndHomeStack.addArrangedSubview(homeImageView)
        
        // myDoors stack
        let myDoorsStack = UIStackView()
        view.addSubview(myDoorsStack)
        myDoorsStack.axis = .vertical
        myDoorsStack.spacing = 0
        stackView.addArrangedSubview(myDoorsStack)
        
        // myDoors Lbl
        let doorsLbl = UILabel()
        doorsLbl.text = Values.Elements.myDoors
        doorsLbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        myDoorsStack.addArrangedSubview(doorsLbl)
    }
}
