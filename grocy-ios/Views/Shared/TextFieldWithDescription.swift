//
//  TextEditWithDescriptionView.swift
//  grocy-ios
//
//  Created by Georg Meissner on 22.10.20.
//

import SwiftUI

struct TextFieldWithDescription: View {
    @Binding var textToEdit: String
    var description: String
    var disableAutoCorrection: Bool? = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            if !textToEdit.isEmpty {
                Text("\(description):").font(.caption)
            }
            TextField(description, text: $textToEdit)
                .disableAutocorrection(disableAutoCorrection)
        }
    }
}

struct TextFieldWithDescription_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithDescription(textToEdit: Binding.constant("Text"), description: "Textbeschreibung")
    }
}
