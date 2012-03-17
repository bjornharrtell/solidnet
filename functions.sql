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
