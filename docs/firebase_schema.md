# Firebase Schema Design for Operations Module

## Collections Structure

### Project Templates
```
/projectTemplates/{templateId}
{
  id: string,
  name: string,
  type: string (enum: socialMedia, ecommerce, appDevelopment, uiuxDesign, custom),
  description: string?,
  metadata: map,
  isArchived: boolean,
  createdAt: timestamp,
  updatedAt: timestamp
}

/projectTemplates/{templateId}/phases/{phaseId}
{
  id: string,
  name: string,
  order: number,
  estimatedDuration: number,
  description: string?,
  metadata: map
}

/projectTemplates/{templateId}/milestones/{milestoneId}
{
  id: string,
  name: string,
  order: number,
  offsetFromStart: number,
  description: string?,
  metadata: map
}

/projectTemplates/{templateId}/workflows/{workflowId}
{
  id: string,
  name: string,
  description: string?,
  metadata: map,
  states: [
    {
      id: string,
      name: string,
      color: string,
      isInitial: boolean,
      isFinal: boolean,
      metadata: map
    }
  ],
  transitions: [
    {
      id: string,
      fromStateId: string,
      toStateId: string,
      name: string,
      requiredRoles: string[],
      metadata: map
    }
  ]
}
```

### Projects
```
/projects/{projectId}
{
  id: string,
  templateId: string,
  name: string,
  type: string,
  clientId: string,
  status: string,
  startDate: timestamp,
  endDate: timestamp,
  metadata: map,
  createdAt: timestamp,
  updatedAt: timestamp
}

/projects/{projectId}/phases/{phaseId}
{
  id: string,
  templatePhaseId: string?,
  name: string,
  status: string,
  startDate: timestamp,
  endDate: timestamp,
  metadata: map
}

/projects/{projectId}/tasks/{taskId}
{
  id: string,
  phaseId: string,
  name: string,
  description: string?,
  assigneeId: string?,
  status: string,
  priority: string,
  startDate: timestamp,
  dueDate: timestamp,
  metadata: map
}
```

### Calendar Events
```
/calendarEvents/{eventId}
{
  id: string,
  title: string,
  type: string,
  projectId: string?,
  clientId: string?,
  startTime: timestamp,
  endTime: timestamp,
  status: string,
  description: string?,
  attendees: string[],
  location: string?,
  color: string?,
  metadata: map,
  createdAt: timestamp,
  updatedAt: timestamp
}

/calendarEvents/{eventId}/recurrence
{
  type: string,
  frequency: number,
  until: timestamp?,
  count: number?,
  byWeekDay: number[],
  byMonthDay: number[],
  byMonth: number[],
  metadata: map
}
```

### Calendar Views
```
/users/{userId}/calendarViews/{viewId}
{
  id: string,
  name: string,
  type: string,
  filteredProjects: string[],
  filteredClients: string[],
  filteredEventTypes: string[],
  visibilitySettings: map,
  metadata: map
}
```

## Indexes

### Required Indexes

1. Project Templates:
```
projectTemplates:
  - type, isArchived, createdAt
  - type, name, isArchived
```

2. Projects:
```
projects:
  - clientId, type, status
  - templateId, status, startDate
  - type, status, startDate
```

3. Calendar Events:
```
calendarEvents:
  - projectId, startTime
  - clientId, startTime
  - type, startTime
  - status, startTime
```

## Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Project Templates
    match /projectTemplates/{templateId} {
      allow read: if isAuthenticated();
      allow write: if isAdmin();
    }
    
    // Projects
    match /projects/{projectId} {
      allow read: if isProjectMember(projectId);
      allow write: if isProjectManager(projectId);
    }
    
    // Calendar Events
    match /calendarEvents/{eventId} {
      allow read: if canViewEvent(eventId);
      allow write: if canManageEvent(eventId);
    }
    
    // Calendar Views
    match /users/{userId}/calendarViews/{viewId} {
      allow read, write: if request.auth.uid == userId;
    }
  }
}
```

## Optimization Considerations

1. Denormalization Strategies:
   - Cache frequently accessed project data in the client document
   - Store latest event details in project document
   - Keep running counters for tasks/events status

2. Collection Group Queries:
   - Enable collection group queries for tasks across all projects
   - Enable collection group queries for events across all calendars

3. Batch Operations:
   - Use batch writes for creating new projects from templates
   - Use transactions for updating event series
   - Use batch operations for status updates affecting multiple documents

4. Real-time Updates:
   - Implement server-side triggers for status updates
   - Use cloud functions for recurring event generation
   - Set up triggers for notification generation

5. Data Validation:
   - Implement server-side validation for date ranges
   - Validate workflow state transitions
   - Enforce project template integrity
