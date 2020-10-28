//
//  MyTextField.swift
//  grocy-ios
//
//  Created by Georg Meissner on 28.10.20.
//

import SwiftUI

struct MyTextField: View {
    @Binding var textToEdit: String
    var description: String
    @Binding var isCorrect: Bool
    @State var isEnteringText: Bool
    var leadingIcon: String?
    
    init(textToEdit: Binding<String>, description: String, isCorrect: Binding<Bool>, leadingIcon: String? = nil) {
        self._textToEdit = textToEdit
        self.description = description
        self._isCorrect = isCorrect
        self.leadingIcon = leadingIcon
        
        self._isEnteringText = State(initialValue: !textToEdit.wrappedValue.isEmpty)
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                Text(description)
                    .font(isEnteringText ? .caption : .body)
                    .foregroundColor(isCorrect ? Color.gray : Color.red)
                    .padding(.top, isEnteringText ? 0 : 16)
                    .padding(.leading, (leadingIcon == nil || isEnteringText) ? 0 : 30)
                    .zIndex(0)
            }
            HStack {
                if leadingIcon != nil {
                    Image(systemName: leadingIcon!)
                        .padding(.top, 15)
                        .frame(width: 20, height: 20)
                }
                TextField("", text: self.$textToEdit)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textContentType(.URL)
                    .font(.body)
                    //                    .foregroundColor(.white)
                    //                    .padding(.bottom, 15)
                    .padding(.top, 15)
                    .onTapGesture {
                        self.isEnteringText = true
                    }
                    .onChange(of: textToEdit, perform: { value in
                        if textToEdit.isEmpty {
                            self.isEnteringText = false
                        } else {
                            self.isEnteringText = true
                        }
                    })
                    .zIndex(1)
            }
            VStack {
                Divider()
                    .background(isCorrect ? Color.primary : Color.red)
                    .padding(.top, 40)
                    .zIndex(2)
            }
        }
        .animation(.default)
        //        .background(Color.blue)
    }
}

struct MyTextField_Previews: PreviewProvider {
    static var previews: some View {
        MyTextField(textToEdit: Binding.constant(""), description: "Beschreibung", isCorrect: Binding.constant(true), leadingIcon: "tag")
    }
}
