//
//  postcell.swift
//  Instogrom
//
//  Created by Eddey on 2016/11/26.
//  Copyright © 2016年 EDiOS275. All rights reserved.
//

import UIKit



class postcell: UITableViewCell {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
        
    @IBOutlet weak var likeCount: UILabel!
   
    @IBOutlet weak var shareTapped: UIButton!
    @IBOutlet weak var likeTapped: UIButton!
        
    var delegate: CustomCellDelegate?
    
    
    func tappedTest(sender: UIImageView){
        
        delegate?.tapped(cell: self)
    }
    
    @IBAction func buttonTapped(sender: UIButton) {
        delegate?.shareButtonTapped(cell: self)

    }
    
    @IBAction func likeButtonTapped(sender: UIButton) {
        delegate?.likeButtonTapped(cell: self)
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
