# syntax = docker/dockerfile:1

# Define Ruby version
ARG RUBY_VERSION=3.2.2
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Set working directory
WORKDIR /rails

# Set environment variables for production
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    NODE_ENV="production"

# Build stage - used to install dependencies and compile assets
FROM base as build

# Install required system packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libpq-dev \
    libvips \
    pkg-config \
    curl && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js 18.x & Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

# Copy dependency files first for better caching
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Copy package.json and yarn.lock before running yarn
COPY package.json yarn.lock ./

# Install JavaScript dependencies
RUN yarn install --frozen-lockfile --production

# Copy the rest of the application
COPY . .

# Build CSS (ensure this script exists in your package.json)
RUN if [ -f "package.json" ]; then yarn build:css; fi

# Precompile bootsnap for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompile assets safely using a dummy secret key
RUN SECRET_KEY_BASE=dummy ./bin/rails assets:precompile

# Final deployment image
FROM base

# Install required runtime packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libvips \
    postgresql-client && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# Copy built artifacts from the build stage
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Create a non-root user and set ownership
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

# Set working directory and user
WORKDIR /rails
USER rails:rails

# Set entrypoint script to prepare database
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Expose application port
EXPOSE 3099

# Start the Rails server by default
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]