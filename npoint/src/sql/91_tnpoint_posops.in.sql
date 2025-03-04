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
 * tnpoint_posops.sql
 * Relative position operators for temporal network points.
 */

CREATE FUNCTION tnpoint_position_sel(internal, oid, internal, integer)
  RETURNS float
  AS 'MODULE_PATHNAME', 'tnpoint_position_sel'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION tnpoint_position_joinsel(internal, oid, internal, smallint, internal)
  RETURNS float
  AS 'MODULE_PATHNAME', 'tnpoint_position_joinsel'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

/*****************************************************************************
 * Geometry
 *****************************************************************************/

CREATE FUNCTION temporal_left(geometry, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'left_geom_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overleft(geometry, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overleft_geom_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_right(geometry, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'right_geom_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overright(geometry, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overright_geom_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_below(geometry, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'below_geom_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overbelow(geometry, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overbelow_geom_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_above(geometry, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'above_geom_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overabove(geometry, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overabove_geom_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR << (
  LEFTARG = geometry, RIGHTARG = tnpoint,
  PROCEDURE = temporal_left,
  COMMUTATOR = '>>',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR &< (
  LEFTARG = geometry, RIGHTARG = tnpoint,
  PROCEDURE = temporal_overleft,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR >> (
  LEFTARG = geometry, RIGHTARG = tnpoint,
  PROCEDURE = temporal_right,
  COMMUTATOR = '<<',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR &> (
  LEFTARG = geometry, RIGHTARG = tnpoint,
  PROCEDURE = temporal_overright,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR <<| (
  LEFTARG = geometry, RIGHTARG = tnpoint,
  PROCEDURE = temporal_below,
  COMMUTATOR = '|>>',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR &<| (
  LEFTARG = geometry, RIGHTARG = tnpoint,
  PROCEDURE = temporal_overbelow,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR |>> (
  LEFTARG = geometry, RIGHTARG = tnpoint,
  PROCEDURE = temporal_above,
  COMMUTATOR = '<<|',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR |&> (
  LEFTARG = geometry, RIGHTARG = tnpoint,
  PROCEDURE = temporal_overabove,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);

/*****************************************************************************
 * stbox
 *****************************************************************************/

CREATE FUNCTION temporal_left(stbox, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'left_stbox_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overleft(stbox, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overleft_stbox_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_right(stbox, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'right_stbox_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overright(stbox, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overright_stbox_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_below(stbox, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'below_stbox_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overbelow(stbox, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overbelow_stbox_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_above(stbox, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'above_stbox_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overabove(stbox, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overabove_stbox_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_before(stbox, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'before_stbox_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overbefore(stbox, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overbefore_stbox_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_after(stbox, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'after_stbox_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overafter(stbox, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overafter_stbox_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR << (
  LEFTARG = stbox, RIGHTARG = tnpoint,
  PROCEDURE = temporal_left,
  COMMUTATOR = '>>',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR &< (
  LEFTARG = stbox, RIGHTARG = tnpoint,
  PROCEDURE = temporal_overleft,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR >> (
  LEFTARG = stbox, RIGHTARG = tnpoint,
  PROCEDURE = temporal_right,
  COMMUTATOR = '<<',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR &> (
  LEFTARG = stbox, RIGHTARG = tnpoint,
  PROCEDURE = temporal_overright,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR <<| (
  LEFTARG = stbox, RIGHTARG = tnpoint,
  PROCEDURE = temporal_below,
  COMMUTATOR = '|>>',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR &<| (
  LEFTARG = stbox, RIGHTARG = tnpoint,
  PROCEDURE = temporal_overbelow,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR |>> (
  LEFTARG = stbox, RIGHTARG = tnpoint,
  PROCEDURE = temporal_above,
  COMMUTATOR = '<<|',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR |&> (
  LEFTARG = stbox, RIGHTARG = tnpoint,
  PROCEDURE = temporal_overabove,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR <<# (
  LEFTARG = stbox, RIGHTARG = tnpoint,
  PROCEDURE = temporal_before,
  COMMUTATOR = '#>>',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR &<# (
  LEFTARG = stbox, RIGHTARG = tnpoint,
  PROCEDURE = temporal_overbefore,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR #>> (
  LEFTARG = stbox, RIGHTARG = tnpoint,
  PROCEDURE = temporal_after,
  COMMUTATOR = '<<#',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR #&> (
  LEFTARG = stbox, RIGHTARG = tnpoint,
  PROCEDURE = temporal_overafter,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);

/*****************************************************************************
 * npoint
 *****************************************************************************/

CREATE FUNCTION temporal_left(npoint, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'left_npoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overleft(npoint, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overleft_npoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_right(npoint, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'right_npoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overright(npoint, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overright_npoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_below(npoint, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'below_npoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overbelow(npoint, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overbelow_npoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_above(npoint, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'above_npoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overabove(npoint, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overabove_npoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR << (
  LEFTARG = npoint, RIGHTARG = tnpoint,
  PROCEDURE = temporal_left,
  COMMUTATOR = '>>',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR &< (
  LEFTARG = npoint, RIGHTARG = tnpoint,
  PROCEDURE = temporal_overleft,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR >> (
  LEFTARG = npoint, RIGHTARG = tnpoint,
  PROCEDURE = temporal_right,
  COMMUTATOR = '<<',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR &> (
  LEFTARG = npoint, RIGHTARG = tnpoint,
  PROCEDURE = temporal_overright,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR <<| (
  LEFTARG = npoint, RIGHTARG = tnpoint,
  PROCEDURE = temporal_below,
  COMMUTATOR = '|>>',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR &<| (
  LEFTARG = npoint, RIGHTARG = tnpoint,
  PROCEDURE = temporal_overbelow,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR |>> (
  LEFTARG = npoint, RIGHTARG = tnpoint,
  PROCEDURE = temporal_above,
  COMMUTATOR = '<<|',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR |&> (
  LEFTARG = npoint, RIGHTARG = tnpoint,
  PROCEDURE = temporal_overabove,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);

/*****************************************************************************
 * tnpoint
 *****************************************************************************/

/* tnpoint op geometry */

CREATE FUNCTION temporal_left(tnpoint, geometry)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'left_tnpoint_geom'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overleft(tnpoint, geometry)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overleft_tnpoint_geom'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_right(tnpoint, geometry)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'right_tnpoint_geom'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overright(tnpoint, geometry)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overright_tnpoint_geom'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_below(tnpoint, geometry)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'below_tnpoint_geom'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overbelow(tnpoint, geometry)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overbelow_tnpoint_geom'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_above(tnpoint, geometry)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'above_tnpoint_geom'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overabove(tnpoint, geometry)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overabove_tnpoint_geom'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR << (
  LEFTARG = tnpoint, RIGHTARG = geometry,
  PROCEDURE = temporal_left,
  COMMUTATOR = '>>',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR &< (
  LEFTARG = tnpoint, RIGHTARG = geometry,
  PROCEDURE = temporal_overleft,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR >> (
  LEFTARG = tnpoint, RIGHTARG = geometry,
  PROCEDURE = temporal_right,
  COMMUTATOR = '<<',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR &> (
  LEFTARG = tnpoint, RIGHTARG = geometry,
  PROCEDURE = temporal_overright,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR <<| (
  LEFTARG = tnpoint, RIGHTARG = geometry,
  PROCEDURE = temporal_below,
  COMMUTATOR = '|>>',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR &<| (
  LEFTARG = tnpoint, RIGHTARG = geometry,
  PROCEDURE = temporal_overbelow,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR |>> (
  LEFTARG = tnpoint, RIGHTARG = geometry,
  PROCEDURE = temporal_above,
  COMMUTATOR = '<<|',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR |&> (
  LEFTARG = tnpoint, RIGHTARG = geometry,
  PROCEDURE = temporal_overabove,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);

/*****************************************************************************/

/* tnpoint op stbox */

CREATE FUNCTION temporal_left(tnpoint, stbox)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'left_tnpoint_stbox'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overleft(tnpoint, stbox)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overleft_tnpoint_stbox'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_right(tnpoint, stbox)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'right_tnpoint_stbox'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overright(tnpoint, stbox)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overright_tnpoint_stbox'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_below(tnpoint, stbox)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'below_tnpoint_stbox'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overbelow(tnpoint, stbox)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overbelow_tnpoint_stbox'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_above(tnpoint, stbox)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'above_tnpoint_stbox'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overabove(tnpoint, stbox)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overabove_tnpoint_stbox'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_before(tnpoint, stbox)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'before_tnpoint_stbox'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overbefore(tnpoint, stbox)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overbefore_tnpoint_stbox'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_after(tnpoint, stbox)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'after_tnpoint_stbox'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overafter(tnpoint, stbox)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overafter_tnpoint_stbox'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR << (
  LEFTARG = tnpoint, RIGHTARG = stbox,
  PROCEDURE = temporal_left,
  COMMUTATOR = '>>',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR &< (
  LEFTARG = tnpoint, RIGHTARG = stbox,
  PROCEDURE = temporal_overleft,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR >> (
  LEFTARG = tnpoint, RIGHTARG = stbox,
  PROCEDURE = temporal_right,
  COMMUTATOR = '<<',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR &> (
  LEFTARG = tnpoint, RIGHTARG = stbox,
  PROCEDURE = temporal_overright,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR <<| (
  LEFTARG = tnpoint, RIGHTARG = stbox,
  PROCEDURE = temporal_below,
  COMMUTATOR = '|>>',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR &<| (
  LEFTARG = tnpoint, RIGHTARG = stbox,
  PROCEDURE = temporal_overbelow,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR |>> (
  LEFTARG = tnpoint, RIGHTARG = stbox,
  PROCEDURE = temporal_above,
  COMMUTATOR = '<<|',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR |&> (
  LEFTARG = tnpoint, RIGHTARG = stbox,
  PROCEDURE = temporal_overabove,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR <<# (
  LEFTARG = tnpoint, RIGHTARG = stbox,
  PROCEDURE = temporal_before,
  COMMUTATOR = '#>>',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR &<# (
  LEFTARG = tnpoint, RIGHTARG = stbox,
  PROCEDURE = temporal_overbefore,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR #>> (
  LEFTARG = tnpoint, RIGHTARG = stbox,
  PROCEDURE = temporal_after,
  COMMUTATOR = '<<#',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR #&> (
  LEFTARG = tnpoint, RIGHTARG = stbox,
  PROCEDURE = temporal_overafter,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);

/*****************************************************************************/

/* tnpoint op npoint */

CREATE FUNCTION temporal_left(tnpoint, npoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'left_tnpoint_npoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overleft(tnpoint, npoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overleft_tnpoint_npoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_right(tnpoint, npoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'right_tnpoint_npoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overright(tnpoint, npoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overright_tnpoint_npoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_below(tnpoint, npoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'below_tnpoint_npoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overbelow(tnpoint, npoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overbelow_tnpoint_npoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_above(tnpoint, npoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'above_tnpoint_npoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overabove(tnpoint, npoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overabove_tnpoint_npoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR << (
  LEFTARG = tnpoint, RIGHTARG = npoint,
  PROCEDURE = temporal_left,
  COMMUTATOR = '>>',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR &< (
  LEFTARG = tnpoint, RIGHTARG = npoint,
  PROCEDURE = temporal_overleft,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR >> (
  LEFTARG = tnpoint, RIGHTARG = npoint,
  PROCEDURE = temporal_right,
  COMMUTATOR = '<<',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR &> (
  LEFTARG = tnpoint, RIGHTARG = npoint,
  PROCEDURE = temporal_overright,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR <<| (
  LEFTARG = tnpoint, RIGHTARG = npoint,
  PROCEDURE = temporal_below,
  COMMUTATOR = '|>>',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR &<| (
  LEFTARG = tnpoint, RIGHTARG = npoint,
  PROCEDURE = temporal_overbelow,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR |>> (
  LEFTARG = tnpoint, RIGHTARG = npoint,
  PROCEDURE = temporal_above,
  COMMUTATOR = '<<|',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR |&> (
  LEFTARG = tnpoint, RIGHTARG = npoint,
  PROCEDURE = temporal_overabove,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);

/*****************************************************************************/

/* tnpoint op tnpoint */

CREATE FUNCTION temporal_left(tnpoint, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'left_tnpoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overleft(tnpoint, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overleft_tnpoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_right(tnpoint, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'right_tnpoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overright(tnpoint, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overright_tnpoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_below(tnpoint, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'below_tnpoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overbelow(tnpoint, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overbelow_tnpoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_above(tnpoint, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'above_tnpoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overabove(tnpoint, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overabove_tnpoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_before(tnpoint, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'before_tnpoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overbefore(tnpoint, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overbefore_tnpoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_after(tnpoint, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'after_tnpoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
CREATE FUNCTION temporal_overafter(tnpoint, tnpoint)
  RETURNS boolean
  AS 'MODULE_PATHNAME', 'overafter_tnpoint_tnpoint'
  LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OPERATOR << (
  LEFTARG = tnpoint, RIGHTARG = tnpoint,
  PROCEDURE = temporal_left,
  COMMUTATOR = '>>',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR &< (
  LEFTARG = tnpoint, RIGHTARG = tnpoint,
  PROCEDURE = temporal_overleft,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR >> (
  LEFTARG = tnpoint, RIGHTARG = tnpoint,
  PROCEDURE = temporal_right,
  COMMUTATOR = '<<',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR &> (
  LEFTARG = tnpoint, RIGHTARG = tnpoint,
  PROCEDURE = temporal_overright,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR <<| (
  LEFTARG = tnpoint, RIGHTARG = tnpoint,
  PROCEDURE = temporal_below,
  COMMUTATOR = '|>>',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR &<| (
  LEFTARG = tnpoint, RIGHTARG = tnpoint,
  PROCEDURE = temporal_overbelow,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR |>> (
  LEFTARG = tnpoint, RIGHTARG = tnpoint,
  PROCEDURE = temporal_above,
  COMMUTATOR = '<<|',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR |&> (
  LEFTARG = tnpoint, RIGHTARG = tnpoint,
  PROCEDURE = temporal_overabove,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR <<# (
  LEFTARG = tnpoint, RIGHTARG = tnpoint,
  PROCEDURE = temporal_before,
  COMMUTATOR = '#>>',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR &<# (
  LEFTARG = tnpoint, RIGHTARG = tnpoint,
  PROCEDURE = temporal_overbefore,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR #>> (
  LEFTARG = tnpoint, RIGHTARG = tnpoint,
  PROCEDURE = temporal_after,
  COMMUTATOR = '<<#',
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);
CREATE OPERATOR #&> (
  LEFTARG = tnpoint, RIGHTARG = tnpoint,
  PROCEDURE = temporal_overafter,
  RESTRICT = tnpoint_position_sel, JOIN = tnpoint_position_joinsel
);

/*****************************************************************************/
