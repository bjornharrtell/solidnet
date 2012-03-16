CREATE TABLE links
(
  id uuid NOT NULL DEFAULT uuid_generate_v1(),
  created timestamp without time zone NOT NULL,
  updated timestamp without time zone,
  CONSTRAINT reflinks_pkey PRIMARY KEY (id)
);
SELECT AddGeometryColumn('links', 'geom', 4326, 'LINESTRING', 2);

CREATE TABLE nodes
(
  id uuid NOT NULL DEFAULT uuid_generate_v1(),
  created timestamp without time zone NOT NULL,
  ended timestamp without time zone,
  CONSTRAINT nodes_pkey PRIMARY KEY (id)
);
SELECT AddGeometryColumn('nodes', 'geom', 4326, 'POINT', 2);

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
SELECT AddGeometryColumn('linkports', 'geom', 4326, 'POINT', 2);

CREATE TABLE nodeports
(
  id uuid NOT NULL DEFAULT uuid_generate_v1(),
  node uuid NOT NULL,
  CONSTRAINT nodeports_pkey PRIMARY KEY (id ),
  CONSTRAINT nodeports_node_fkey FOREIGN KEY (node)
      REFERENCES nodes (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
);
SELECT AddGeometryColumn('nodeports', 'geom', 4326, 'POINT', 2);

CREATE TABLE linkparts
(
  id uuid NOT NULL DEFAULT uuid_generate_v1(),
  starttime timestamp without time zone NOT NULL,
  endtime timestamp without time zone,
  startport uuid NOT NULL,
  endport uuid NOT NULL,
  CONSTRAINT linkparts_pkey PRIMARY KEY (id),
  CONSTRAINT linkparts_endport_fkey FOREIGN KEY (endport)
      REFERENCES linkports (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT linkparts_startport_fkey FOREIGN KEY (startport)
      REFERENCES linkports (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
);
SELECT AddGeometryColumn('linkparts', 'geom', 4326, 'LINESTRING', 2);

CREATE TABLE nodeportsnodeports
(
  fromport uuid NOT NULL,
  toport uuid NOT NULL,
  CONSTRAINT nodeportsnodeports_pkey PRIMARY KEY (fromport, toport),
  CONSTRAINT nodeportsnodeports_fromport_fkey FOREIGN KEY (fromport)
      REFERENCES nodeports (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT nodeportnodeports_toport_fkey FOREIGN KEY (toport)
      REFERENCES nodeports (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
);

CREATE TABLE nodeportslinkports
(
  fromport uuid NOT NULL,
  toport uuid NOT NULL,
  CONSTRAINT nodeportslinkports_pkey PRIMARY KEY (fromport, toport),
  CONSTRAINT nodeportslinkports_fromport_fkey FOREIGN KEY (fromport)
      REFERENCES nodeports (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT nodeportsnodeports_toport_fkey FOREIGN KEY (toport)
      REFERENCES linkports (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
);

CREATE TABLE linkportslinkports
(
  fromport uuid NOT NULL,
  toport uuid NOT NULL,
  CONSTRAINT linkportslinkports_pkey PRIMARY KEY (fromport, toport),
  CONSTRAINT linkportslinkports_fromport_fkey FOREIGN KEY (fromport)
      REFERENCES linkports (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT nodeportsnodeports_toport_fkey FOREIGN KEY (toport)
      REFERENCES linkports (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
);
