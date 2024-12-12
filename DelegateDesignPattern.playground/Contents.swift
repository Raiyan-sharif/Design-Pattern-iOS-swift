import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

// Define the delegate protocol
protocol TaskManagerDelegate: AnyObject {
    func taskDidComplete(taskName: String)
    func taskDidFail(taskName: String, withError error: String)
}

// A class that delegates work
class TaskManager {
    weak var delegate: TaskManagerDelegate? // Delegate property must be weak to avoid retain cycles

    func performTask(taskName: String, shouldSucceed: Bool) {
        print("Performing task: \(taskName)")

        // Simulate task processing
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            if shouldSucceed {
                print("Task \(taskName) completed successfully.")
                self.delegate?.taskDidComplete(taskName: taskName)
            } else {
                print("Task \(taskName) failed.")
                self.delegate?.taskDidFail(taskName: taskName, withError: "An error occurred.")
            }
        }
    }
}

// A class that acts as the delegate
class TaskHandler: TaskManagerDelegate {
    func taskDidComplete(taskName: String) {
        print("Delegate received task completion notification for: \(taskName)")
    }

    func taskDidFail(taskName: String, withError error: String) {
        print("Delegate received task failure notification for: \(taskName). Error: \(error)")
    }
}

// Playground Usage
let taskManager = TaskManager()
let taskHandler = TaskHandler()

taskManager.delegate = taskHandler // Assign the delegate
taskManager.performTask(taskName: "DownloadImage", shouldSucceed: true)
taskManager.performTask(taskName: "UploadData", shouldSucceed: false)

