# GroceryApp - Full Stack iOS & Vapor Application

A complete full-stack grocery management application built with **SwiftUI** (iOS) and **Vapor** (server-side Swift), demonstrating modern Swift development across the entire technology stack.

## 📱 Project Overview

GroceryApp is a comprehensive grocery list management application that allows users to:
- Register and authenticate securely
- Create custom grocery categories with color coding
- Add and manage grocery items within categories
- Track prices and quantities
- Delete items and categories with cascade operations

## 🏗️ Architecture

This project demonstrates a modern full-stack Swift architecture:

### Frontend (iOS App)
- **SwiftUI** for modern declarative UI
- **Observation** framework for state management
- **Custom HTTP Client** with async/await networking
- **JWT token authentication**
- **Navigation Stack** with programmatic routing

### Backend (Vapor Server)
- **Vapor 4** web framework
- **PostgreSQL** database with Fluent ORM
- **JWT authentication** with secure token handling
- **RESTful API** design
- **Database migrations** for schema management

### Shared Components
- **GroceryAppSharedDTO** package for type-safe data transfer objects
- Consistent models between client and server

## 🔗 Repository Links

- **Main iOS App**: *Current Repository*
- **Vapor Server**: [grocery-app-server](https://github.com/tyfnnn/grocery-app-server)
- **Shared DTOs**: [GroceryAppSharedDTO](https://github.com/tyfnnn/GroceryAppSharedDTO)

## 🚀 Getting Started

### Prerequisites
- Xcode 15+ with Swift 6.0
- PostgreSQL database
- Vapor Toolbox (optional but recommended)

### Backend Setup
1. Clone the server repository:
   ```bash
   git clone https://github.com/tyfnnn/grocery-app-server.git
   cd grocery-app-server
   ```

2. Configure PostgreSQL database in `configure.swift`:
   ```swift
   let postgresConfig = SQLPostgresConfiguration(
       hostname: "localhost",
       username: "your_username",
       password: "your_password",
       database: "grocerydb",
       tls: .prefer(try .init(configuration: .clientDefault))
   )
   ```

3. Run migrations and start server:
   ```bash
   swift run
   ```

### iOS App Setup
1. Clone this repository
2. Open `GroceryApp.xcodeproj` in Xcode
3. Update server URL in `Constants.swift` if needed
4. Build and run on simulator or device

## 📚 Key Learning Concepts

### Full-Stack Swift Development
- **Shared Language**: Using Swift across the entire stack eliminates context switching
- **Type Safety**: Shared DTOs ensure compile-time safety between client and server
- **Code Reuse**: Common business logic and models can be shared

### Modern iOS Development
- **SwiftUI & Observation**: Reactive UI updates with minimal boilerplate
- **Async/Await**: Modern concurrency for network operations
- **Navigation Stack**: Programmatic navigation with type-safe routing

### Server-Side Swift
- **Vapor Framework**: Production-ready web framework with excellent performance
- **Fluent ORM**: Type-safe database operations with migrations
- **JWT Authentication**: Secure stateless authentication

### Database Design
- **Relational Modeling**: Proper foreign key relationships and constraints
- **Migration System**: Version-controlled database schema changes
- **Cascade Operations**: Automatic cleanup of related data

## 🎯 Why Custom Backend vs. BaaS?

While Backend-as-a-Service (BaaS) solutions like Firebase are excellent for rapid prototyping, custom backends offer several advantages for learning and production applications:

### **Learning Benefits**
- **Deep Understanding**: Build complete understanding of web APIs, databases, and authentication
- **Problem-Solving Skills**: Learn to debug and optimize server-side performance
- **Architecture Knowledge**: Understand how to design scalable, maintainable systems

### **Technical Advantages**
- **Full Control**: Complete control over data models, business logic, and performance optimizations
- **Custom Logic**: Implement complex business rules that may be difficult or impossible in BaaS
- **Database Flexibility**: Choose optimal database design and queries for your specific use case
- **Performance**: Fine-tune queries, caching, and server configuration for optimal performance

### **Production Considerations**
- **Cost Predictability**: Avoid unexpected scaling costs common with BaaS pricing models
- **Data Ownership**: Full control over your data without vendor lock-in
- **Compliance**: Easier to meet specific regulatory requirements (GDPR, HIPAA, etc.)
- **Integration**: Seamless integration with existing enterprise systems and third-party services

### **Long-term Benefits**
- **Vendor Independence**: No risk of service discontinuation or forced migrations
- **Customization**: Unlimited ability to modify and extend functionality
- **Team Skills**: Building expertise that transfers across projects and technologies

## 🛠️ Technical Features

### Authentication & Security
- JWT-based stateless authentication
- Password hashing with bcrypt
- Secure token storage and validation

### Database Operations
- CRUD operations for users, categories, and items
- Foreign key relationships with cascade deletes
- Database migrations for schema versioning

### API Design
- RESTful endpoints with consistent patterns
- Proper HTTP status codes and error handling
- Type-safe request/response models

### iOS Architecture
- MVVM pattern with observable view models
- Dependency injection with SwiftUI environment
- Custom HTTP client with error handling

## 📖 Educational Value

This project serves as an excellent study resource for:
- **iOS Developers** wanting to understand backend development
- **Full-Stack Developers** exploring Swift ecosystem
- **Students** learning modern app architecture patterns
- **Teams** considering Swift for server-side development

The combination of shared language, type safety, and modern async patterns makes this an ideal project for understanding how to build production-quality applications from scratch.

## 🤝 Contributing

Feel free to open issues or submit pull requests to improve the application or documentation. This project is designed for learning, so questions and suggestions are always welcome!

## 📄 License

This project is available for educational use. Please see individual repository licenses for specific terms.
