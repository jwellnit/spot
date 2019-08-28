# changelog

## Unreleased

## [2019.1-pre.4] - 2019-08-28

- updates dependencies
- updates to permission handling
  - adds a depositor role
  - limits creation to depositor and admin roles only
  - hides the dashboard from users who aren't able to deposit
- rewrite Image derivative processing
- add rake task for generating derivatives

## [2019.1-pre.3] - 2019-08-20

- add mounted storage to the whitelisted ingest directories
- update how the SPOT_VERSION constant is defined in deployed environments (#248)
- use bar (`|`) as the default multi_value_character for ingest jobs (#250)
- remove capistrano ingest task (never used)
- add separate ingest task for publications (#251)
- use different favicons for the different deployment environments (#252)
- add an admin facet for `visibility_ssi` (#253)
- update newspaper, magazine, and shakespeare mappers to ingest present digital.lafayette.edu URLs (#249)
- add jpeg compression to access_master creation (#254)
- fix nokogiri vulnerability by bumping to v1.10.4 (#255)
- bugfix: use UV 2.0.1, as Hyrax is expecting to find those files

## [2019.1-pre.2] - 2019-08-05

- update a work's `document.title` to resemble '{work title} // Lafayette Digital Repository'
- add text content to the About page
- add link to the Contact page in site footer
- specify Sidekiq concurrency via capistrano-sidekiq configuration
- use the `:ingest` queue for Hyrax's "ingest-like jobs"
- add 'spot:collections:list' task
- bugfix: don't skip single `dc:date` values when mapping to `date_issued` for magazines
- bugfix: add `tmp/uploads` to capistrano's shared directories
- bugfix: assign roles (via capistrano) on the :web server only

## [2019.1-pre.1] - 2019-07-24

Initial pre-release (live on ldr.stage.lafayette.edu)

[2019.1-pre.4]: https://github.com/LafayetteCollegeLibraries/spot/releases/tag/2019.1-pre.4
[2019.1-pre.3]: https://github.com/LafayetteCollegeLibraries/spot/releases/tag/2019.1-pre.3
[2019.1-pre.2]: https://github.com/LafayetteCollegeLibraries/spot/releases/tag/2019.1-pre.2
[2019.1-pre.1]: https://github.com/LafayetteCollegeLibraries/spot/releases/tag/2019.1-pre.1