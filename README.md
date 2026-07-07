# README

## Running Locally
I'm bouncing around linux distros right now so I opted to just set this up with docker for a more consistent environment setup. You will need docker and docker compose to run via the following instructions.

### Initial Setup
- Navigate to project root
- Run `docker compose build`
- Run `docker compose run web bundle install`
- Run `docker compose run web bundle exec rails db:setup`

### Spin up and Container usage
- After initial setup you can spin up the app with `docker compose up`
- To use the container like any normal rails instance you have two options
1. Run `docker compose exec web bash` to enter the container, now you can run commands like `rails c`
2. Run any rails command prepended with this `docker compose run web`, similar to the pattern in initial setup3


### Takehome Notes
- Instructions say to refer to menu as-is, I interpreted that as assuring that I actually parse it instead of drop the data in the app with an easier format. To be compliant with those instructions and still be 'railsy' I am handling the parsing via seeding and will be using a MenuItem model for the actual code solution. 

- Reading through instructions I think I'll end up making an Order model to have an intuitive spot for validating inputs instead of handling it in the controller. Instructions dont say anything about storing order data but in a real use case I would assume they need to be stored so I'll either just do that or at least make sure its an easy code tweak to save orders to the DB. Having the model ready is most of the work anyways.

### AI Usage Disclaimer
- It's been a while since I've set up a rails project from scratch and my docker knowledge is dated, I directed claude in setting up the docker config.