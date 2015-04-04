## Setup for local development and testing

### Unarchive page assets into project directory

There are two archives containing assets used by the project. Using the
[tar command](https://github.com/tldr-pages/tldr/blob/master/pages/common/tar.md), unarchive them both into the
root of your project directory, with the javascript going into a directory named `js` and the equipment images
going into a directory named `gear`.

Next, retrieve the emoji images from Henrik Joreteg's project,
[emoji-images](https://github.com/HenrikJoreteg/emoji-images). Clone that repository of images into `js/emoji-images`.

### Ensure page behaves normally with your API information

Using your user id and api token, ensure the page loads correctly and behaves exactly like oldgods.net. Resolve any
missing assets and ensure no errors exist in your browser's developer console.

You may need to add a `null.htm` file, and you may doing so by simply creating an empty file named `null.htm` in
the root of the project directory using:

```
touch null.htm
```

### Uncomment TST sections of main page

There are 4 TST sections on the main page. The first is a set of script tags which bring in:

* A series of `<script>` tags
    * [jquery-mockjax](https://github.com/jakerella/jquery-mockjax)
        * A library for mocking ajax requests.
        * Enables test data to be substituted in without actually communicating with HabitRPG.
        * No login necessary for every refresh
    * Testdata files
        * Each file sets a variable containing a long JSON string
        * These strings will inevitably fall out of date, and should be updated as changes are made to HabitRPG
    * Contributors are encouraged to create their own testdata files which may be composed with the existing sets.
* JS Mocks
    * Here is where the actual mocking of ajax requests occurs, as well as the auto-fetch of user data (to avoid
      the need to log in).
    * The test data may be manipulated here to suit any particular test case.
* Alternate webserver configurations
    * Use these configurations if you have an alternate webserver already set up to serve the requests from the page.
* Style and form auto-load
      * This section provides a background style to make it obvious when working with test data
      * It will also auto-load the login form to save a step on a reload

If you wish to use the mocks to avoid making remote requests for data, then uncomment the `<script>` and `JS Mocks` 
sections. Otherwise, only uncomment the section for alternate webserver configuration to redirect any ajax calls to
the new webserver.

The final section with style and auto-load should always be uncommented for convenience with working with test data. 