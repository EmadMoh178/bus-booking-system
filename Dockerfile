# Use Ruby 3.0.2
FROM ruby:3.0.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the working directory
COPY Gemfile Gemfile.lock ./

# Install the specified version of Bundler
RUN gem install bundler:2.2.22

# Install gems
RUN bundle install

# Copy the rest of the application code
COPY . .

# Expose port 3000 to the Docker host
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
