//
//  TextEditor.swift
//  Crewards
//
//  Created by vabhaske on 24/07/20.
//

import SwiftUI

public struct TextEditor: View {
    @Binding public var text: String
    @Binding public var closeKeyboard : Bool
    
    public var body: some View {
        TextField_UI(text: $text, closeKeyboard: $closeKeyboard)
    }
}

struct TextField_UI : UIViewRepresentable {
    typealias UIViewType = UITextView
    
    @Binding var text: String
    @Binding var closeKeyboard: Bool
    var onEditingChanged: ((String) -> Void)?
    var onCommit: (() -> Void)?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, closeKeyboard)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = nil
        textView.text = text ?? ""
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textContainerInset = .zero
        
        textView.delegate = context.coordinator
        
        return textView
    }
    
    func updateUIView(_ textView: UITextView, context: Context) {
        textView.text = text ?? ""
        if(closeKeyboard == true){
            textView.resignFirstResponder()
        }
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var field: TextField_UI
        var myVal : Bool
        
        init(_ field: TextField_UI, _ closeKeyboard: Bool) {
            self.field = field
            self.myVal = closeKeyboard
        }
        
        func textViewDidChange(_ textView: UITextView) {
            field.text = textView.text
        }
    }
}

