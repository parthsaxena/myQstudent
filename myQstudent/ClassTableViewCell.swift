//
//  ClassTableViewCell.swift
//  myQstudent
//
//  Created by Parth Saxena on 10/11/19.
//  Copyright © 2019 Parth Saxena. All rights reserved.
//

import UIKit

class ClassTableViewCell: FoldingCell {

    var class_item: Class?
    
    //@IBOutlet weak var content_view: UIView!
    @IBOutlet weak var classTitle: UILabel!
    @IBOutlet weak var grade: UILabel!
    @IBOutlet weak var assignment_detail_classTitle: UILabel!
    
    // assignments
    @IBOutlet weak var assignment1_titleLabel: UILabel!
    @IBOutlet weak var assignment1_scoreLabel: UILabel!
    
    @IBOutlet weak var assignment2_titleLabel: UILabel!
    @IBOutlet weak var assignment2_scoreLabel: UILabel!
    
    @IBOutlet weak var assignment3_titleLabel: UILabel!
    @IBOutlet weak var assignment3_scoreLabel: UILabel!
    
    @IBOutlet weak var assignment4_titleLabel: UILabel!
    @IBOutlet weak var assignment4_scoreLabel: UILabel!
    
    @IBOutlet weak var assignment5_titleLabel: UILabel!
    @IBOutlet weak var assignment5_scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.classTitle.alpha = 0
        self.grade.alpha = 0
        self.foregroundView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.foregroundView.alpha = 1
        }
        UIView.animate(withDuration: 0.6, animations: {
            self.foregroundView.alpha = 1
        }) { (success) in
            UIView.animate(withDuration: 0.4) {
                self.classTitle.alpha = 1
                self.grade.alpha = 1
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func show() {
        foregroundView.layer.opacity = 0.8
        foregroundView.layer.cornerRadius = 20.0
        foregroundView.layer.shadowColor = UIColor.gray.cgColor
        foregroundView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        foregroundView.layer.shadowRadius = 15.0
        foregroundView.layer.shadowOpacity = 0.9                        
        
        self.classTitle.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.assignment_detail_classTitle.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.grade.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        self.grade.textAlignment = .right
        
        self.classTitle.text = class_item?.name!
        self.grade.text = class_item?.grade!
        
        self.assignment_detail_classTitle.text = class_item?.name!
        show_assignments()
    }
    
    func show_assignments() {
        print("Asssign Count: \(class_item?.assignments!.count)")
        if (class_item?.assignments!.indices.contains(0))! {
            assignment1_titleLabel.text = class_item?.assignments![0].title
            assignment1_scoreLabel.text = class_item?.assignments![0].grade
        }
        
        if (class_item?.assignments!.indices.contains(1))! {
            assignment2_titleLabel.text = class_item?.assignments![1].title
            assignment2_scoreLabel.text = class_item?.assignments![1].grade
        }
        
        if (class_item?.assignments!.indices.contains(2))! {
            assignment3_titleLabel.text = class_item?.assignments![2].title
            assignment3_scoreLabel.text = class_item?.assignments![2].grade
        }
        
        if (class_item?.assignments!.indices.contains(3))! {
            assignment4_titleLabel.text = class_item?.assignments![3].title
            assignment4_scoreLabel.text = class_item?.assignments![3].grade
        }
        
        if (class_item?.assignments!.indices.contains(4))! {
            assignment5_titleLabel.text = class_item?.assignments![4].title
            assignment5_scoreLabel.text = class_item?.assignments![4].grade
        }
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type: FoldingCell.AnimationType) -> TimeInterval {
        // durations count equal it itemCount
        let durations = [0.33, 0.26, 0.26] // timing animation for each view
        return durations[itemIndex]
    }

}
