SolidNet
========

A reference implementation of stable link entity network for
PostgreSQL/PostGIS. Also includes a basic server/client for
editing the network.

NOTE: Experimental work. Not even close to being finished or
functional.

Introduction
------------

A stable link entity network is a topological network allowing
use of linear referencing for both attribute data and location
for link connections.

The purpose for allowing a link to connect to another link at
a linear location is that the latter link does not have to
be split as would be the case in traditional node-link networks.

A mandatory attribute data in the model is from and to date
for links. This allows for discontinuation of no longer existing 
parts of links, again without requiring any change to link
geometry.

The above results in links that essentially live forever with
stable identities that can be be used to linearly reference
attribute data in disconnected distributed databases.

The model also includes nodes at points where links connects.
Nodes have potentially a limited lifespan and their main purpose
is to be used as a reference for information that references
the link connection, like turn restriction information.

One use case for this model is modeling road networks with
connected links and overlapping attribute data owned and managed
by separate organisations.

Development requirements
------------------------

 * Ubuntu or similar assumed
 * PostgreSQL 9.0+ (http://www.postgresql.org)
 * PostGIS 1.5+ (http://postgis.refractions.net)
 * OpenLayers 3.x (master branch from github) (http://openlayers.org) in root
 * Ext JS 4.0+ (http://www.sencha.com) in root
 * Node.js (http://nodejs.org)
 * NPM (http://npmjs.org/)
 * Coffeescript (http://coffeescript.org)
 * Nodemon (https://github.com/remy/nodemon)

The server module uses node js modules express and pg. If you
do not want/have these modules globally installed you can install
them for the server module locally by running:

    npm install

Start the server for development purposes with:

    nodemon ./src/server/server.coffee

