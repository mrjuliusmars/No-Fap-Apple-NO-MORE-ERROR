import SwiftUI

struct ExerciseView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCategory: ExerciseCategory = .bodyweight
    @State private var showingWorkoutPlan = false
    @State private var selectedFitnessLevel: FitnessLevel = .beginner
    @State private var selectedWorkoutType: WorkoutType = .mixed
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                }
                
                Spacer()
                
                Text("Exercise")
                    .font(.title2.bold())
                
                Spacer()
                
                Button(action: { showingWorkoutPlan = true }) {
                    Image(systemName: "wand.and.stars")
                        .font(.title2)
                }
            }
            .foregroundColor(Theme.textColor)
            .padding()
            
            // Category Selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Theme.padding16) {
                    ForEach(ExerciseCategory.allCases) { category in
                        CategoryButton(
                            category: category,
                            isSelected: selectedCategory == category,
                            action: { selectedCategory = category }
                        )
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, Theme.padding8)
            
            // Exercises List
            ScrollView {
                LazyVStack(spacing: Theme.padding16) {
                    ForEach(selectedCategory.exercises) { exercise in
                        ExerciseCard(exercise: exercise)
                    }
                }
                .padding()
            }
        }
        .background(Theme.backgroundColor.ignoresSafeArea())
        .sheet(isPresented: $showingWorkoutPlan) {
            WorkoutPlanGenerator(
                fitnessLevel: $selectedFitnessLevel,
                workoutType: $selectedWorkoutType
            )
        }
    }
}

struct WorkoutPlanGenerator: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var fitnessLevel: FitnessLevel
    @Binding var workoutType: WorkoutType
    @State private var showingWorkout = false
    
    var body: some View {
        VStack(spacing: Theme.padding24) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                }
                
                Spacer()
                
                Text("AI Workout Plan")
                    .font(.title2.bold())
                
                Spacer()
            }
            .foregroundColor(Theme.textColor)
            .padding()
            
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.padding32) {
                    // Fitness Level
                    VStack(alignment: .leading, spacing: Theme.padding16) {
                        Text("Fitness Level")
                            .font(.title3.bold())
                        
                        HStack(spacing: Theme.padding16) {
                            ForEach(FitnessLevel.allCases) { level in
                                FitnessLevelButton(
                                    level: level,
                                    isSelected: fitnessLevel == level,
                                    action: { fitnessLevel = level }
                                )
                            }
                        }
                    }
                    
                    // Workout Type
                    VStack(alignment: .leading, spacing: Theme.padding16) {
                        Text("Workout Type")
                            .font(.title3.bold())
                        
                        HStack(spacing: Theme.padding16) {
                            ForEach(WorkoutType.allCases) { type in
                                WorkoutTypeButton(
                                    type: type,
                                    isSelected: workoutType == type,
                                    action: { workoutType = type }
                                )
                            }
                        }
                    }
                }
                .padding()
            }
            
            Button(action: { showingWorkout = true }) {
                HStack {
                    Text("Generate 15-Min Workout")
                        .font(.headline)
                    Image(systemName: "sparkles")
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        colors: [.purple, .blue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(Theme.cornerRadius)
            }
            .padding()
        }
        .background(Theme.backgroundColor)
        .sheet(isPresented: $showingWorkout) {
            GeneratedWorkoutView(
                fitnessLevel: fitnessLevel,
                workoutType: workoutType
            )
        }
    }
}

struct GeneratedWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    let fitnessLevel: FitnessLevel
    let workoutType: WorkoutType
    
    var exercises: [WorkoutExercise] {
        generateWorkout()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                }
                
                Spacer()
                
                Text("Your Workout")
                    .font(.title2.bold())
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                }
            }
            .foregroundColor(Theme.textColor)
            .padding()
            
            // Workout Info
            VStack(spacing: Theme.padding8) {
                Text("\(fitnessLevel.rawValue) \(workoutType.rawValue) Workout")
                    .font(.headline)
                Text("15 minutes • \(exercises.count) exercises")
                    .foregroundColor(Theme.textColor.opacity(0.7))
            }
            .padding(.bottom)
            
            // Exercise List
            ScrollView {
                LazyVStack(spacing: Theme.padding16) {
                    ForEach(exercises) { exercise in
                        WorkoutExerciseCard(exercise: exercise)
                    }
                }
                .padding()
            }
        }
        .background(Theme.backgroundColor)
    }
    
    private func generateWorkout() -> [WorkoutExercise] {
        // This is where you'd implement the AI workout generation
        // For now, returning a sample workout
        return [
            WorkoutExercise(
                name: "Jump Rope",
                duration: "2 minutes",
                description: "Warm up with basic jumps",
                youtubeLink: "https://youtube.com/watch?v=example1"
            ),
            WorkoutExercise(
                name: "Push-ups",
                duration: "45 seconds",
                description: "Keep core tight, full range of motion",
                youtubeLink: "https://youtube.com/watch?v=example2"
            ),
            WorkoutExercise(
                name: "Mountain Climbers",
                duration: "30 seconds",
                description: "Fast pace, engage core",
                youtubeLink: "https://youtube.com/watch?v=example3"
            ),
            WorkoutExercise(
                name: "Rest",
                duration: "15 seconds",
                description: "Catch your breath",
                youtubeLink: nil
            )
        ]
    }
}

struct WorkoutExerciseCard: View {
    let exercise: WorkoutExercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.padding12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.name)
                        .font(.headline)
                    Text(exercise.duration)
                        .font(.subheadline)
                        .foregroundColor(Theme.textColor.opacity(0.7))
                }
                
                Spacer()
                
                if let youtubeLink = exercise.youtubeLink {
                    Link(destination: URL(string: youtubeLink)!) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(.linearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .trailing))
                    }
                }
            }
            
            if let description = exercise.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(Theme.textColor.opacity(0.7))
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(Theme.cornerRadius)
    }
}

struct FitnessLevelButton: View {
    let level: FitnessLevel
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(level.rawValue)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? Theme.primaryColor : Color.white.opacity(0.05))
                .foregroundColor(isSelected ? .white : Theme.textColor)
                .cornerRadius(Theme.cornerRadius)
        }
    }
}

struct WorkoutTypeButton: View {
    let type: WorkoutType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(type.rawValue)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? Theme.primaryColor : Color.white.opacity(0.05))
                .foregroundColor(isSelected ? .white : Theme.textColor)
                .cornerRadius(Theme.cornerRadius)
        }
    }
}

enum FitnessLevel: String, CaseIterable, Identifiable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    
    var id: String { rawValue }
}

enum WorkoutType: String, CaseIterable, Identifiable {
    case cardio = "Cardio"
    case strength = "Strength"
    case mixed = "Mixed"
    
    var id: String { rawValue }
}

struct WorkoutExercise: Identifiable {
    let id = UUID()
    let name: String
    let duration: String
    let description: String?
    let youtubeLink: String?
}

struct CategoryButton: View {
    let category: ExerciseCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: category.icon)
                Text(category.name)
                    .font(.subheadline)
            }
            .padding(.horizontal, Theme.padding16)
            .padding(.vertical, Theme.padding8)
            .background(isSelected ? Theme.primaryColor : Color.white.opacity(0.05))
            .foregroundColor(isSelected ? .white : Theme.textColor)
            .cornerRadius(20)
        }
    }
}

struct ExerciseCard: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.padding12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.name)
                        .font(.headline)
                    Text(exercise.duration)
                        .font(.subheadline)
                        .foregroundColor(Theme.textColor.opacity(0.7))
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(.linearGradient(colors: [.purple, .blue], startPoint: .leading, endPoint: .trailing))
                }
            }
            
            if let description = exercise.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(Theme.textColor.opacity(0.7))
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(Theme.cornerRadius)
    }
}

enum ExerciseCategory: String, CaseIterable, Identifiable {
    case bodyweight = "Bodyweight"
    case cardio = "Cardio"
    case meditation = "Meditation"
    case yoga = "Yoga"
    
    var id: String { rawValue }
    
    var name: String { rawValue }
    
    var icon: String {
        switch self {
        case .bodyweight: return "figure.strengthtraining.traditional"
        case .cardio: return "figure.run"
        case .meditation: return "sparkles"
        case .yoga: return "figure.mind.and.body"
        }
    }
    
    var exercises: [Exercise] {
        switch self {
        case .bodyweight:
            return [
                // Upper Body Push
                Exercise(
                    name: "Push-ups",
                    duration: "3 sets of 10-15",
                    description: "Classic chest, shoulders, and triceps exercise. Keep body straight, lower until chest nearly touches ground."
                ),
                Exercise(
                    name: "Diamond Push-ups",
                    duration: "3 sets of 8-12",
                    description: "Triceps-focused push-up. Form diamond shape with hands under chest."
                ),
                Exercise(
                    name: "Decline Push-ups",
                    duration: "3 sets of 8-12",
                    description: "Elevated feet push-up targeting upper chest. Place feet on elevated surface."
                ),
                
                // Upper Body Pull
                Exercise(
                    name: "Inverted Rows",
                    duration: "3 sets of 8-12",
                    description: "Back exercise using table or bar. Keep body straight, pull chest to bar."
                ),
                Exercise(
                    name: "Pike Push-ups",
                    duration: "3 sets of 8-12",
                    description: "Shoulder-focused exercise. Form an inverted V with body, lower head toward ground."
                ),
                
                // Core
                Exercise(
                    name: "Plank",
                    duration: "3 sets of 30-60s",
                    description: "Core stability exercise. Maintain straight line from head to heels."
                ),
                Exercise(
                    name: "Mountain Climbers",
                    duration: "3 sets of 30s",
                    description: "Dynamic core exercise. Alternate bringing knees to chest while in plank."
                ),
                Exercise(
                    name: "Russian Twists",
                    duration: "3 sets of 20",
                    description: "Rotational core exercise. Sit with feet off ground, rotate torso side to side."
                ),
                Exercise(
                    name: "Hollow Body Hold",
                    duration: "3 sets of 20-30s",
                    description: "Advanced core stability. Lie on back, lift legs and shoulders off ground."
                ),
                
                // Lower Body
                Exercise(
                    name: "Bodyweight Squats",
                    duration: "3 sets of 15-20",
                    description: "Basic leg exercise. Keep chest up, lower until thighs are parallel to ground."
                ),
                Exercise(
                    name: "Jump Squats",
                    duration: "3 sets of 10-15",
                    description: "Explosive leg exercise. Regular squat with explosive jump at top."
                ),
                Exercise(
                    name: "Bulgarian Split Squats",
                    duration: "3 sets of 10 each leg",
                    description: "Single-leg focus. Back foot elevated, lower until back knee nearly touches ground."
                ),
                Exercise(
                    name: "Lunges",
                    duration: "3 sets of 12 each leg",
                    description: "Step forward and lower back knee toward ground. Alternate legs."
                ),
                Exercise(
                    name: "Calf Raises",
                    duration: "3 sets of 20",
                    description: "Stand on edge of step, raise and lower heels. Hold for 2 seconds at top."
                ),
                
                // Full Body
                Exercise(
                    name: "Burpees",
                    duration: "3 sets of 10",
                    description: "Full body cardio. Squat, kick feet back to plank, push-up, jump back in, jump up."
                ),
                Exercise(
                    name: "Bear Crawls",
                    duration: "3 sets of 30s",
                    description: "Move forward/backward on hands and feet with knees hovering above ground."
                ),
                Exercise(
                    name: "Inchworm Walks",
                    duration: "3 sets of 10",
                    description: "Walk hands out to plank, walk feet to hands. Keeps hamstrings flexible."
                ),
                
                // Skill Work
                Exercise(
                    name: "Wall Handstand Hold",
                    duration: "3 sets of 20-30s",
                    description: "Advanced balance exercise. Kick up to handstand position against wall."
                ),
                Exercise(
                    name: "L-Sit Progression",
                    duration: "3 sets of 10-20s",
                    description: "Advanced core/strength hold. Start with feet on ground, progress to lifted."
                )
            ]
        case .cardio:
            return [
                Exercise(name: "Running", duration: "20 minutes", description: "Steady-state cardio"),
                Exercise(name: "Jump Rope", duration: "10 minutes", description: "High-intensity cardio"),
                Exercise(name: "Mountain Climbers", duration: "3 sets of 30 seconds", description: "Cardio and core exercise"),
                Exercise(name: "High Knees", duration: "1 minute", description: "Quick cardio burst")
            ]
        case .meditation:
            return [
                Exercise(name: "Mindful Breathing", duration: "5 minutes", description: "Focus on your breath"),
                Exercise(name: "Body Scan", duration: "10 minutes", description: "Progressive relaxation"),
                Exercise(name: "Loving-Kindness", duration: "15 minutes", description: "Cultivate compassion"),
                Exercise(name: "Visualization", duration: "10 minutes", description: "Mental imagery exercise")
            ]
        case .yoga:
            return [
                Exercise(name: "Sun Salutation", duration: "10 minutes", description: "Morning energy flow"),
                Exercise(name: "Warrior Poses", duration: "15 minutes", description: "Strength and balance"),
                Exercise(name: "Child's Pose", duration: "5 minutes", description: "Relaxation pose"),
                Exercise(name: "Cat-Cow Stretch", duration: "5 minutes", description: "Spine mobility")
            ]
        }
    }
}

struct Exercise: Identifiable {
    let id = UUID()
    let name: String
    let duration: String
    let description: String?
}

#Preview {
    ExerciseView()
        .preferredColorScheme(.dark)
} 