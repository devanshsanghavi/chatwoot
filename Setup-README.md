***Chatwoot - Local Development Setup on Windows (WSL)***
This readme will walk you through the entire process of setting up the Chatwoot development environment on a Windows machine using WSL (Windows Subsystem for Linux). It includes installation of all prerequisites, backend and frontend setup, running the app locally, and troubleshooting common issues.

***Prerequisites - Ensure that these are installed before running the app***

1. Before beginning, make sure WSL is installed and configured:
Enable Developer Mode in Windows and enable Windows Subsystem for Linux via PowerShell using:

wsl --install

Restart your system if prompted and open a WSL terminal (Ubuntu is recommended).

2. Install Linux System Dependencies:

sudo apt-get update
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev

3. Install RVM and Ruby:

sudo apt-get install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 3.2.2
rvm use 3.2.2 --default
ruby -v

4. Install Node.js-20:

curl -sL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

5. Install pnpm (package manager):

iwr https://get.pnpm.io/install.ps1 -useb | iex

6. Install postgres (database):

sudo apt install postgresql postgresql-contrib

7. Install libpg-dev dependencies for Ubuntu:

sudo apt-get install libpq-dev
sudo service postgresql start

8. Install redis-server and enable it:

sudo apt-get install redis-server
sudo systemctl enable redis-server.service

9. Install imagemagick:

sudo apt-get install imagemagick

***Project Setup***

1. Clone the repository:
First use cd to go to the desired folder. Then clone using:

git clone https://github.com/devanshsanghavi/chatwoot.git

2. Install Ruby & Javascript dependencies:

make burn

3. Configure Environment variables:
First, use the following command to create .env from .env.example:

cp .env.example .env

Next, configure the environment variables according to your setup. Here are some of the recommended environment variables for this WSL setup where everything is being run locally:

a. SECRET_KEY_BASE: Set this to any alphanumeric string (Example: "abcde")
b. FRONTEND_URL=http://localhost:3000
c. ENABLE_ACCOUNT_SIGNUP=true (This is important so that we can create a new account from the frontend to use the app)
d. REDIS_URL=redis://localhost:6379
e. POSTGRES_HOST=localhost
f. POSTGRES_PASSWORD: Your postgres password

4. Set up database:

make db

5. Start up rails server:

foreman start -f Procfile.dev

Now you can access the app on http://localhost:3000

***Some issues you may encounter and potential fixes***

1. NoMethodError: undefined method 'schema_format' while doing make db:

Go to lib/tasks/db_enhancements.rake and change this line:
db_namespace['load_config'].invoke if ActiveRecord::Base.schema_format == :ruby

To this line:
db_namespace['load_config'].invoke if Rails.application.config.active_record.schema_format == :ruby

2. PG::FeatureNotSupported: extension "vector" while doing make db:

Install pgvector extension in PostgreSQL using:
sudo apt install postgresql-16-vector

3. connection to server at "143.244.220.150", port 5432 failed: Connection timed out while doing make db:

Add the following line under development, test and production in config/database.yml:
host: localhost

4. Sign-up option not showing up on frontend despite enabling account signup in .env:

You will have to manually create an account in the Rails console. Open up the rails console using:
bundle exec rails c

Then, create an account:
account = Account.create!(name: 'Default Account')

Create a user (example):
user = User.create!(
  email: 'admin@example.com',
  name: 'Admin',
  password: 'Password1!',
  password_confirmation: 'Password1!',
  confirmed_at: Time.now
)

Link the account and user:
AccountUser.create!(
  account: account,
  user: user,
  role: :administrator
)

This should create an account for you, so you can login using the email and password on the frontend.

***Testing***

1. To run tests use:
bundle exec rspec

2. Use the following for javascript tests:
pnpm test

***References***

https://www.chatwoot.com/docs/contributing-guide

You can use the guide if you want to try different options (using docker) or have a different OS.