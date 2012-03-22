-- create Link from LineString geometry
CREATE OR REPLACE FUNCTION createlink(linestring geometry)
  RETURNS boolean AS $$

DECLARE
  newlinkid uuid;
  nodeid uuid;
  linkportid uuid;
  startPoint geometry := ST_StartPoint(linestring);
  endPoint geometry := ST_EndPoint(linestring);
BEGIN
  -- create new Link
  INSERT INTO links (geom)
    VALUES (linestring)
    RETURNING id
    INTO newlinkid;

  -- get id of existing Node at start location
  nodeid := (SELECT id FROM nodes where geom && startPoint);

  -- if no existing Node, create one
  IF nodeid IS NULL THEN
    INSERT INTO nodes (created, geom)
      VALUES (now(), startPoint)
      RETURNING id
      INTO nodeid;
  END IF;

  -- create start Linkport for new Link
  INSERT INTO linkports (link, distance, geom)
    VALUES (newlinkid, 0, startPoint)
    RETURNING id
    INTO linkportid;

  -- connect Node to start Linkport
  INSERT INTO nodeslinkports (node, linkport)
    VALUES (nodeid, linkportid);

  -- get id of existing Node at start location
  nodeid := (SELECT id FROM nodes where geom && endPoint);

  -- if no existing Node, create one
  IF nodeid IS NULL THEN
    INSERT INTO nodes (created, geom)
      VALUES (now(), endPoint)
      RETURNING id
      INTO nodeid;
  END IF;

  -- create end Linkport for new Link
  INSERT INTO linkports (link, distance, geom)
    VALUES (newlinkid, 1, endPoint)
    RETURNING id
    INTO linkportid;
    
  -- connect Node to start Linkport
  INSERT INTO nodeslinkports (node, linkport)
    VALUES (nodeid, linkportid);

  RETURN true;
END;

$$ LANGUAGE plpgsql VOLATILE;

-- create Linkport from linkid and Point geometry
CREATE OR REPLACE FUNCTION createport(linkid uuid, point geometry)
  RETURNS boolean AS $$

DECLARE
  linkgeom geometry;
  distance double precision;
BEGIN
  linkgeom := (SELECT geom FROM links WHERE id=linkid);
  distance := (SELECT ST_Line_Locate_Point(linkgeom, point));
  point := (SELECT ST_Line_Interpolate_Point(linkgeom, distance));
  
  INSERT INTO linkports (link, distance, geom)
    VALUES (linkid, distance, point);

  RETURN true;
END;

$$ LANGUAGE plpgsql VOLATILE;
