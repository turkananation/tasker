# Tasker

This project is a simple task management application built using Flutter, designed to help users organize their daily tasks efficiently. It incorporates user authentication, task management features, local storage, and a clean, responsive UI.

## Overview

This app allows users to:

*   Create, edit, and delete tasks.
*   Manage task details like title, description, due date, priority, and completion status.
*   Authenticate using email/password (Firebase Authentication).
*   Store tasks locally (Hive or SQLite).
*   Navigate through a user-friendly interface.

## Features

*   **User Authentication:** Secure email/password authentication with Firebase.  Social login options (Google, Facebook) are considered for future enhancement.
*   **Task Management:** Add, edit, delete, and track task completion. Tasks have a title, description, due date, priority level, and completion status (pending/done).
*   **Local Storage:** Persistent task data using Hive or SQLite.
*   **UI & Navigation:** Clean, responsive UI with intuitive navigation. Screens include Login, Registration, Task List, and Task Detail/Add/Edit. Navigation can be implemented using a bottom navigation bar or a drawer.
*   **State Management:** Efficient state management using Provider, Riverpod, or BLoC.
*   **Search and Filtering:**  Implementation of search and filtering functionality to allow users to easily find and organize their tasks.
*   **Subtasks:** (Planned/In Progress)
*   **Dark Mode:** (Planned/In Progress)
*   **Animations:** (Planned/In Progress)
*   **Task Filtering:** (e.g., show only completed tasks, filter by due date or priority) (Planned/In Progress)
*   **Push Notifications:** (Optional - Planned/In Progress)
*   **Cloud Synchronization:** (Optional - Planned/In Progress)
*   **Calendar View:** (Optional - Planned/In Progress)
*   **Task Sharing/Collaboration:** (Optional - Planned/In Progress)

## Screenshots

*(Add screenshots of your app here)*

## Technologies Used

*   Flutter
*   Firebase Authentication
*   Hive or SQLite
*   Provider, Riverpod, or BLoC

## Getting Started

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/turkananation/tasker.git
    ```

2.  **Install dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Set up Firebase:**
    *   Create a Firebase project.
    *   Enable email/password authentication.
    *   Configure your Flutter app to connect to Firebase (refer to Firebase documentation).

4.  **Run the app:**

    ```bash
    flutter run
    ```
