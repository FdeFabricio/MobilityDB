/*****************************************************************************
 *
 * This MobilityDB code is provided under The PostgreSQL License.
 *
 * Copyright (c) 2016-2021, Université libre de Bruxelles and MobilityDB
 * contributors
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without a written
 * agreement is hereby granted, provided that the above copyright notice and
 * this paragraph and the following two paragraphs appear in all copies.
 *
 * IN NO EVENT SHALL UNIVERSITE LIBRE DE BRUXELLES BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING
 * LOST PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION,
 * EVEN IF UNIVERSITE LIBRE DE BRUXELLES HAS BEEN ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 *
 * UNIVERSITE LIBRE DE BRUXELLES SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS ON
 * AN "AS IS" BASIS, AND UNIVERSITE LIBRE DE BRUXELLES HAS NO OBLIGATIONS TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS. 
 *
 *****************************************************************************/

/**
 * tnpoint_spatialrels.sql
 * Spatial relationships for temporal network points.
 *
 * These relationships are generalized to the temporal dimension with the
 * "at any instant" semantics, that is, the traditional operator is applied to
 * the union of all values taken by the temporal npoint and returns a Boolean.
 * The following relationships are supported:
 *    contains, disjoint, intersects, touches, and dwithin
 * All these relationships, excepted disjoint, will automatically
 * include a bounding box comparison that will make use of any spatial,
 * temporal, or spatiotemporal indexes that are available.
 */

/*****************************************************************************
 * contains
 *****************************************************************************/

CREATE FUNCTION _contains(geometry, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'contains_geo_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION contains(geometry, tnpoint)
  RETURNS boolean
  AS 'SELECT $1 OPERATOR(@extschema@.@>) $2 AND @extschema@._contains($1,$2)'
  LANGUAGE 'sql' IMMUTABLE PARALLEL SAFE;

/*****************************************************************************
 * disjoint
 *****************************************************************************/

CREATE FUNCTION disjoint(geometry, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'disjoint_geo_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION disjoint(npoint, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'disjoint_npoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION disjoint(tnpoint, geometry)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'disjoint_tnpoint_geo'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION disjoint(tnpoint, npoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'disjoint_tnpoint_npoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

/*****************************************************************************
 * intersects
 *****************************************************************************/

CREATE FUNCTION _intersects(geometry, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'intersects_geo_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION intersects(geometry, tnpoint)
  RETURNS boolean
  AS 'SELECT $1 OPERATOR(@extschema@.&&) $2 AND @extschema@._intersects($1,$2)'
  LANGUAGE 'sql' IMMUTABLE PARALLEL SAFE;

CREATE FUNCTION _intersects(npoint, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'intersects_npoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION intersects(npoint, tnpoint)
  RETURNS boolean
  AS 'SELECT $1 OPERATOR(@extschema@.&&) $2 AND @extschema@._intersects($1,$2)'
  LANGUAGE 'sql' IMMUTABLE PARALLEL SAFE;

CREATE FUNCTION _intersects(tnpoint, geometry)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'intersects_tnpoint_geo'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION intersects(tnpoint, geometry)
  RETURNS boolean
  AS 'SELECT $1 OPERATOR(@extschema@.&&) $2 AND @extschema@._intersects($1,$2)'
  LANGUAGE 'sql' IMMUTABLE PARALLEL SAFE;

CREATE FUNCTION _intersects(tnpoint, npoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'intersects_tnpoint_npoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION intersects(tnpoint, npoint)
  RETURNS boolean
  AS 'SELECT $1 OPERATOR(@extschema@.&&) $2 AND @extschema@._intersects($1,$2)'
  LANGUAGE 'sql' IMMUTABLE PARALLEL SAFE;

/*****************************************************************************
 * touches
 *****************************************************************************/

CREATE FUNCTION _touches(geometry, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'touches_geo_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION touches(geometry, tnpoint)
  RETURNS boolean
  AS 'SELECT $1 OPERATOR(@extschema@.&&) $2 AND @extschema@._touches($1,$2)'
  LANGUAGE 'sql' IMMUTABLE PARALLEL SAFE;

CREATE FUNCTION _touches(npoint, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'touches_npoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION touches(npoint, tnpoint)
  RETURNS boolean
  AS 'SELECT $1 OPERATOR(@extschema@.&&) $2 AND @extschema@._touches($1,$2)'
  LANGUAGE 'sql' IMMUTABLE PARALLEL SAFE;

CREATE FUNCTION _touches(tnpoint, geometry)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'touches_tnpoint_geo'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION touches(tnpoint, geometry)
  RETURNS boolean
  AS 'SELECT $1 OPERATOR(@extschema@.&&) $2 AND @extschema@._touches($1,$2)'
  LANGUAGE 'sql' IMMUTABLE PARALLEL SAFE;

CREATE FUNCTION _touches(tnpoint, npoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'touches_tnpoint_npoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION touches(tnpoint, npoint)
  RETURNS boolean
  AS 'SELECT $1 OPERATOR(@extschema@.&&) $2 AND @extschema@._touches($1,$2)'
  LANGUAGE 'sql' IMMUTABLE PARALLEL SAFE;

/*****************************************************************************
 * dwithin
 *****************************************************************************/

CREATE FUNCTION _dwithin(geometry, tnpoint, dist float8)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'dwithin_geo_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION dwithin(geometry, tnpoint, dist float8)
  RETURNS boolean
  AS 'SELECT @extschema@.ST_Expand($1,$3) OPERATOR(@extschema@.&&) $2 AND @extschema@._dwithin($1, $2, $3)'
  LANGUAGE 'sql' IMMUTABLE PARALLEL SAFE;

CREATE FUNCTION _dwithin(npoint, tnpoint, dist float8)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'dwithin_npoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION dwithin(npoint, tnpoint, dist float8)
  RETURNS boolean
  AS 'SELECT @extschema@.expandSpatial($1,$3) OPERATOR(@extschema@.&&) $2 AND @extschema@._dwithin($1, $2, $3)'
  LANGUAGE 'sql' IMMUTABLE PARALLEL SAFE;

CREATE FUNCTION _dwithin(tnpoint, geometry, dist float8)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'dwithin_tnpoint_geo'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION dwithin(tnpoint, geometry, dist float8)
  RETURNS boolean
  AS 'SELECT $1 OPERATOR(@extschema@.&&) @extschema@.ST_Expand($2,$3) AND @extschema@._dwithin($1, $2, $3)'
  LANGUAGE 'sql' IMMUTABLE PARALLEL SAFE;

CREATE FUNCTION _dwithin(tnpoint, npoint, dist float8)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'dwithin_tnpoint_npoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION dwithin(tnpoint, npoint, dist float8)
  RETURNS boolean
  AS 'SELECT $1 OPERATOR(@extschema@.&&) @extschema@.expandSpatial($2,$3) AND @extschema@._dwithin($1, $2, $3)'
  LANGUAGE 'sql' IMMUTABLE PARALLEL SAFE;

CREATE FUNCTION dwithin(tnpoint, tnpoint, dist float8)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'dwithin_tnpoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

/*****************************************************************************/
