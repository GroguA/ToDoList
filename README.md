# ToDo List iOS Application

## Overview

This iOS application is a simple task management app consisting of two main screens: the main ToDo list screen and the edit task screen. The app allows users to view, create, and manage their tasks, with features such as marking tasks as complete or incomplete, and task deletion through swipe gestures. The application is built using the VIPER architecture and incorporates several design patterns like Factory and Singleton.

## Screens

### ToDo List Main Screen
Purpose: Displays a list of created tasks.
Task Cell: Each task cell shows the task's title, description, creation or last modified date, and the task's completion status (completed or not).
Interactions: Swipe Actions: Users can delete tasks or change their status (completed/incomplete) by swiping on a task cell.
First Launch Behavior: On the first app launch, tasks are fetched from an API. These tasks cannot be edited but can be deleted or marked as completed/incomplete. Tapping on such a task will open the task creation screen.
### Edit Task Screen
Purpose: Handles the creation of new tasks.
Task Details: Users can enter the task's title and description.
Default Settings: New tasks are automatically set to "not completed" status, and the current date is assigned as the task's creation date.
Auto-Save: The task is automatically saved when navigating back to the main ToDo list screen.

## Technical Details

First Launch Handling: UserDefaults is used to store information about the first launch of the application. This is used to determine whether to load tasks from the API.
Persistent Storage: Core Data is used to store tasks created by the user. This ensures that user-created tasks are saved and persist between app sessions.
Networking: URLSession is used to fetch tasks from the network during the app's first launch.
Concurrency: GCD (Grand Central Dispatch) is used for background operations such as loading tasks from the network or saving tasks, ensuring that the UI remains responsive. UI updates are performed on the main thread.
Architecture: The app is built using the VIPER architecture, which promotes a clear separation of concerns. This makes the codebase more maintainable and testable.
Design Patterns: The following design patterns were used:
Factory: For creating instances of objects in a structured manner.
Singleton: To manage shared resources such as network services or data sources.


