# CodeMiner

## 📱 App Description

**CodeMiner** is an educational programming game built with Flutter that teaches algorithmic thinking through an engaging mining adventure. Players write algorithms to control a miner character, collect valuable minerals, and compete for the highest score. The game combines coding concepts with strategic resource management in a fun, interactive environment.

The app transforms learning to code into an exciting challenge where players must write efficient algorithms to navigate a grid-based world, mine resources, and maximize their earnings before time runs out.

---

## ✨ Features Implemented

### 🎮 Core Gameplay
- **Grid-Based Mining World**: 6x6 interactive grid with various minerals and obstacles
- **Algorithmic Programming**: Write custom algorithms using a simple command language
- **Real-Time Execution**: Watch your algorithms execute step-by-step with visual feedback
- **Timed Challenges**: Complete objectives within a 3-minute time limit
- **Score Tracking**: Earn gold by mining valuable minerals with different rarity tiers

### 💎 Mineral System
- **7 Mineral Types** with weighted spawn probabilities:
  - **Dirt** - Base terrain (always present)
  - **Coal** - Common (30% spawn, 10 gold)
  - **Copper** - Common (25% spawn, 20 gold)
  - **Iron** - Uncommon (10% spawn, 50 gold)
  - **Gold** - Rare (3.5% spawn, 80 gold)
  - **Diamond** - Legendary (0.5% spawn, 100 gold)
  - **Bomb** - Hazard (1% spawn, -100 gold penalty)

### 🖥️ Algorithm Editor
- **Three Algorithm Slots**: Save and manage multiple algorithms
- **Tabbed Interface**: Easy switching between Algorithm 1, 2, and 3
- **Code Formatting Tools**:
  - Indent/Unindent buttons (4-space indentation)
  - Auto-format for nested loops
  - Clear button to reset current algorithm
- **Monospace Font**: Enhanced code readability
- **Visual Indentation Support**: Write clean, nested loop structures
- **Persistent Storage**: Algorithms saved locally and persist between sessions

### 📝 Command Language
- **Movement Commands**: `moveUp`, `moveDown`, `moveLeft`, `moveRight`
- **Action Commands**: `mine`, `refresh`
- **Loop Support**: `loop X ... end` syntax with full nesting capability
- **Recursive Parsing**: Properly handles nested loops at any depth

### ⏱️ Game UI Features
- **Live Timer**: Counts elapsed time during gameplay
- **Gold Display**: Real-time money tracking
- **Message Log**: Scrolling chat with game events and feedback
- **Inspector Panel**: View detailed stats for selected minerals or player
- **Dynamic RUN/STOP Button**:
  - Changes to red "STOP" button during execution
  - Instantly stops running algorithms
  - Shows error message for empty algorithms
  - Returns to "RUN" when complete

### 🏆 Rankings System
- **Persistent Leaderboard**: SQLite database stores all game results
- **Comprehensive Stats**: Name, gold earned, time taken, commands run
- **Sorted Rankings**: Automatic sorting by highest gold earned
- **Empty State**: Friendly message when no rankings exist yet
- **Local Storage**: Rankings persist across app sessions

### 📚 In-App Documentation
- **Command Reference**: Complete guide to all available commands
- **Loop Syntax Examples**: Nested loop demonstrations with proper indentation
- **Tips and Tricks**: Strategy guidance for efficient mining
- **Professional UI**: Card-based layout with syntax highlighting

### 🎨 User Interface
- **Cohesive Theme**: Warm brown/amber color scheme throughout
- **Gradient Backgrounds**: Smooth visual transitions
- **Responsive Design**: Adapts to different screen sizes
- **Browser Optimized**: Works smoothly on Edge and other web browsers
- **No Keyboard Crashes**: Safe text input without virtual keyboard issues

### 🎯 Game Mechanics
- **Win Condition**: Collect 500+ gold within the time limit
- **Lose Condition**: Timer expires before reaching goal
- **Grid Refresh**: Regenerate minerals during gameplay
- **Collision Detection**: Boundary checking for valid moves
- **Visual Feedback**: Real-time indicator of player actions

---

## 🛠️ Tools and Frameworks Used

### Core Framework
- **Flutter 3.38.3** - Cross-platform UI framework
- **Dart 3.10.1** - Programming language

### State Management
- **StatefulWidget** - Local state management for UI components
- **Provider Pattern** - Game state management through GameManager

### Database & Storage
- **sqflite 2.4.2** - SQLite database for rankings persistence
- **path_provider 2.1.4** - Access to device storage locations

### UI Components
- **Material Design 3** - Modern, consistent UI components
- **Google Fonts (Inter)** - Professional typography
- **Custom Theme System** - Centralized color and style management

### Development Tools
- **Git** - Version control
- **GitHub** - Code repository hosting
- **VS Code / Android Studio** - IDE support
- **Flutter DevTools** - Performance profiling and debugging

### Platform Support
- **Web** - Chrome, Edge, Firefox browser support
- **Android** - Mobile device compatibility
- **Windows** - Desktop application support

---

## 🖼️ Screenshots

### Main Menu
The starting point of the game featuring:
- Clean, gradient background with brown/amber theme
- "Start Game" button to begin new session
- "Rankings" button to view leaderboard
- "Documentation" for command reference
- "Credits" for attribution

*[Screenshot placeholder - Main menu with gradient background and navigation buttons]*

---

### Game Page
The main gameplay interface showing:
- 6x6 mineral grid with colorful ore sprites
- Player character indicator on grid
- Live timer display (MM:SS format)
- Current gold amount
- Message log with game events
- Inspector panel showing selected mineral/player stats
- Algorithm dropdown selector
- RUN/STOP button (changes color based on state)
- EDIT button for algorithm editor

*[Screenshot placeholder - Game page with grid, UI controls, and message log]*

---

### Algorithm Editor
The code editing interface featuring:
- Three tabbed algorithm slots
- Monospace text editor with syntax highlighting
- Formatting toolbar with 4 buttons:
  - Indent (increase indentation)
  - Unindent (decrease indentation)
  - Auto-format (automatic indentation)
  - Clear (reset current algorithm)
- Documentation and Close buttons
- Dark brown theme for comfortable coding

*[Screenshot placeholder - Algorithm editor with tabs and formatting toolbar]*

---

### Algorithm Execution
Visual demonstration of running algorithms:
- Grid updating in real-time
- Player moving across cells
- Minerals being collected
- Message log showing each action
- Red STOP button during execution
- Timer continuing to count

*[Screenshot placeholder - Game mid-execution with player moving]*

---

### Rankings Page
The leaderboard displaying:
- List of completed games sorted by gold
- Player name, gold earned, and time taken
- Numbered rankings (1st, 2nd, 3rd, etc.)
- Circular rank indicators with amber accent
- Empty state message when no rankings exist:
  - Trophy icon
  - "No Rankings Yet" heading
  - Helpful instruction text

*[Screenshot placeholder - Rankings page with player entries]*

---

### Documentation Page
In-app help system showing:
- Command syntax reference
- Example algorithms with indentation
- Loop structure demonstrations
- Tips for effective coding
- Card-based layout for easy reading
- Scrollable content for all commands

*[Screenshot placeholder - Documentation page with command reference]*

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.38.3 or higher
- Dart 3.10.1 or higher
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone https://github.com/certainlynotnathan/CodeMiner.git
cd CodeMiner
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# For web (Chrome/Edge)
flutter run -d chrome

# For Android
flutter run

# For Windows
flutter run -d windows
```

### Building for Release

```bash
# Web build
flutter build web

# Android APK
flutter build apk

# Windows executable
flutter build windows
```

---

## 🎓 How to Play

1. **Start the Game**: Enter your name (optional) and click Start
2. **Write an Algorithm**: Click EDIT to open the algorithm editor
3. **Use Commands**: Write movement and action commands
4. **Add Loops**: Use `loop X ... end` for repeated actions
5. **Format Code**: Use Auto-format for clean nested loops
6. **Run Algorithm**: Select your algorithm and click RUN
7. **Watch Execution**: Observe your miner execute commands
8. **Stop Anytime**: Click STOP to halt execution immediately
9. **Collect Minerals**: Mine valuable ores to increase gold
10. **Beat the Timer**: Earn 500+ gold before time runs out!

---

## 📖 Example Algorithm

```
loop 6
    moveRight
    mine
    loop 3
        moveDown
        mine
    end
    loop 3
        moveUp
    end
end
```

This algorithm:
- Moves right 6 times
- Mines at each position
- For each position, mines 3 cells down
- Returns to original row
- Covers a large mining area efficiently

---

## 🏗️ Project Structure

```
lib/
├── main.dart                    # App entry point
├── app/
│   └── theme.dart              # Centralized color theme
├── models/
│   ├── grid.dart               # Grid data structure
│   ├── minerals.dart           # Mineral definitions
│   ├── player.dart             # Player character
│   └── player_stats.dart       # Stats model for rankings
├── controllers/
│   ├── game_manager.dart       # Core game logic
│   └── ranking_manager.dart    # Leaderboard management
└── view/
    ├── menu_page.dart          # Main menu UI
    ├── game_page.dart          # Gameplay UI
    ├── algorithm_editor_page.dart  # Code editor UI
    ├── documentation_page.dart # Help/reference UI
    ├── ranking_page.dart       # Leaderboard UI
    └── credits_page.dart       # Attribution UI
```

---

## 🎯 Key Achievements

- ✅ **Full Nested Loop Support**: Recursive parser handles unlimited loop depth
- ✅ **Real-Time Algorithm Execution**: Visual step-by-step command processing
- ✅ **Persistent Data**: SQLite rankings and local algorithm storage
- ✅ **Professional UI/UX**: Consistent theming and responsive design
- ✅ **Cross-Platform**: Web, Android, and Windows support
- ✅ **Educational Value**: Teaches loops, sequencing, and algorithmic thinking
- ✅ **Performance Optimized**: Reduced command cooldown for smooth gameplay
- ✅ **Browser Compatible**: No keyboard crashes, stable web performance

---

## 👨‍💻 Author

**Nathan**
- GitHub: [@certainlynotnathan](https://github.com/certainlynotnathan)

---

## 📄 License

This project is created for educational purposes.

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for UI guidelines
- SQLite for reliable data persistence
- The open-source community for inspiration and tools

---

**Made with ❤️ using Flutter**
