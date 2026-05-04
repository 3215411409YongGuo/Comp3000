# Book Management System

A web-based library management system built for small libraries and personal book collections.

## Project Overview

This system provides a practical alternative to spreadsheet-based management and expensive enterprise solutions. It covers book cataloguing, borrowing tracking, user management, and includes an AI assistant for natural language queries.

## Project Vision

To provide small libraries and individual book collectors with a free, easy-to-use digital management system that delivers professional-level functionality without the cost and complexity of enterprise software. The system aims to replace error-prone manual methods with a reliable, real-time web application that any user can operate with minimal training.

**Supervisor:** Dr. Haoyi Wang  
**Student:** Yong Guo (10926839)  
**Module:** COMP3000 Computing Project — University of Plymouth

## Tech Stack

- **Frontend:** Vue.js 2, Element UI, Vuex, Vue Router
- **Backend:** Spring Boot, MyBatis, Spring Security
- **Database:** MySQL 8.0
- **Cache:** Redis
- **AI Assistant:** Coze API (SSE Streaming)

## Features

- Book management (add, edit, delete, search by title/author/category)
- Borrowing and return tracking with timestamps
- Category management
- User authentication with role-based access control (Administrator / Reader)
- AI assistant for natural language book queries
- Cover image upload and display

## Project Structure
```
├── BookManagerApi/     # Spring Boot backend
├── BookManagerVue/     # Vue.js frontend
├── Redis-64bit/        # Redis for Windows
└── book_manager.sql    # Database initialisation script
```

## Getting Started

### Prerequisites

- Java 8+
- Node.js 14+
- MySQL 8.0
- Redis

### Installation

1. **Database setup**
```bash
   mysql -u root -p < book_manager.sql
```

2. **Backend**
```bash
   cd BookManagerApi
   mvn spring-boot:run
```

3. **Frontend**
```bash
   cd BookManagerVue
   npm install
   npm run serve
```

4. Open your browser at `http://localhost:9528`

### Default Login

| Role | Username | Password |
|------|----------|----------|
| Administrator | admin | admin |

## License

This project is released under the Creative Commons Zero (CC0) licence for educational purposes.
