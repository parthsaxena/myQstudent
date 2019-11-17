//
//  ViewController.swift
//  myQstudent
//
//  Created by Parth Saxena on 10/10/19.
//  Copyright © 2019 Parth Saxena. All rights reserved.
//

import UIKit
import Pastel

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var classes = [Class]()
    
    var pastelView: PastelView!
    
    @IBOutlet weak var classesTableView: UITableView!
    var cellHeights: [CGFloat] = []
    
    var over_view: UIView!
    
    enum Const {
        static let closeCellHeight: CGFloat = 146
        static let openCellHeight: CGFloat = 361
        static var rowsCount = 6
    }
    
    private func setup() {
        cellHeights = Array(repeating: Const.closeCellHeight, count: Const.rowsCount)
        classesTableView.estimatedRowHeight = Const.closeCellHeight
        classesTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        over_view = UIView(frame: self.view.frame)
        over_view.backgroundColor = UIColor.white
        self.classesTableView.alpha = 0
                
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 22/255, blue: 84/255, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent = false
        
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: "my", attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.white/*UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)*/,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25.0, weight: UIFont.Weight.light)])
        navTitle.append(NSMutableAttributedString(string: "Q", attributes:[
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 29.0),
            NSAttributedString.Key.foregroundColor: UIColor(red: 127/255, green: 194/255, blue: 78/255, alpha: 1.0)]))
        navTitle.append(NSMutableAttributedString(string: "student", attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.white/*UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)*/,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25.0, weight: UIFont.Weight.light)]))

        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        DispatchQueue.main.async {
            self.classesTableView.backgroundColor = UIColor.clear
            self.classesTableView.delegate = self
            self.classesTableView.dataSource = self
            self.classesTableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.addSubview(over_view)
        pastelView = PastelView(frame: view.bounds)
        pastelView.animationDuration = 2.5
        
        pastelView.setColors([UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0),
                              UIColor(red: 73/255, green: 112/255, blue: 204/255, alpha: 1.0),
                              UIColor(red: 79/255, green: 167/255, blue: 89/255, alpha: 1.0),
                              UIColor(red: 198/255, green: 203/255, blue: 146/255, alpha: 1.0),
                              UIColor(red: 245/255, green: 48/255, blue: 88/255, alpha: 1.0)])
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
        UIView.animate(withDuration: 0.5, animations: {
            self.over_view.alpha = 0
            self.classesTableView.alpha = 1
        }) { (success) in
            //
        }
        print("animated")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return GlobalVars.classes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("loading")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassCell", for: indexPath) as! ClassTableViewCell
        
        cell.class_item = GlobalVars.classes[indexPath.row]
        cell.show()
        cell.layer.backgroundColor = UIColor.clear.cgColor
        // Configure the cell...

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = classesTableView.cellForRow(at: indexPath) as! ClassTableViewCell

        if cell.isAnimating() {
            return
        }

        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            
            //cell.unfold(true, animated: true, completion: nil)
            cell.unfold(true, animated: true) {
                /*cell.containerView.layer.opacity = 0.8
                cell.containerView.layer.cornerRadius = 20.0
                //cell.containerView.clipsToBounds = true
                cell.containerView.layer.masksToBounds = false
                cell.containerView.layer.shadowColor = UIColor.gray.cgColor
                cell.containerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                cell.containerView.layer.shadowRadius = 15.0
                cell.containerView.layer.shadowOpacity = 0.9*/
            }
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
                        
            if cell.frame.maxY > tableView.frame.maxY {
                tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        }, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as ClassTableViewCell = cell else {
            return
        }

        cell.containerView.clipsToBounds = true
        cell.containerView.layer.opacity = 0.8
        cell.containerView.layer.cornerRadius = 20.0
        cell.containerView.layer.shadowColor = UIColor.gray.cgColor
        cell.containerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.containerView.layer.shadowRadius = 15.0
        cell.containerView.layer.shadowOpacity = 0.9

        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
    }
    
}

