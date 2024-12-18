import Foundation

class CodeBuilder: CustomStringConvertible {

    private var buffer: String = ""

    init(){}
    init(_ buffer: String) {

        self.buffer = buffer
    }

    func append(_ s: String) -> CodeBuilder {

        buffer.append(s)
        return self
    }

    func appendLine(_ s: String) -> CodeBuilder {

        buffer.append("\(s)\n")
        return self
    }

    static func +=(cb: inout CodeBuilder, s: String) {
        cb.buffer.append("\(s)\n")
    }
    var description: String {
        return "\(buffer)"
    }
}


func main() {
    var cb = CodeBuilder()

    cb.appendLine("class Foo")
        .appendLine("{")

    cb += " // testing! ";
    cb.appendLine("}")
    print(cb)


}

main()
