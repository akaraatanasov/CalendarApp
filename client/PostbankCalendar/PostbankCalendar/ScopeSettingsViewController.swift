import UIKit

class ScopeSettingsViewController: UITableViewController {
    
    var firstWeekday: UInt = 1
    var scrollDirection: FSCalendarScrollDirection = .horizontal
    var selectedDate: Date?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        switch indexPath.section {
        case 0:
            cell.accessoryType = indexPath.row == 1 - Int(scrollDirection.rawValue) ? .checkmark : .none;
        case 2:
            cell.accessoryType = indexPath.row == Int(firstWeekday-1) ? .checkmark : .none;
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            scrollDirection = FSCalendarScrollDirection(rawValue: UInt(1-indexPath.row))!
        case 1:
            selectedDate = datePicker.date;
        case 2:
            firstWeekday = UInt(indexPath.row + 1)
        default:
            break
        }
        
        tableView.reloadSections([indexPath.section] as IndexSet, with: .none)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) {
            self.performSegue(withIdentifier: "unwindToScope", sender: self)
        }
    }
    
}
