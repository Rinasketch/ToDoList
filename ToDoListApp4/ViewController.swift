
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // 할 일 목록을 저장하는 배열
    var toDoList: [ToDoItem] = [
        ToDoItem(title: "눈사람 만들기"),
        ToDoItem(title: "샤브샤브 재료 사오기")
    ]

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self

        // + 버튼을 추가함
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        self.navigationItem.rightBarButtonItem = addButton
    }
    // + 버튼을 눌렀을 때 호출되는 메서드
    @objc func addButtonTapped() {
        let alertController = UIAlertController(title: "새로운 할 일 추가", message: nil, preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "할 일을 입력하세요"
        }
        // 추가 버튼을 눌렀을 때 할 일을 배열에 추가하고 테이블 뷰를 새로고침 함
        let addAction = UIAlertAction(title: "추가", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first, let newToDo = textField.text, !newToDo.isEmpty else { return }
            self?.toDoList.append(ToDoItem(title: newToDo))
            self?.tableView.reloadData()
        }

        alertController.addAction(addAction)

        present(alertController, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    // 할 일 목록에 체크 표시
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let todoItem = toDoList[indexPath.row]
        cell.textLabel?.text = todoItem.title

        if todoItem.isComplete {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    // 테이블 뷰의 삭제 버튼을 눌렀을 때 호출되는 메서드
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    // 테이블 뷰의 셀을 선택했을 때 호출되는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var todoItem = toDoList[indexPath.row]
        
        // 할 일의 완료 상태를 토글함
        todoItem.isComplete = !todoItem.isComplete
        toDoList[indexPath.row] = todoItem
        
        // 테이블 뷰의 해당 셀을 새로고침하여 체크 표시를 업데이트함
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
