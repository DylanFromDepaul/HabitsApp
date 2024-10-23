import SwiftUI
import CoreData

struct HabitListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Habit.name, ascending: true)],
        animation: .default)
    private var habits: FetchedResults<Habit>

    @State private var showingAddHabit = false

    var body: some View {
        List {
            ForEach(habits) { habit in
                NavigationLink(destination: HabitDetailView(habit: habit)) {
                    HabitRowView(habit: habit)
                }
            }
            .onDelete(perform: deleteHabits)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddHabit = true }) {
                    Label("Add Habit", systemImage: "plus")
                }
                .sheet(isPresented: $showingAddHabit) {
                    HabitCreationView()
                        .environment(\.managedObjectContext, viewContext)
                }
            }
        }
    }

    private func deleteHabits(offsets: IndexSet) {
        withAnimation {
            offsets.map { habits[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Could not save context: \(error.localizedDescription)")
        }
    }
}
