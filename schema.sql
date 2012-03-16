-- SolidNet
-- PostgreSQL schema for stable link entity networks
-- requires PostGIS and uuid-ossp extension

-- contains representations of Link
CREATE TABLE links
(
  id uuid NOT NULL DEFAULT uuid_generate_v1(),
  CONSTRAINT reflinks_pkey PRIMARY KEY (id)
);
-- store each Link geometry as simple linestring
-- perhaps real topology one day with PostGIS 2.0+ ?
SELECT AddGeometryColumn('links', 'geom', -1, 'LINESTRING', 2);

-- contains representations of Node
CREATE TABLE nodes
(
  id uuid NOT NULL DEFAULT uuid_generate_v1(),
  created timestamp without time zone NOT NULL,
  ended timestamp without time zone,
  CONSTRAINT nodes_pkey PRIMARY KEY (id)
);
-- intentional redundant geometry for speed
SELECT AddGeometryColumn('nodes', 'geom', -1, 'POINT', 2);

-- contains representations of Linkport
CREATE TABLE linkports
(
  id uuid NOT NULL DEFAULT uuid_generate_v1(),
  link uuid NOT NULL,
  distance double precision NOT NULL,
  CONSTRAINT linkports_pkey PRIMARY KEY (id),
  CONSTRAINT linkports_link_fkey FOREIGN KEY (link)
      REFERENCES links (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
);
-- intentional redundant geometry for speed
SELECT AddGeometryColumn('linkports', 'geom', -1, 'POINT', 2);

-- contains representations of Linkpart
CREATE TABLE linkparts
(
  id uuid NOT NULL DEFAULT uuid_generate_v1(),
  starttime timestamp NOT NULL,
  endtime timestamp,
  fromlinkport uuid NOT NULL,
  tolinkport uuid NOT NULL,
  CONSTRAINT linkparts_pkey PRIMARY KEY (id),
  CONSTRAINT linkparts_tolinkport_fkey FOREIGN KEY (tolinkport)
      REFERENCES linkports (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT linkparts_fromlinkport_fkey FOREIGN KEY (fromlinkport)
      REFERENCES linkports (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
);
-- intentional redundant geometry for speed
SELECT AddGeometryColumn('linkparts', 'geom', -1, 'LINESTRING', 2);

-- contains connections between Nodes and Linkports
CREATE TABLE nodeslinkports
(
  node uuid NOT NULL,
  linkport uuid NOT NULL,
  CONSTRAINT nodeslinkports_pkey PRIMARY KEY (node, linkport),
  CONSTRAINT nodeslinkports_node_fkey FOREIGN KEY (node)
      REFERENCES nodes (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT nodeslinkports_linkport_fkey FOREIGN KEY (linkport)
      REFERENCES linkports (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
);
