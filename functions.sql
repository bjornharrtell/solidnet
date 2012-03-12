CREATE OR REPLACE FUNCTION createlink(geom geometry)
  RETURNS boolean AS $$

DECLARE
  startPoint geometry := ST_StartPoint(NEW.geom);
  endPoint geometry := ST_EndPoint(NEW.geom);
BEGIN
  INSERT INTO linkports (link, distance, geom)
    VALUES (NEW.id, 0, startPoint);

  INSERT INTO linkports (link, distance, geom)
    VALUES (NEW.id, 1, endPoint);
  
  RETURN NEW;
END;

$$ LANGUAGE plpgsql VOLATILE;
