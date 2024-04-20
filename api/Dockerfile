# Official Dart image: https://hub.docker.com/_/dart
# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.17)
FROM dart:beta AS build

WORKDIR /app

# Copy Dependencies
COPY packages/db_client ./packages/db_client
COPY packages/encryption_middleware ./packages/encryption_middleware
COPY packages/game_domain ./packages/game_domain
COPY packages/jwt_middleware ./packages/jwt_middleware
COPY packages/leaderboard_repository ./packages/leaderboard_repository
COPY packages/board_renderer ./packages/board_renderer
COPY packages/crossword_repository ./packages/crossword_repository
COPY packages/firebase_cloud_storage ./packages/firebase_cloud_storage
COPY packages/hint_repository ./packages/hint_repository

# Install Dependencies
RUN dart pub get -C packages/db_client
RUN dart pub get -C packages/encryption_middleware
RUN dart pub get -C packages/game_domain
RUN dart pub get -C packages/jwt_middleware
RUN dart pub get -C packages/leaderboard_repository
RUN dart pub get -C packages/crossword_repository
RUN dart pub get -C packages/firebase_cloud_storage
RUN dart pub get -C packages/hint_repository

# Resolve app dependencies.
COPY pubspec.* ./
RUN dart pub get

# Copy app source code and AOT compile it.
COPY . .

# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
RUN dart compile exe bin/server.dart -o bin/server

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/
COPY --from=build /app/public /public/

# Start server.
CMD ["/app/bin/server"]
