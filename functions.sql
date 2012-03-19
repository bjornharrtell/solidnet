-- create Link with geometry
CREATE OR REPLACE FUNCTION createlink(geom geometry)
  RETURNS boolean AS $$

DECLARE
  newid uuid;
  startPoint geometry := ST_StartPoint(geom);
  endPoint geometry := ST_EndPoint(geom);
BEGIN
  INSERT INTO links (geom)
    VALUES (geom)
    RETURNING id
    INTO newid;
  
  INSERT INTO linkports (link, distance, geom)
    VALUES (newid, 0, startPoint);

  INSERT INTO linkports (link, distance, geom)
    VALUES (newid, 1, endPoint);
  
  -- autocreate nodes
  -- TODO: do not create node if already a node at this location, reuse it instead
  
  INSERT INTO nodes (created, geom)
    VALUES (now(), startPoint)
    RETURNING id
    INTO newid;
    
  INSERT INTO nodeslinkports (node, linkport)
    SELECT newid, id FROM linkports WHERE startPoint && linkports.geom;
  
  INSERT INTO nodes (created, geom)
    VALUES (now(), endPoint);
    
  INSERT INTO nodeslinkports (node, linkport)
    SELECT newid, id FROM linkports WHERE endPoint && linkports.geom;
  
  INSERT INTO nodes (created, geom)
    VALUES (now(), endPoint);

  RETURN true;
END;

$$ LANGUAGE plpgsql VOLATILE;

-- create Linkport from point on Link with linkid
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
