import SwiftUI

struct HabitCreationView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State private var name: String = ""
    @State private var frequency: String = "Daily"
    @State private var target: String = "1"
    @State private var reminderTime: Date? = nil
    @State private var showingAlert = false
    @State private var alertMessage = ""

    private let frequencies = ["Daily", "Weekly", "Monthly"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Habit Details")) {
                    TextField("Habit Name", text: $name)
                    Picker("Frequency", selection: $frequency) {
                        ForEach(frequencies, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("Target", text: $target)
                        .keyboardType(.numberPad)
                }

                Section(header: Text("Reminder")) {
                    Toggle("Set Reminder", isOn: Binding(
                        get: { self.reminderTime != nil },
                        set: { isOn in
                            if isOn {
                                self.reminderTime = self.reminderTime ?? Date()
                            } else {
                                self.reminderTime = nil
                            }
                        }
                    ))
                    if let reminderTime = reminderTime {
                        DatePicker("Reminder Time", selection: Binding(
                            get: { reminderTime },
                            set: { newValue in self.reminderTime = newValue }
                        ), displayedComponents: .hourAndMinute)
                    }
                }
            }
            .navigationBarTitle("New Habit", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    if validateInput() {
                        saveHabit()
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showingAlert = true
                    }
                }
            )
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }

    private func validateInput() -> Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Please enter a habit name."
            return false
        }

        guard frequencies.contains(frequency) else {
            alertMessage = "Please select a valid frequency."
            return false
        }

        guard let targetValue = Int16(target), targetValue > 0 else {
            alertMessage = "Target must be a positive number."
            return false
        }

        return true
    }

    private func saveHabit() {
        let newHabit = Habit(context: viewContext)
        newHabit.id = UUID()
        newHabit.name = name.trimmingCharacters(in: .whitespaces)
        newHabit.frequency = frequency
        newHabit.target = Int16(target) ?? 1
        newHabit.progress = 0
        newHabit.streak = 0
        newHabit.reminderTime = reminderTime

        do {
            try viewContext.save()
            if reminderTime != nil {
                NotificationManager.shared.scheduleNotification(for: newHabit)
            }
        } catch {
            print("Failed to save the new habit: \(error.localizedDescription)")
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
