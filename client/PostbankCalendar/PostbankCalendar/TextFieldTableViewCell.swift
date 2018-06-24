//
//  TextFieldTableViewCell.swift
//  PostbankCalendar
//
//  Created by Alexander Karaatanassov on 24.06.18.
//  Copyright © 2018 wenchao. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    func configure(with text: String) {
        textField.text = text
    }

}
