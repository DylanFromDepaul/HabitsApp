import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section(header: Text("General")) {
                Toggle("Enable Notifications", isOn: .constant(true))
            }
            Section(header: Text("About")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0")
                }
            }
        }
        .navigationTitle("Settings")
    }
}