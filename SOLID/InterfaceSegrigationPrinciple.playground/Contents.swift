import Foundation

class Document
{

}

//protocol Machine
//{
//    func print(d: Document)
//    func scan(d: Document)
//    func fax(d: Document)
//}

protocol Printer
{
    func print(d: Document)
}

protocol Scanner
{
    func scan(d: Document)
}

protocol Fax
{
    func fax(d: Document)
}

class OrdinaryPrinter: Printer{
    func print(d: Document) {

    }
}

class Photocopier: Printer, Scanner
{
    func print(d: Document) {

    }

    func scan(d: Document) {

    }
}

class MultiFunctionalDevice: Printer, Scanner, Fax{
    func print(d: Document) {

    }

    func scan(d: Document) {

    }

    func fax(d: Document) {
        
    }
}
//class MFP: Machine
//{
//    func scan(d: Document) {
//
//    }
//    
//    func fax(d: Document) {
//
//    }
//    
//    func print(d: Document) {
//    }
//
//}
