# Basic Social Media Application

## Overview

Backend for a social media app built with **FastAPI**, offering user authentication, posts with images, commenting, liking, and real-time notifications.

## Technology Stack

- **Backend:** FastAPI, async SQLAlchemy, PostgreSQL, Redis
- **Database:** PostgreSQL + Alembic for migrations
- **Caching/Storage:** Redis for refresh tokens & notifications
- **Authentication:** JWT, HttpOnly cookies, bcrypt for password hashing
- **Validation:** Pydantic
- **File Storage:** R2 for image uploads
- **Reverse Proxy:** Nginx for performance and security

## Core Features

### Authentication & Authorization

- JWT-based login with access & refresh tokens
- Refresh tokens stored in Redis per session (multi-device support)
- HttpOnly cookies to prevent XSS
- Logout revokes refresh tokens

### Posts

- Create/update/delete posts with optional images
- Visibility: `public` (default) or `private`
- Pagination, filtering (author/visibility), sorting (newest, oldest, most liked/commented)
- Denormalized `likes_count` & `comments_count` for performance

### Comments

- Nested comments (parent-child)
- Pagination and top-level filtering
- Update/delete own comments
- Cascading deletion when parent post is deleted
- Denormalized `likes_count` for fast queries

### Likes

- Toggle likes on posts & comments
- Polymorphic model: supports both posts & comments
- Unique constraint per user/content
- Counts automatically incremented/decremented

### Notifications

- Real-time notifications stored in Redis (fire-and-forget)
- Types: post liked, post commented, comment liked
- Expire after 7 days, fetched once per user

## Database Schema

- **Users:** Authentication & profile info; relations: posts, comments, likes
- **Posts:** Content, image, visibility, counts; relations: author, comments
- **Comments:** Nested replies, counts; relations: post, author, parent_comment
- **Likes:** Polymorphic; unique `(user_id, target_type, target_id)`, composite index for fast lookups

## API Endpoints

### Authentication (`/api/auth`)

- `POST /signup` – register
- `POST /login` – login (sets access & refresh tokens)
- `POST /logout` – logout (revoke refresh token)
- `POST /refresh` – refresh access token

### Posts (`/api/posts`)

- `POST /` – create post
- `GET /` – list posts (pagination, filter, sort)
- `GET /{post_id}` – retrieve post
- `PUT /{post_id}` – update post
- `DELETE /{post_id}` – delete post

### Comments (`/api/posts/{post_id}/comments`)

- `POST /` – create comment
- `GET /` – list comments
- `PUT /{comment_id}` – update comment
- `DELETE /{comment_id}` – delete comment

### Likes (`/api/likes`)

- `POST /posts/{post_id}/likes` – toggle post like
- `GET /posts/{post_id}/likes` – get post likes
- `POST /comments/{comment_id}/likes` – toggle comment like
- `GET /comments/{comment_id}/likes` – get comment likes

### Notifications (`/api/notifications`)

- `GET /` – fetch & consume user notifications

## Security Features

- Password hashing with bcrypt
- JWT tokens with expiration
- HttpOnly cookies for refresh tokens
- CORS configured for frontend
- Access control: private posts only visible to authors
- Input validation via Pydantic
- SQL injection protection via ORM

## Key Design Decisions

- Async architecture for high concurrency
- Clean architecture with domain, application, infrastructure, presentation layers
- Repository & use case patterns for data access & business logic
- Denormalized counts for likes & comments
- Redis for notifications
- Optional authentication for some endpoints

## Future Enhancements

- User profiles & friends
- Post sharing
- Persistent notifications
- Rate limiting & throttling
