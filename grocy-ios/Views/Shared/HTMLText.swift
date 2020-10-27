import SwiftUI

//struct HTMLText: View {
//    let htmlText: String
//
//    @State var attributedString: NSAttributedString = NSAttributedString(string: "")
//
//    private struct UIKLabel: UIViewRepresentable {
//
//        typealias TheUIView = UILabel
//        fileprivate var configuration = { (view: TheUIView) in }
//
//        func makeUIView(context: UIViewRepresentableContext<Self>) -> TheUIView { TheUIView() }
//        func updateUIView(_ uiView: TheUIView, context: UIViewRepresentableContext<Self>) {
//            configuration(uiView)
//        }
//    }
//
//    private func buildAttributedString(html: String) {
//        let data = Data(html.utf8)
//        if let attributedString = try? NSAttributedString(data: data,
//                                                          options: [.documentType: NSAttributedString.DocumentType.html],
//                                                          documentAttributes: nil)
//        {
////            return attributedString
//            self.attributedString = attributedString
//        } //else { return NSAttributedString(string: "") }
//    }
//
//    var body: some View {
////        UIKLabel(attributedString)
//        UIKLabel {
//            $0.attributedText = buildAttributedString(html: htmlText)
//        }
//    }
//}

struct HTMLText: UIViewRepresentable {
    
    //  var id: String
    var width: CGFloat
    var htmlText: String
    //  var cache: [String: UILabel]
    
    func makeUIView(context: Context) -> UILabel {
        //    if let existingLabel = cache[id] {
        //      return existingLabel
        //    }
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        //    cache[id] = label
        return label
    }
    
    func updateUIView(_ label: UILabel, context: Context) {
        label.preferredMaxLayoutWidth = width
        let data = Data(htmlText.utf8)
        DispatchQueue.main.async {
            if let attributedString = try? NSAttributedString(data: data,
                                                              options: [.documentType: NSAttributedString.DocumentType.html],
                                                              documentAttributes: nil)
            {
                ////            return attributedString
                label.attributedText = attributedString
            }
        }
        //    label.attributedText = text
    }
}

struct HTMLText_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            //            HTMLText(htmlText: "<p>affe<br></p>")
            HTMLText(width: 30, htmlText: "<p>affe<br></p>")
            Divider()
            Text("<p>affe<br></p>")
        }
    }
}
