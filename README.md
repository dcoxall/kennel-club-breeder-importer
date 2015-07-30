UK Kennel Club Breeder Importer
===============================

After purchasing my own dog from a registered KC breeder I felt many of the
pains that other people have. The site isn't easy to use and the temptation to
simply google "puppies for sale" is large.

I decided that I could build a site that could better present breeder
information but with a stronger emphasis on highlighting local breeders so
visitors could find breeders near to them and discuss reserving a pup from their
next litter.

I built this project as a proof of concept. It needed to scrape breeder, breed
and litter data from the Kennel Club website in a way that could be maintained.

It worked! But the Kennel Club refused me permission to use their data for the
site. So instead I am open sourcing it as a demonstration of how this can be
done.

Architecture
------------

Built as a single Rails application. I have removed all the controllers as that
side of the application was un-finished. I have left the import jobs however.

Imports are performed using the Job classes:

`KennelClubBreedImportJob` will fetch all the breeds supported by the Kennel
Club.

`KennelClubBreederDiscoveryJob` will discover all the breeders for a specific
breed and for each breeder it will trigger another job...

`KennelClubBreederImportJob` imports the phone number, location, breeds and
litters for a selected breeder.

By using ActiveJob and Sidekiq there is a default retry mechanism in-place which
is helpful for connection problems. They have been designed so they _could_ be
concurrent but I haven't tested that.

Development & Testing
---------------------

To run the test suite I recommend using the Docker setup.

    docker-compose run app rake db:setup
    docker-compose run app rake
