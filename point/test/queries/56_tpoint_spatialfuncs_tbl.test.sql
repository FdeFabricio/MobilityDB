-------------------------------------------------------------------------------
--
-- This MobilityDB code is provided under The PostgreSQL License.
--
-- Copyright (c) 2016-2021, Université libre de Bruxelles and MobilityDB
-- contributors
--
-- Permission to use, copy, modify, and distribute this software and its
-- documentation for any purpose, without fee, and without a written 
-- agreement is hereby granted, provided that the above copyright notice and
-- this paragraph and the following two paragraphs appear in all copies.
--
-- IN NO EVENT SHALL UNIVERSITE LIBRE DE BRUXELLES BE LIABLE TO ANY PARTY FOR
-- DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING
-- LOST PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION,
-- EVEN IF UNIVERSITE LIBRE DE BRUXELLES HAS BEEN ADVISED OF THE POSSIBILITY 
-- OF SUCH DAMAGE.
--
-- UNIVERSITE LIBRE DE BRUXELLES SPECIFICALLY DISCLAIMS ANY WARRANTIES, 
-- INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
-- AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS ON
-- AN "AS IS" BASIS, AND UNIVERSITE LIBRE DE BRUXELLES HAS NO OBLIGATIONS TO 
-- PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS. 
--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------

-- set parallel_tuple_cost=0;
-- set parallel_setup_cost=0;
set force_parallel_mode=regress;

-------------------------------------------------------------------------------

SELECT DISTINCT SRID(temp) FROM tbl_tgeompoint;
SELECT DISTINCT SRID(temp) FROM tbl_tgeogpoint;
SELECT DISTINCT SRID(temp) FROM tbl_tgeompoint3D;
SELECT DISTINCT SRID(temp) FROM tbl_tgeogpoint3D;

/*
SELECT setSRID(temp,5676) FROM tbl_tgeompoint;
SELECT setSRID(temp,4326) FROM tbl_tgeogpoint;
SELECT setSRID(temp,5676) FROM tbl_tgeompoint3D;
SELECT setSRID(temp,4326) FROM tbl_tgeogpoint3D;
*/

SELECT count(*) FROM tbl_tgeompoint WHERE startValue(transform(setSRID(temp, 5676), 4326)) = st_transform(st_setSRID(startValue(temp), 5676), 4326);
SELECT count(*) FROM tbl_tgeompoint3D WHERE startValue(transform(setSRID(temp, 5676), 4326)) = st_transform(st_setSRID(startValue(temp), 5676), 4326);

-------------------------------------------------------------------------------
-- Transform by using Gauss Kruger Projection that is used in Secondo

SELECT round(MAX(ST_X(startValue(transform_gk(temp))))::numeric, 6) FROM tbl_tgeompoint;

SELECT round(MAX(ST_X(transform_gk(g)))::numeric, 6) FROM tbl_geom_point LIMIT 10;
SELECT round(MAX(ST_X(ST_StartPoint(transform_gk(g))))::numeric, 6) FROM tbl_geom_linestring LIMIT 10;

-------------------------------------------------------------------------------

SELECT tgeogpoint(temp) FROM tbl_tgeompoint LIMIT 10;
SELECT tgeompoint(temp) FROM tbl_tgeogpoint LIMIT 10;
SELECT tgeogpoint(temp) FROM tbl_tgeompoint3D LIMIT 10;
SELECT tgeompoint(temp) FROM tbl_tgeogpoint3D LIMIT 10;

SELECT temp::tgeogpoint FROM tbl_tgeompoint LIMIT 10;
SELECT temp::tgeompoint FROM tbl_tgeogpoint LIMIT 10;
SELECT temp::tgeogpoint FROM tbl_tgeompoint3D LIMIT 10;
SELECT temp::tgeompoint FROM tbl_tgeogpoint3D LIMIT 10;

SELECT asText(setPrecision(temp, 2)) FROM tbl_tgeompoint LIMIT 10;
SELECT asText(setPrecision(temp, 2)) FROM tbl_tgeogpoint LIMIT 10;
SELECT asText(setPrecision(temp, 2)) FROM tbl_tgeompoint3D LIMIT 10;
SELECT asText(setPrecision(temp, 2)) FROM tbl_tgeogpoint3D LIMIT 10;

SELECT round(MAX(twavg(getX(temp)))::numeric, 6) FROM tbl_tgeompoint;
SELECT round(MAX(twavg(getX(temp)))::numeric, 6) FROM tbl_tgeogpoint;
SELECT round(MAX(twavg(getY(temp)))::numeric, 6) FROM tbl_tgeompoint;
SELECT round(MAX(twavg(getY(temp)))::numeric, 6) FROM tbl_tgeogpoint;

SELECT round(MAX(twavg(getX(temp)))::numeric, 6) FROM tbl_tgeompoint3D;
SELECT round(MAX(twavg(getX(temp)))::numeric, 6) FROM tbl_tgeogpoint3D;
SELECT round(MAX(twavg(getY(temp)))::numeric, 6) FROM tbl_tgeompoint3D;
SELECT round(MAX(twavg(getY(temp)))::numeric, 6) FROM tbl_tgeogpoint3D;
SELECT round(MAX(twavg(getZ(temp)))::numeric, 6) FROM tbl_tgeompoint3D;
SELECT round(MAX(twavg(getZ(temp)))::numeric, 6) FROM tbl_tgeogpoint3D;

SELECT trajectory(temp) FROM tbl_tgeompoint ORDER BY k LIMIT 10 ;
SELECT trajectory(temp) FROM tbl_tgeogpoint ORDER BY k LIMIT 10 ;
SELECT trajectory(temp) FROM tbl_tgeompoint3D ORDER BY k LIMIT 10 ;
SELECT trajectory(temp) FROM tbl_tgeogpoint3D ORDER BY k LIMIT 10 ;

SELECT round(MAX(length(temp))::numeric, 6) FROM tbl_tgeompoint;
SELECT round(MAX(length(temp))::numeric, 6) FROM tbl_tgeompoint3D;
-- Tests independent of PROJ version
SELECT count(*) FROM tbl_tgeogpoint WHERE length(temp) = ST_Length(trajectory(temp));
SELECT count(*) FROM tbl_tgeogpoint3D WHERE length(temp) = ST_Length(trajectory(temp));

SELECT round(MAX(maxValue(cumulativeLength(temp)))::numeric, 6) FROM tbl_tgeompoint;
SELECT round(MAX(maxValue(cumulativeLength(temp)))::numeric, 6) FROM tbl_tgeogpoint;
SELECT round(MAX(maxValue(cumulativeLength(temp)))::numeric, 6) FROM tbl_tgeompoint3D;
SELECT round(MAX(maxValue(cumulativeLength(temp)))::numeric, 6) FROM tbl_tgeogpoint3D;

SELECT round(MAX(maxValue(speed(temp)))::numeric, 6) FROM tbl_tgeompoint;
SELECT round(MAX(maxValue(speed(temp)))::numeric, 6) FROM tbl_tgeompoint3D;
-- Tests intended to avoid floating point precision errors
SELECT count(*) FROM tbl_tgeogpoint WHERE startValue(speed(temp)) <> 0 AND startTimestamp(temp) = startTimestamp(speed(temp))
AND abs(startValue(speed(temp)) - st_distance(startValue(temp), getValue(instantN(temp,2))) / EXTRACT(epoch FROM timestampN(temp,2) - startTimestamp(temp))) < 1e-5;
SELECT count(*) FROM tbl_tgeogpoint3D WHERE startValue(speed(temp)) <> 0 AND startTimestamp(temp) = startTimestamp(speed(temp))
AND abs(startValue(speed(temp)) - st_distance(startValue(temp), getValue(instantN(temp,2))) / EXTRACT(epoch FROM timestampN(temp,2) - startTimestamp(temp))) < 1e-5;

SELECT st_astext(twcentroid(temp)) FROM tbl_tgeompoint LIMIT 10;
SELECT st_astext(twcentroid(temp)) FROM tbl_tgeompoint3D LIMIT 10;

SELECT round(azimuth(temp), 12) FROM tbl_tgeompoint WHERE azimuth(temp) IS NOT NULL LIMIT 10;
SELECT round(azimuth(temp), 12) FROM tbl_tgeogpoint WHERE azimuth(temp) IS NOT NULL LIMIT 10;
SELECT round(azimuth(temp), 12) FROM tbl_tgeompoint3D WHERE azimuth(temp) IS NOT NULL LIMIT 10;
SELECT round(azimuth(temp), 12) FROM tbl_tgeogpoint3D WHERE azimuth(temp) IS NOT NULL LIMIT 10;

-------------------------------------------------------------------------------

SELECT COUNT(*) FROM tbl_tgeompoint WHERE isSimple(temp);
SELECT COUNT(*) FROM tbl_tgeompoint3D WHERE isSimple(temp);

SELECT SUM(numInstants(t)) FROM tbl_tgeompoint, unnest(makeSimple(temp)) t;
SELECT SUM(numInstants(t)) FROM tbl_tgeompoint3D, unnest(makeSimple(temp)) t;
SELECT DISTINCT merge(makeSimple(temp)) = temp from tbl_tgeompoint;
SELECT DISTINCT merge(makeSimple(temp)) = temp from tbl_tgeompoint3D;

-------------------------------------------------------------------------------

SELECT COUNT(*) FROM tbl_tgeompoint t1, tbl_geometry t2 WHERE
-- Modulo used to reduce time needed for the tests
t1.k % 2 = 0 AND temp != merge(atGeometry(temp, g), minusGeometry(temp, g));

SELECT COUNT(*)  FROM tbl_tgeompoint t1, tbl_stbox t2 WHERE temp != merge(atStbox(temp, b), minusStbox(temp, b));
SELECT COUNT(*)  FROM tbl_tgeogpoint t1, tbl_geodstbox t2 WHERE temp != merge(atStbox(temp, b), minusStbox(temp, b));

-------------------------------------------------------------------------------

-- set parallel_tuple_cost=100;
-- set parallel_setup_cost=100;
set force_parallel_mode=off;

-------------------------------------------------------------------------------
