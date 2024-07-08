import Foundation

class Journal : CustomStringConvertible
{
    var description: String{
        return entries.joined(separator: "\n")
    }

    var entries = [String]()
    var count = 0

    func addEntry(_ text: String) -> Int
    {
        count += 1
        entries.append("\(count): \(text)")
        return count - 1
    }

    func removeEntry(_ index: Int)
    {
        entries.remove(at: index)
    }
}

func main(){
    let j = Journal()
    j.addEntry("I cried tody")
    let bug = j.addEntry("I ate a bug")
    print(j)
    j.removeEntry(bug)
    print(j)


}

main()
