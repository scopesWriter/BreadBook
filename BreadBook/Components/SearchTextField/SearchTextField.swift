//
//  SearchTextField.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI
import Introspect

struct SearchTextField<TrailingContent: View>: View {
    
    // MARK: - Placeholder & Title
    private var title: String
    
    // MARK: - Binding Text
    @Binding private var inputText: String
    private var onCommit: (() -> Void)?
    private var shouldShowClear: Bool
    private var hasTrailingItems: Bool
    var trailingItem: TrailingContent?
    // MARK: - Init
    init(_ title: String,
         inputText: Binding<String>,
         onCommit: (() -> Void)?,
         shouldShowClear: Bool = true,
         hasTrailingItems: Bool = false,
         @ViewBuilder trailingItem: @escaping () -> TrailingContent? = { nil }) {
        self.title = title
        self._inputText = inputText
        self.onCommit = onCommit
        self.shouldShowClear = shouldShowClear
        self.hasTrailingItems = hasTrailingItems
        self.trailingItem = trailingItem()
    }
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .leading) {
            Text(title)
                .font(BreadBookFont.createFont(weight: .regular, size: 14))
                .foregroundColor(Color.neutral600 )
                .opacity(inputText.isEmpty ? 1:0)
            
            if shouldShowClear {
                textField
                    .modifier(TextFieldClearButton(text: $inputText, hasTrailingItems: hasTrailingItems))
            } else {
                textField
            }
            HStack {
                Spacer()
                trailingItem
                Spacer().frame(width: 10)
            }
        }
        .frame(height: 55, alignment: .leading)
        .padding(.leading, 30)
        .background(Color.originalWhite)
        .cornerRadius(28)
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(Color.neutral300, lineWidth: 1)
        )
        
    }
    
    private var textField : some View {
        TextField("", text: $inputText, onCommit: {
            self.onCommit?()
        })
        .introspectTextField { textfield in
            textfield.returnKeyType = .search
        }
        .multilineTextAlignment(.leading)
        .disableAutocorrection(true)
        .foregroundColor(Color.originalBlack)
        .font(BreadBookFont.createFont(weight: .medium, size: 14))
        .accentColor(Color.originalBlack)
    }
}


struct TextFieldClearButton: ViewModifier {
    @Binding var text: String
    var hasTrailingItems: Bool
    
    func body(content: Content) -> some View {
        HStack {
            content
            
            if !text.isEmpty {
                Button {
                    print("clear search")
                    self.text = ""
                } label: {
                    HStack {
                        Image(Icon.clearSearch.rawValue)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(10)
                            .padding(.trailing, hasTrailingItems ? 30 : 0)
                    }
                }.frame(height: 30)
            }
        }
    }
}

struct SearchTextField_Previews: PreviewProvider {
    static var previews: some View {
        SearchTextField("search", inputText: .constant("andrew"), onCommit: nil, trailingItem: {})
    }
}

struct CustomTextField: UIViewRepresentable {
    @Binding var text: String // String value of the TextView
    let placeholder: String // Placeholder Text
    let keyboardType: UIKeyboardType // Keypad layout type
    let tag: Int // Tag to recognise each specific TextView
    var commitHandler: (() -> Void)? // Called when return key is pressed
    
    init(_ placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType, tag: Int, onCommit: (() -> Void)?) {
        self._text = text
        self.placeholder = placeholder
        self.tag = tag
        self.commitHandler = onCommit
        self.keyboardType = keyboardType
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextField {
        // Customise the TextField as you wish
        let textField = UITextField(frame: .zero)
        textField.keyboardType = self.keyboardType
        textField.delegate = context.coordinator
        textField.isUserInteractionEnabled = true
        textField.text = text
        textField.returnKeyType = .search
        textField.placeholder = placeholder
        textField.font = UIFont(name: "BwModelica-Medium", size: 14)
        textField.autocorrectionType = .no
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = self.text
        uiView.setContentHuggingPriority(.init(rawValue: 70), for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        var parent: CustomTextField
        
        init(_ uiTextView: CustomTextField) {
            self.parent = uiTextView
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            if let value = textField.text as NSString? {
                let proposedValue = value.replacingCharacters(in: range, with: string)
                parent.text = proposedValue as String
            }
            return true
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if let nextTextField = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
                nextTextField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
            return false
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            parent.commitHandler?()
        }
        
    }
}
