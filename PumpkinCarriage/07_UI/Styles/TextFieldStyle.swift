






import SwiftUI

//MARK: - Label
struct FormFieldLabel: View {
    let text: String

    var body: some View {
        Text(text)
            .primaryTextStyle()
            .foregroundStyle(.white)
            .frame(width: 120, height: 32, alignment: .center)
            .background(.main)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

//MARK: - Auth Text Field
struct AuthTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        VStack (spacing: 7) {
            configuration
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .padding(.leading, 10)
                .frame(height: 20)
            Divider()
                .background(.main)
                .padding(.bottom, 15)
        }
    }
}

//MARK: - Form Text Field
public struct BaseFormTextFieldStyle: TextFieldStyle {
    public init() {}
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .foregroundColor(.main)
            .padding(.leading, 10)
    }
}


public struct UsernameTextFieldStyle: TextFieldStyle {
    public init() {}
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .textContentType(.username)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .textFieldStyle(BaseFormTextFieldStyle())
    }
}


public struct EmailTextFieldStyle: TextFieldStyle {
    public init() {}
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .textFieldStyle(BaseFormTextFieldStyle())
    }
}


public struct PasswordTextFieldStyle: TextFieldStyle {
    public init() {}
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .textContentType(.password)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .textFieldStyle(BaseFormTextFieldStyle())
    }
}


public struct AddressDetailTextFieldStyle: TextFieldStyle {
    public init() {}
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .textContentType(.fullStreetAddress)
            .textFieldStyle(BaseFormTextFieldStyle())
    }
}


public struct PhoneTextFieldStyle: TextFieldStyle {
    public init() {}
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .keyboardType(.phonePad)
            .textContentType(.telephoneNumber)
            .textFieldStyle(BaseFormTextFieldStyle())
    }
}


public struct WebLinkTextFieldStyle: TextFieldStyle {
    public init() {}
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .keyboardType(.URL)
            .textContentType(.URL)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .textFieldStyle(BaseFormTextFieldStyle())
    }
}


