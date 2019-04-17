# Widget Api Application

## Set up for developmenet

* bundle install

* rake db:create

* rake db:migrate

## For Creating Client ID and Client Secret

* Doorkeeper::Application.create! name: 'Widget API', redirect_uri: 'https://www.app.com/'

## Client ID and Client Secret for Production Environement

* Client ID: 0dc43528615116cca2142d107eaf20f1c4a6fa8e85d9e8b5c575336c2fd411e0
* Client Secret: 0f10b08f11c17a34e76dc285863e94440cce3182d8e87903608f0603e2d294d8

## Test Environment

* Write `rspec` in the terminal to run all specs.
