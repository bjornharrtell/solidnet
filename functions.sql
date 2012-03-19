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
