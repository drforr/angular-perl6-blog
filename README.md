angular-perl6-blog
==================

Doesn't look very blog-like at the moment, but that will change.

Installation
============

You need:

Perl 6 (available at www.perl6.org)
Bailador for Perl 6 (available via zef)
Node.js (available at www.nodejs.org)
Angular 4 (available at www.angular.io - angularjs is for an older version.)

Assuming all of the above are installed:

```
$ cd angular-perl6-blog
$ npm install
$ npm start
  <ctrl-C>
```

This process *will* open a new browser tab or window, go to that tab and verify
that the Node version of the application works, and then kill the Node server
and close the tab BrowserSync opened.

Running
=======

Now it's time to start Bailador with:

```
$ perl bin/app.pl
# point a browser to http://localhost:3000/
```

And you should have a fully-operational weap...er, web server running on port
3000 - Go to http:///localhost:3000/ in your browser and after a few seconds of
seeing a 'Loading...' text blurb, an Angular web page should appear. This is
ripp...er, lovingly copied from the official Angular tutorial, and is a fully
functional Angular application. Search, live editing, viewing details and
enabling content should all work natively.

Troubleshooting
===============

If it *doesn't*, then it's time to dig in to the application a bit. Angular
(at least the way I have it set up) takes the TypeScript code (the .ts files in
src/app) and compiles it into JavaScript, then serves up the JavaScript files.
That's the process that 'npm start' did during the installation. Or it should
have done so. Look in the src/app directory, and for every .ts file there should
be an associated .js and .js.map file present. If there isn't, redo 'npm start'
and make sure that when the browser window opens, that you get what looks to be
a working application, or at least something with some shiny buttons that you
can click, rather than 'Loading...'

If you get stuck, find the Bailador Slack group and ask @drforr, or more rarely
freenode.net #perl6 - mostly because "modern" editors take up the screen space
usually reserved for chat windows.
