This is the [Camdram](https://www.camdram.net/) fork of [Brimir](http://getbrimir.com/) that we use for our ticket support system.

You should take a look at the [upstream](https://github.com/ivaldi/brimir) for the latest changes and releases.

---

### Camdram Installation Instructions
1. `git clone https://github.com/camdram/brimir.git && cd brimir`
2. Copy the `Procfile.local` file from old to new 
3. `bundle install --without development test --deployment`
4. `procodile run -- bundle exec rake db:migrate`
5. `procodile run -- bundle exec rake assets:precompile`
6. `procodile start`
