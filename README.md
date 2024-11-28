# Neetiflow

A modern employee and client management system built with Flutter and Firebase.

## Features

### Employee Management
- Real-time employee status tracking (Online/Offline)
- Comprehensive employee profile management
- Role-based access control (Admin/Manager/Employee)
- Active/Inactive status management
- Cross-organization employee lookup
- Department role management
- Detailed employee information display
- Real-time department updates
- Efficient data synchronization

### Client Management
- Real-time client tracking and updates
- Comprehensive client profile management
- Client status tracking (Active/Inactive/Suspended)
- Client type categorization (Individual/Company/Government)
- Client interaction history
- Document management (GSTIN, PAN)
- Client assignment to employees
- Lifetime value tracking
- Tags and metadata support

### Lead Management
- Comprehensive lead information tracking
- Advanced lead filtering and search
- Lead scoring system
- Timeline-based activity tracking
- Intuitive lead details view
- Bulk actions support
- Smart navigation system
  - Multiple entry points to lead details
  - Separate selection and navigation actions
  - Quick access via info icons
- Export/Import capabilities
- Custom fields support
- Process status tracking

### Navigation
- Persistent shell implementation with customizable initial routes
- Responsive drawer navigation
- Dynamic page routing
- Seamless page transitions
- User profile integration
- Quick access to key features
- Intuitive back navigation
- Smooth state transitions

### Authentication
- Secure login system with error handling
- Password reset functionality
- Remember me functionality
- Persistent session management
- Automatic navigation flow
- Account activation/deactivation
- Online/Offline status tracking
- Cross-organization authentication

### Real-time Updates
- Live status synchronization
- Instant notifications
- Stream-based data updates
- Automatic UI refresh
- Robust error handling
- Efficient state management
- Timestamp synchronization
- Department and client data streaming

### User Interface
- Modern, responsive design
- Intuitive navigation
- Dark/Light theme support
- Form validation and error handling
- Loading indicators
- Success/Error feedback
- Responsive dialogs
- Efficient state representation

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Firebase project with Firestore and Authentication enabled
- A code editor (VS Code recommended)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/neetiflow.git
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a new Firebase project
   - Enable Authentication and Firestore
   - Add your Firebase configuration files
   - Update the firebase options in the project

4. Run the app:
```bash
flutter run -d chrome
```

## Project Structure
```
lib/
├── application/      # Business logic and state management
├── data/
│   ├── models/
│   │   ├── lead.dart
│   │   └── lead_filter.dart
│   └── repositories/
│       └── leads_repository.dart
├── domain/
│   ├── entities/
│   │   └── lead.dart
│   └── models/
│       └── lead_filter.dart
│   ├── entities/
│   │   └── employee.dart
│   └── models/
│       └── employee_filter.dart
├── infrastructure/  # Implementation of repositories
└── presentation/
│   ├── blocs/
│   │   └── leads/
│   │       ├── leads_bloc.dart
│   │       ├── leads_event.dart
│   │       └── leads_state.dart
│   ├── pages/
│   │   └── leads/
│   │       ├── lead_details_page.dart
│   │       └── leads_page.dart
│   └── widgets/
│       └── leads/
│           ├── lead_filter_widget.dart
│           ├── lead_form.dart
│           ├── lead_score_badge.dart
│           └── timeline_widget.dart
└── utils/
    └── lead_utils.dart
```
## Architecture

The project follows Clean Architecture principles:

- **Domain Layer**: Contains business logic and entities
- **Infrastructure Layer**: Implements repositories and external services
- **Presentation Layer**: Contains UI components and state management
- **Application Layer**: Orchestrates the flow of data between layers

### State Management
- BLoC pattern for complex state management
- Provider for simple state management
- Stream-based real-time updates

### Firebase Integration
- Firestore for real-time database
- Firebase Authentication for user management
- Cloud Functions for backend operations

## Development Status

Current Version: 1.0.0-beta

### Completed Features
- Employee Management System
- Client Management System
- Real-time Updates
- Authentication
- Basic UI/UX
- Error Handling

### In Progress
- Advanced Filtering
- Reporting System
- Offline Support
- Performance Optimization

### Planned Features
- Mobile App Support
- Advanced Analytics
- Document Management
- API Integration

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For support or queries, please contact [your-email@domain.com]

## Acknowledgments

- Flutter team
- Firebase team
- All contributors
### Technical Improvements
- Consolidated repository methods
- Enhanced error handling
- Improved state management
- Added platform-specific adaptations
- Enhanced type safety
- Improved code documentation
- Optimized CSV handling
- Enhanced UI responsiveness

### 🔧 Code Architecture Highlights
- **Advanced Enum Handling**
  - Centralized `EnumUtils` for consistent enum conversions
  - Null-safe enum parsing and transformation
  - Reduced code duplication
- **Standardized Conversion Utilities**
  - `LeadConverter` for seamless entity-model transformations
  - Type-safe data mapping
  - Simplified conversion logic
- **Base Classes for Scalability**
  - `BaseBLoC` for standardized state management
  - `BaseRepository` with common data access patterns
  - Centralized error handling
- **Performance Optimization**
  - Efficient enum and object conversions
  - Minimized redundant code
  - Improved type safety

### 🛡️ Development Principles
- Clean Architecture
- Domain-Driven Design
- Type Safety
- Modular Code Structure
- Performance Optimization
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
