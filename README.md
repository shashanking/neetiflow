# Neetiflow

A modern employee management system built with Flutter and Firebase.

## Features

### Employee Management
- Real-time employee status tracking (Online/Offline)
- Comprehensive employee profile management
- Role-based access control (Admin/Manager/Employee)
- Active/Inactive status management
- Cross-organization employee lookup
- Department role management
- Detailed employee information display

### Navigation
- Persistent shell implementation with customizable initial routes
- Responsive drawer navigation
- Dynamic page routing
- Seamless page transitions
- User profile integration
- Quick access to key features

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

### User Interface
- Modern, responsive design
- Intuitive navigation
- Dark/Light theme support
- Cross-platform compatibility
- Null-safe implementations
- Beautiful status indicators
- Improved layout handling

## Tech Stack

### Frontend
- Flutter SDK
- BLoC Pattern
- Stream Subscriptions
- Custom Widgets

### Backend
- Firebase Authentication
- Cloud Firestore
- Firebase Functions
- Real-time Database

### State Management
- flutter_bloc
- StreamSubscription
- Repository Pattern
- Clean Architecture

## Getting Started

### Prerequisites
- Flutter SDK (latest version)
- Firebase project setup
- IDE (VS Code or Android Studio)
- Git

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/neetiflow.git
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
- Add your `google-services.json` for Android
- Add your `GoogleService-Info.plist` for iOS
- Configure web setup if needed

4. Run the app
```bash
flutter run
```

## Project Structure

```
lib/
├── application/      # Business logic and state management
├── domain/          # Business objects and interfaces
├── infrastructure/  # Implementation of repositories
└── presentation/   # UI components and pages
```

## Development

See [DEVELOPMENT.md](DEVELOPMENT.md) for detailed development documentation, including:
- Current implementation status
- Future development goals
- Contributing guidelines
- Known issues and limitations

## Security

- Secure authentication flow
- Role-based access control
- Data encryption
- Regular security audits

## Testing

- Unit tests
- Widget tests
- Integration tests
- Performance testing

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For support or queries, please contact [your-email@domain.com]

## Acknowledgments

- Flutter team
- Firebase team
- All contributors
