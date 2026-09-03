# RaceDay API Endpoint Plan

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|-------------|-------|-------------|---------------|--------------|-------------------|
| POST | /api/auth/register | Register a new user (participant or organiser). | None | { email, password, fullName, role } | 201 Created – user details <br> 400 Bad Request – validation errors |
| POST | /api/auth/login | Authenticate and return a JWT token. | None | { email, password } | 200 OK – { token, user } <br> 401 Unauthorized – invalid credentials |
| GET | /api/users/me | Get the currently logged-in user's profile. | Any (logged in) | None | 200 OK – user details |
| PUT | /api/users/me | Update the current user's profile. | Any (logged in) | { fullName } | 200 OK – updated user |
| GET | /api/events | List all events (filter by status, date, etc.). | None (public) | None | 200 OK – array of events |
| GET | /api/events/{id} | Get details of a specific event, including its categories. | None (public) | None | 200 OK – event with categories <br> 404 Not Found |
| POST | /api/events | Create a new event. | Organiser | { title, description, date, time, location, status } | 201 Created – new event |
| PUT | /api/events/{id} | Update an existing event. | Organiser | { title, description, date, time, location, status } | 200 OK – updated event <br> 403 Forbidden |
| DELETE | /api/events/{id} | Delete an event. | Organiser | None | 204 No Content |
| GET | /api/categories | List all categories. | None (public) | None | 200 OK – array of categories |
| POST | /api/categories | Create a new category. | Organiser | { name, description } | 201 Created – new category |
| PUT | /api/categories/{id} | Update a category. | Organiser | { name, description } | 200 OK – updated |
| DELETE | /api/categories/{id} | Delete a category (only if not used). | Organiser | None | 204 No Content <br> 409 Conflict |
| POST | /api/events/{eventId}/categories | Add a category to an event. | Organiser | { categoryId, price, maxParticipants } | 201 Created – EventCategory |
| DELETE | /api/events/{eventId}/categories/{categoryId} | Remove a category from an event. | Organiser | None | 204 No Content |
| GET | /api/events/{eventId}/enrolments | Get all enrolments for an event. | Organiser | None | 200 OK – array of enrolments |
| POST | /api/events/{eventId}/categories/{categoryId}/enrol | Participant enrols in a specific event category. | Participant | None | 201 Created – enrolment |
| GET | /api/users/me/enrolments | Get current participant's enrolments. | Participant | None | 200 OK – enrolments |
| PUT | /api/enrolments/{id}/cancel | Cancel an enrolment. | Participant | None | 200 OK – status updated |
| GET | /api/events/{eventId}/results | Get results for an event. | Organiser | None | 200 OK – results |
| POST | /api/enrolments/{enrolmentId}/result | Capture a result for an enrolment. | Organiser | { finishTime, position, status, notes } | 201 Created – result |
| GET | /api/users/me/results | Get current participant's personal results. | Participant | None | 200 OK – list of results |
