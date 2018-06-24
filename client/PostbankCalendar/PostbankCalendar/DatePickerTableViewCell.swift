//
//  DatePickerTableViewCell.swift
//  PostbankCalendar
//
//  Created by Alexander Karaatanassov on 24.06.18.
//  Copyright © 2018 wenchao. All rights reserved.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    func configure(with date: Date) {
        datePicker.date = date
    }
    

}
