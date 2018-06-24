import UIKit

class EventViewController: UITableViewController {
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    var isEditScreen = false
    var id = -1
    var title = ""
    var description = ""
    var startDate = ""
    var endDate = ""
    
    func configure(with event: EventModel, shouldEdit toEdit: Bool) {q
        isEditScreen = toEdit
        id = event.id
        title = event.title
        description = event.description
        startDate = event.startDate
        endDate = event.endDate
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // title
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleTextView") as? TextFieldTableViewCell
            cell.textField.text = "Въведете заглавие на събитието"
            return cell
        case 1: // description
            print("description")
            // TO DO
        case 2: // start date
            print("start date")
            cell.accessoryType = indexPath.row == Int(firstWeekday-1) ? .checkmark : .none;
        case 3: // end date
            print("end date")
            // TO DO
        case 4: // reminder
            print("reminder")
            // TO DO
        case 5: // Save/Edit/Close
            print("close button (save/edit/close)")
            // TO DO
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        switch indexPath.section {
//        case 0:
//            scrollDirection = FSCalendarScrollDirection(rawValue: UInt(1-indexPath.row))!
//        case 2:
//            if let datePickerCell = cell as? DatePickerCell {
//                startDate = dateFormatter.string(from: cell.datePicker.date)
//            }
//        case 2:
//            firstWeekday = UInt(indexPath.row + 1)
//        default:
//            break
//        }
        
        print("here")
        
        switch indexPath.section {
        case 0: // title
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleTextView") as? TextFieldTableViewCell
            title = cell.textField.text
        case 1: // description
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionTextView") as? TextFieldTableViewCell
            description = cell.textField.text
        case 2: // start date
            let cell = tableView.dequeueReusableCell(withIdentifier: "startDatePicker") as? DatePickerTableViewCell
            startDate = cell.datePicker.date
        case 3: // end date
            let cell = tableView.dequeueReusableCell(withIdentifier: "endDatePicker") as? DatePickerTableViewCell
            endDate = cell.datePicker.date
        case 4: // reminder
            print("reminder")
        case 5: // Save/Edit/Close
            print("close button (save/edit/close)")
            // send request here
        default:
            break
        }
        
//        tableView.reloadSections([indexPath.section] as IndexSet, with: .none)
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) {
//            self.performSegue(withIdentifier: "unwindToScope", sender: self)
//        }
    }
    
}
