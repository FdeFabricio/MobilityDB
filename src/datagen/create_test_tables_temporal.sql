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

/*
 * create_test_tables_temporal.sql
 * Function generating a set of test tables for some PostgreSQL data types 
 * and for temporal data types.
 *
 * These functions use the random generator for these types that are in the
 * file random_temporal.sql. Refer to that file for the meaning of the 
 * parameters used in the function calls of this file.
 */
 
DROP FUNCTION IF EXISTS create_test_tables_temporal();
CREATE OR REPLACE FUNCTION create_test_tables_temporal(size int DEFAULT 100)
RETURNS text AS $$
DECLARE
  perc int;
BEGIN
perc := size * 0.01;
IF perc < 1 THEN perc := 1; END IF;

-------------------------------------------------------------------------------
-- Basic types
-------------------------------------------------------------------------------

DROP TABLE IF EXISTS tbl_bool;
CREATE TABLE tbl_bool AS
/* Add perc NULL values */
SELECT k, NULL AS b
FROM generate_series(1, perc) AS k UNION
SELECT k, random_bool()
FROM generate_series(perc+1, size) AS k;

DROP TABLE IF EXISTS tbl_int;
CREATE TABLE tbl_int AS
/* Add perc NULL values */
SELECT k, NULL AS i
FROM generate_series(1, perc) AS k UNION
SELECT k, random_int(0, 100)
FROM generate_series(perc+1, size) AS k;

DROP TABLE IF EXISTS tbl_float;
CREATE TABLE tbl_float AS
/* Add perc NULL values */
SELECT k, NULL AS f
FROM generate_series(1, perc) AS k UNION
SELECT k, random_float(0, 100)
FROM generate_series(perc+1, size) AS k;

DROP TABLE IF EXISTS tbl_text;
CREATE TABLE tbl_text AS
/* Add perc NULL values */
SELECT k, NULL AS t
FROM generate_series(1, perc) AS k UNION
SELECT k, random_text(10)
FROM generate_series(perc+1, size) AS k;

DROP TABLE IF EXISTS tbl_tbox;
CREATE TABLE tbl_tbox AS
/* Add perc NULL values */
SELECT k, NULL AS b
FROM generate_series(1, perc) AS k UNION
SELECT k, random_tbox(0, 100, '2001-01-01', '2001-12-31', 10, 10)
FROM generate_series(perc+1, size) AS k;

DROP TABLE IF EXISTS tbl_interval;
CREATE TABLE tbl_interval AS
/* Add perc NULL values */
SELECT k, NULL AS i
FROM generate_series(1, perc) AS k UNION
SELECT k, random_minutes(1, 100)
FROM generate_series(perc+1, size) AS k;

DROP TABLE IF EXISTS tbl_timestamptz;
CREATE TABLE tbl_timestamptz AS
/* Add perc NULL values */
SELECT k, NULL AS t
FROM generate_series(1, perc) AS k UNION
SELECT k, random_timestamptz('2001-01-01', '2001-12-31')
FROM generate_series(perc+1, size) AS k;

DROP TABLE IF EXISTS tbl_intrange;
CREATE TABLE tbl_intrange AS
/* Add perc NULL values */
SELECT k, NULL AS i
FROM generate_series(1, perc) AS k UNION
SELECT k, random_intrange(0, 100, 10)
FROM generate_series(perc+1, size) AS k;

DROP TABLE IF EXISTS tbl_floatrange;
CREATE TABLE tbl_floatrange AS
/* Add perc NULL values */
SELECT k, NULL AS f
FROM generate_series(1, perc) AS k UNION
SELECT k, random_floatrange(0, 100, 10)
FROM generate_series(perc+1, size) AS k;

DROP TABLE IF EXISTS tbl_tstzrange;
CREATE TABLE tbl_tstzrange AS
/* Add perc NULL values */
SELECT k, NULL AS r
FROM generate_series(1, perc) AS k UNION
SELECT k, random_tstzrange('2001-01-01', '2001-12-31', 10)
FROM generate_series(perc+1, size) AS k;

DROP TABLE IF EXISTS tbl_tstzrange_array;
CREATE TABLE tbl_tstzrange_array AS
/* Add perc NULL values */
SELECT k, NULL AS ra
FROM generate_series(1, perc) AS k UNION
SELECT k, random_tstzrange_array('2001-01-01', '2001-12-31', 10, 5, 10)
FROM generate_series(perc+1, size) AS k;

-------------------------------------------------------------------------------
-- Time types
-------------------------------------------------------------------------------

DROP TABLE IF EXISTS tbl_timestampset;
CREATE TABLE tbl_timestampset AS
/* Add perc NULL values */
SELECT k, NULL AS ts
FROM generate_series(1, perc) AS k UNION
SELECT k, random_timestampset('2001-01-01', '2001-12-31', 10, 5, 10)
FROM generate_series(perc+1, size) AS k;

DROP TABLE IF EXISTS tbl_period;
CREATE TABLE tbl_period AS
/* Add perc NULL values */
SELECT k, NULL AS p
FROM generate_series(1, perc) AS k UNION
SELECT k, random_period('2001-01-01', '2001-12-31', 10)
FROM generate_series(perc+1, size) AS k;

DROP TABLE IF EXISTS tbl_periodset;
CREATE TABLE tbl_periodset AS
/* Add perc NULL values */
SELECT k, NULL AS ps
FROM generate_series(1, perc) AS k UNION
SELECT k, random_periodset('2001-01-01', '2001-12-31', 10, 5, 10)
FROM generate_series(perc+1, size) AS k;

------------------------------------------------------------------------------
-- Temporal Types
------------------------------------------------------------------------------

DROP TABLE IF EXISTS tbl_tbool_inst;
CREATE TABLE tbl_tbool_inst AS
/* Add perc NULL values */
SELECT k, NULL AS inst
FROM generate_series(1, perc) AS k UNION
SELECT k, random_tbool_inst('2001-01-01', '2001-12-31')
FROM generate_series(perc+1, size) k;
/* Add perc duplicates */
UPDATE tbl_tbool_inst t1
SET inst = (SELECT inst FROM tbl_tbool_inst t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 2*perc, 3*perc) i);
/* Add perc tuples with the same timestamp */
UPDATE tbl_tbool_inst t1
SET inst = (SELECT tbool_inst(random_bool(), getTimestamp(inst))
  FROM tbl_tbool_inst t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 4*perc, 5*perc) i);

DROP TABLE IF EXISTS tbl_tint_inst;
CREATE TABLE tbl_tint_inst AS
/* Add perc NULL values */
SELECT k, NULL AS inst
FROM generate_series(1, perc) AS k UNION
SELECT k, random_tint_inst(0, 100, '2001-01-01', '2001-12-31')
FROM generate_series(perc+1, size) k;
/* Add perc duplicates */
UPDATE tbl_tint_inst t1
SET inst = (SELECT inst FROM tbl_tint_inst t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 2*perc, 3*perc) i);
/* Add perc tuples with the same timestamp */
UPDATE tbl_tint_inst t1
SET inst = (SELECT tint_inst(random_int(0, 100), getTimestamp(inst))
  FROM tbl_tint_inst t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 4*perc, 5*perc) i);

DROP TABLE IF EXISTS tbl_tfloat_inst;
CREATE TABLE tbl_tfloat_inst AS
/* Add perc NULL values */
SELECT k, NULL AS inst
FROM generate_series(1, perc) AS k UNION
SELECT k, random_tfloat_inst(0, 100, '2001-01-01', '2001-12-31')
FROM generate_series(perc+1, size) k;
/* Add perc duplicates */
UPDATE tbl_tfloat_inst t1
SET inst = (SELECT inst FROM tbl_tfloat_inst t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 2*perc, 3*perc) i);
/* Add perc tuples with the same timestamp */
UPDATE tbl_tfloat_inst t1
SET inst = (SELECT tfloat_inst(random_float(1, 100), getTimestamp(inst))
  FROM tbl_tfloat_inst t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 4*perc, 5*perc) i);

DROP TABLE IF EXISTS tbl_ttext_inst;
CREATE TABLE tbl_ttext_inst AS
/* Add perc NULL values */
SELECT k, NULL AS inst
FROM generate_series(1, perc) AS k UNION
SELECT k, random_ttext_inst('2001-01-01', '2001-12-31', 10)
FROM generate_series(perc+1, size) k;
/* Add perc duplicates */
UPDATE tbl_ttext_inst t1
SET inst = (SELECT inst FROM tbl_ttext_inst t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 2*perc, 3*perc) i);
/* Add perc tuples with the same timestamp */
UPDATE tbl_ttext_inst t1
SET inst = (SELECT ttext_inst(random_text(10), getTimestamp(inst))
  FROM tbl_ttext_inst t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 4*perc, 5*perc) i);

-------------------------------------------------------------------------------

DROP TABLE IF EXISTS tbl_tbool_instset;
CREATE TABLE tbl_tbool_instset AS
/* Add perc NULL values */
SELECT k, NULL AS ti
FROM generate_series(1, perc) AS k UNION
SELECT k, random_tbool_instset('2001-01-01', '2001-12-31', 10, 5, 10) AS ti
FROM generate_series(perc+1, size) k;
/* Add perc duplicates */
UPDATE tbl_tbool_instset t1
SET ti = (SELECT ti FROM tbl_tbool_instset t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 2*perc, 3*perc) i);
/* Add perc tuples with the same timestamp */
UPDATE tbl_tbool_instset t1
SET ti = (SELECT ~ ti FROM tbl_tbool_instset t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 4*perc, 5*perc) i);
/* Add perc tuples that meet */
UPDATE tbl_tbool_instset t1
SET ti = (SELECT shift(ti, endTimestamp(ti)-startTimestamp(ti))
  FROM tbl_tbool_instset t2 WHERE t2.k = t1.k+perc)
WHERE t1.k in (SELECT i FROM generate_series(1 + 6*perc, 7*perc) i);
/* Add perc tuples that overlap */
UPDATE tbl_tbool_instset t1
SET ti = (SELECT shift(ti, date_trunc('minute',(endTimestamp(ti)-startTimestamp(ti))/2))
  FROM tbl_tbool_instset t2 WHERE t2.k = t1.k+2)
WHERE t1.k in (SELECT i FROM generate_series(1 + 8*perc, 9*perc) i);

DROP TABLE IF EXISTS tbl_tint_instset;
CREATE TABLE tbl_tint_instset AS
/* Add perc NULL values */
SELECT k, NULL AS ti
FROM generate_series(1, perc) AS k UNION
SELECT k, random_tint_instset(1, 100, '2001-01-01', '2001-12-31', 10, 10, 5, 10) AS ti
FROM generate_series(perc+1, size) k;
/* Add perc duplicates */
UPDATE tbl_tint_instset t1
SET ti = (SELECT ti FROM tbl_tint_instset t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 2*perc, 3*perc) i);
/* Add perc tuples with the same timestamp */
UPDATE tbl_tint_instset t1
SET ti = (SELECT ti + random_int(1, 2) FROM tbl_tint_instset t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 4*perc, 5*perc) i);
/* Add perc tuples that meet */
UPDATE tbl_tint_instset t1
SET ti = (SELECT shift(ti, endTimestamp(ti)-startTimestamp(ti))
  FROM tbl_tint_instset t2 WHERE t2.k = t1.k+perc)
WHERE t1.k in (SELECT i FROM generate_series(1 + 6*perc, 7*perc) i);
/* Add perc tuples that overlap */
UPDATE tbl_tint_instset t1
SET ti = (SELECT shift(ti, date_trunc('minute',(endTimestamp(ti)-startTimestamp(ti))/2))
  FROM tbl_tint_instset t2 WHERE t2.k = t1.k+2)
WHERE t1.k in (SELECT i FROM generate_series(1 + 8*perc, 9*perc) i);

DROP TABLE IF EXISTS tbl_tfloat_instset;
CREATE TABLE tbl_tfloat_instset AS
/* Add perc NULL values */
SELECT k, NULL AS ti
FROM generate_series(1, perc) AS k UNION
SELECT k, random_tfloat_instset(1, 100, '2001-01-01', '2001-12-31', 10, 10, 5, 10) AS ti
FROM generate_series(perc+1, size) k;
/* Add perc duplicates */
UPDATE tbl_tfloat_instset t1
SET ti = (SELECT ti FROM tbl_tfloat_instset t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 2*perc, 3*perc) i);
/* Add perc tuples with the same timestamp */
UPDATE tbl_tfloat_instset t1
SET ti = (SELECT ti + random_int(1, 2) FROM tbl_tfloat_instset t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 4*perc, 5*perc) i);
/* Add perc tuples that meet */
UPDATE tbl_tfloat_instset t1
SET ti = (SELECT shift(ti, endTimestamp(ti)-startTimestamp(ti))
  FROM tbl_tfloat_instset t2 WHERE t2.k = t1.k+perc)
WHERE t1.k in (SELECT i FROM generate_series(1 + 6*perc, 7*perc) i);
/* Add perc tuples that overlap */
UPDATE tbl_tfloat_instset t1
SET ti = (SELECT shift(ti, date_trunc('minute',(endTimestamp(ti)-startTimestamp(ti))/2))
  FROM tbl_tfloat_instset t2 WHERE t2.k = t1.k+2)
WHERE t1.k in (SELECT i FROM generate_series(1 + 8*perc, 9*perc) i);

DROP TABLE IF EXISTS tbl_ttext_instset;
CREATE TABLE tbl_ttext_instset AS
/* Add perc NULL values */
SELECT k, NULL AS ti
FROM generate_series(1, perc) AS k UNION
SELECT k, random_ttext_instset('2001-01-01', '2001-12-31', 10, 10, 5, 10) AS ti
FROM generate_series(perc+1, size) k;
/* Add perc duplicates */
UPDATE tbl_ttext_instset t1
SET ti = (SELECT ti FROM tbl_ttext_instset t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 2*perc, 3*perc) i);
/* Add perc tuples with the same timestamp */
UPDATE tbl_ttext_instset t1
SET ti = (SELECT ti || text 'A' FROM tbl_ttext_instset t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 4*perc, 5*perc) i);
/* Add perc tuples that meet */
UPDATE tbl_ttext_instset t1
SET ti = (SELECT shift(ti, endTimestamp(ti)-startTimestamp(ti))
  FROM tbl_ttext_instset t2 WHERE t2.k = t1.k+perc)
WHERE t1.k in (SELECT i FROM generate_series(1 + 6*perc, 7*perc) i);
/* Add perc tuples that overlap */
UPDATE tbl_ttext_instset t1
SET ti = (SELECT shift(ti, date_trunc('minute',(endTimestamp(ti)-startTimestamp(ti))/2))
  FROM tbl_ttext_instset t2 WHERE t2.k = t1.k+2)
WHERE t1.k in (SELECT i FROM generate_series(1 + 8*perc, 9*perc) i);

-------------------------------------------------------------------------------

DROP TABLE IF EXISTS tbl_tbool_seq;
CREATE TABLE tbl_tbool_seq AS
/* Add perc NULL values */
SELECT k, NULL AS seq
FROM generate_series(1, perc) AS k UNION
SELECT k, random_tbool_seq('2001-01-01', '2001-12-31', 10, 5, 10) AS seq
FROM generate_series(perc+1, size) k;
/* Add perc duplicates */
UPDATE tbl_tbool_seq t1
SET seq = (SELECT seq FROM tbl_tbool_seq t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 2*perc, 3*perc) i);
/* Add perc tuples with the same timestamp */
UPDATE tbl_tbool_seq t1
SET seq = (SELECT ~ seq FROM tbl_tbool_seq t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 4*perc, 5*perc) i);
/* Add perc tuples that meet */
UPDATE tbl_tbool_seq t1
SET seq = (SELECT shift(seq, timespan(seq)) FROM tbl_tbool_seq t2 WHERE t2.k = t1.k+perc)
WHERE t1.k in (SELECT i FROM generate_series(1 + 6*perc, 7*perc) i);
/* Add perc tuples that overlap */
UPDATE tbl_tbool_seq t1
SET seq = (SELECT shift(seq, date_trunc('minute',timespan(seq)/2))
  FROM tbl_tbool_seq t2 WHERE t2.k = t1.k+perc)
WHERE t1.k in (SELECT i FROM generate_series(1 + 8*perc, 9*perc) i);

DROP TABLE IF EXISTS tbl_tint_seq;
CREATE TABLE tbl_tint_seq AS
/* Add perc NULL values */
SELECT k, NULL AS seq
FROM generate_series(1, perc) AS k UNION
SELECT k, random_tint_seq(1, 100, '2001-01-01', '2001-12-31', 10, 10, 5, 10) AS seq
FROM generate_series(perc+1, size) k;
/* Add perc duplicates */
UPDATE tbl_tint_seq t1
SET seq = (SELECT seq FROM tbl_tint_seq t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 2*perc, 3*perc) i);
/* Add perc tuples with the same timestamp */
UPDATE tbl_tint_seq t1
SET seq = (SELECT seq + random_int(1, 2) FROM tbl_tint_seq t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 4*perc, 5*perc) i);
/* Add perc tuples that meet */
UPDATE tbl_tint_seq t1
SET seq = (SELECT shift(seq, timespan(seq)) FROM tbl_tint_seq t2 WHERE t2.k = t1.k+perc)
WHERE t1.k in (SELECT i FROM generate_series(1 + 6*perc, 7*perc) i);
/* Add perc tuples that overlap */
UPDATE tbl_tint_seq t1
SET seq = (SELECT shift(seq, date_trunc('minute',timespan(seq)/2))
  FROM tbl_tint_seq t2 WHERE t2.k = t1.k+perc)
WHERE t1.k in (SELECT i FROM generate_series(1 + 8*perc, 9*perc) i);

DROP TABLE IF EXISTS tbl_tfloat_seq;
CREATE TABLE tbl_tfloat_seq AS
/* Add perc NULL values */
SELECT k, NULL AS seq
FROM generate_series(1, perc) AS k UNION
SELECT k, random_tfloat_seq(1, 100, '2001-01-01', '2001-12-31', 10, 10, 5, 10) AS seq
FROM generate_series(perc+1, size) k;
/* Add perc duplicates */
UPDATE tbl_tfloat_seq t1
SET seq = (SELECT seq FROM tbl_tfloat_seq t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 2*perc, 3*perc) i);
/* Add perc tuples with the same timestamp */
UPDATE tbl_tfloat_seq t1
SET seq = (SELECT seq + random_int(1, 2) FROM tbl_tfloat_seq t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 4*perc, 5*perc) i);
/* Add perc tuples that meet */
UPDATE tbl_tfloat_seq t1
SET seq = (SELECT shift(seq, timespan(seq)) FROM tbl_tfloat_seq t2 WHERE t2.k = t1.k+perc)
WHERE t1.k in (SELECT i FROM generate_series(1 + 6*perc, 7*perc) i);
/* Add perc tuples that overlap */
UPDATE tbl_tfloat_seq t1
SET seq = (SELECT shift(seq, date_trunc('minute',timespan(seq)/2))
  FROM tbl_tfloat_seq t2 WHERE t2.k = t1.k+perc)
WHERE t1.k in (SELECT i FROM generate_series(1 + 8*perc, 9*perc) i);

DROP TABLE IF EXISTS tbl_ttext_seq;
CREATE TABLE tbl_ttext_seq AS
/* Add perc NULL values */
SELECT k, NULL AS seq
FROM generate_series(1, perc) AS k UNION
SELECT k, random_ttext_seq('2001-01-01', '2001-12-31', 10, 10, 5, 10) AS seq
FROM generate_series(perc+1, size) k;
/* Add perc duplicates */
UPDATE tbl_ttext_seq t1
SET seq = (SELECT seq FROM tbl_ttext_seq t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 2*perc, 3*perc) i);
/* Add perc tuples with the same timestamp */
UPDATE tbl_ttext_seq t1
SET seq = (SELECT seq || text 'A' FROM tbl_ttext_seq t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 4*perc, 5*perc) i);
/* Add perc tuples that meet */
UPDATE tbl_ttext_seq t1
SET seq = (SELECT shift(seq, timespan(seq)) FROM tbl_ttext_seq t2 WHERE t2.k = t1.k+perc)
WHERE t1.k in (SELECT i FROM generate_series(1 + 6*perc, 7*perc) i);
/* Add perc tuples that overlap */
UPDATE tbl_ttext_seq t1
SET seq = (SELECT shift(seq, date_trunc('minute',timespan(seq)/2))
  FROM tbl_ttext_seq t2 WHERE t2.k = t1.k+perc)
WHERE t1.k in (SELECT i FROM generate_series(1 + 8*perc, 9*perc) i);

-------------------------------------------------------------------------------

DROP TABLE IF EXISTS tbl_tbool_seqset;
CREATE TABLE tbl_tbool_seqset AS
/* Add perc NULL values */
SELECT k, NULL AS ts
FROM generate_series(1, perc) AS k UNION
SELECT k, random_tbool_seqset('2001-01-01', '2001-12-31', 10, 5, 10, 5, 10) AS ts
FROM generate_series(perc+1, size) AS k;
/* Add perc duplicates */
UPDATE tbl_tbool_seqset t1
SET ts = (SELECT ts FROM tbl_tbool_seqset t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 2*perc, 3*perc) i);
/* Add perc tuples with the same timestamp */
UPDATE tbl_tbool_seqset t1
SET ts = (SELECT ~ ts FROM tbl_tbool_seqset t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 4*perc, 5*perc) i);
/* Add perc tuples that meet */
UPDATE tbl_tbool_seqset t1
SET ts = (SELECT shift(ts, timespan(ts)) FROM tbl_tbool_seqset t2 WHERE t2.k = t1.k+perc)
WHERE t1.k in (SELECT i FROM generate_series(1 + 6*perc, 7*perc) i);
/* Add perc tuples that overlap */
UPDATE tbl_tbool_seqset t1
SET ts = (SELECT shift(ts, date_trunc('minute', timespan(ts)/2))
  FROM tbl_tbool_seqset t2 WHERE t2.k = t1.k+perc)
WHERE t1.k in (SELECT i FROM generate_series(1 + 8*perc, 9*perc) i);

DROP TABLE IF EXISTS tbl_tint_seqset;
CREATE TABLE tbl_tint_seqset AS
/* Add perc NULL values */
SELECT k, NULL AS ts
FROM generate_series(1, perc) AS k UNION
SELECT k, random_tint_seqset(1, 100, '2001-01-01', '2001-12-31', 10, 10, 5, 10, 5, 10) AS ts
FROM generate_series(perc+1, size) AS k;
/* Add perc duplicates */
UPDATE tbl_tint_seqset t1
SET ts = (SELECT ts FROM tbl_tint_seqset t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 2*perc, 3*perc) i);
/* Add perc tuples with the same timestamp */
UPDATE tbl_tint_seqset t1
SET ts = (SELECT ts + random_int(1, 2) FROM tbl_tint_seqset t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 4*perc, 5*perc) i);
/* Add perc tuples that meet */
UPDATE tbl_tint_seqset t1
SET ts = (SELECT shift(ts, timespan(ts)) FROM tbl_tint_seqset t2 WHERE t2.k = t1.k+perc)
WHERE t1.k in (SELECT i FROM generate_series(1 + 6*perc, 7*perc) i);
/* Add perc tuples that overlap */
UPDATE tbl_tint_seqset t1
SET ts = (SELECT shift(ts, date_trunc('minute', timespan(ts)/2))
  FROM tbl_tint_seqset t2 WHERE t2.k = t1.k+perc)
WHERE t1.k in (SELECT i FROM generate_series(1 + 8*perc, 9*perc) i);

DROP TABLE IF EXISTS tbl_tfloat_seqset;
CREATE TABLE tbl_tfloat_seqset AS
/* Add perc NULL values */
SELECT k, NULL AS ts
FROM generate_series(1, perc) AS k UNION
SELECT k, random_tfloat_seqset(1, 100, '2001-01-01', '2001-12-31', 10, 10, 5, 10, 5, 10) AS ts
FROM generate_series(perc+1, size) AS k;
/* Add perc duplicates */
UPDATE tbl_tfloat_seqset t1
SET ts = (SELECT ts FROM tbl_tfloat_seqset t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 2*perc, 3*perc) i);
/* Add perc tuples with the same timestamp */
UPDATE tbl_tfloat_seqset t1
SET ts = (SELECT ts + random_int(1, 2) FROM tbl_tfloat_seqset t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 4*perc, 5*perc) i);
/* Add perc tuples that meet */
UPDATE tbl_tfloat_seqset t1
SET ts = (SELECT shift(ts, timespan(ts)) FROM tbl_tfloat_seqset t2 WHERE t2.k = t1.k+perc)
WHERE t1.k in (SELECT i FROM generate_series(1 + 6*perc, 7*perc) i);
/* Add perc tuples that overlap */
UPDATE tbl_tfloat_seqset t1
SET ts = (SELECT shift(ts, date_trunc('minute', timespan(ts)/2))
  FROM tbl_tfloat_seqset t2 WHERE t2.k = t1.k+perc)
WHERE t1.k in (SELECT i FROM generate_series(1 + 8*perc, 9*perc) i);

DROP TABLE IF EXISTS tbl_ttext_seqset;
CREATE TABLE tbl_ttext_seqset AS
/* Add perc NULL values */
SELECT k, NULL AS ts
FROM generate_series(1, perc) AS k UNION
SELECT k, random_ttext_seqset('2001-01-01', '2001-12-31', 10, 10, 5, 10, 5, 10) AS ts
FROM generate_series(perc+1, size) AS k;
/* Add perc duplicates */
UPDATE tbl_ttext_seqset t1
SET ts = (SELECT ts FROM tbl_ttext_seqset t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 2*perc, 3*perc) i);
/* Add perc tuples with the same timestamp */
UPDATE tbl_ttext_seqset t1
SET ts = (SELECT ts || text 'A' FROM tbl_ttext_seqset t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 4*perc, 5*perc) i);
/* Add perc tuples that meet */
UPDATE tbl_ttext_seqset t1
SET ts = (SELECT shift(ts, timespan(ts)) FROM tbl_ttext_seqset t2 WHERE t2.k = t1.k+perc)
WHERE t1.k in (SELECT i FROM generate_series(1 + 6*perc, 7*perc) i);
/* Add perc tuples that overlap */
UPDATE tbl_ttext_seqset t1
SET ts = (SELECT shift(ts, date_trunc('minute', timespan(ts)/2))
  FROM tbl_ttext_seqset t2 WHERE t2.k = t1.k+perc)
WHERE t1.k in (SELECT i FROM generate_series(1 + 8*perc, 9*perc) i);

-------------------------------------------------------------------------------

DROP TABLE IF EXISTS tbl_tbool;
CREATE TABLE tbl_tbool(k, temp) AS
(SELECT k, inst FROM tbl_tbool_inst order by k limit size / 4) UNION all
(SELECT k + size / 4, ti FROM tbl_tbool_instset order by k limit size / 4) UNION all
(SELECT k + size / 2, seq FROM tbl_tbool_seq order by k limit size / 4) UNION all
(SELECT k + size / 4 * 3, ts FROM tbl_tbool_seqset order by k limit size / 4);

DROP TABLE IF EXISTS tbl_tint;
CREATE TABLE tbl_tint(k, temp) AS
(SELECT k, inst FROM tbl_tint_inst order by k limit size / 4) UNION all
(SELECT k + size / 4, ti FROM tbl_tint_instset order by k limit size / 4) UNION all
(SELECT k + size / 2, seq FROM tbl_tint_seq order by k limit size / 4) UNION all
(SELECT k + size / 4 * 3, ts FROM tbl_tint_seqset order by k limit size / 4);

DROP TABLE IF EXISTS tbl_tfloat;
CREATE TABLE tbl_tfloat(k, temp) AS
(SELECT k, inst FROM tbl_tfloat_inst order by k limit size / 4) UNION all
(SELECT k + size / 4, ti FROM tbl_tfloat_instset order by k limit size / 4) UNION all
(SELECT k + size / 2, seq FROM tbl_tfloat_seq order by k limit size / 4) UNION all
(SELECT k + size / 4 * 3, ts FROM tbl_tfloat_seqset order by k limit size / 4);

DROP TABLE IF EXISTS tbl_ttext;
CREATE TABLE tbl_ttext(k, temp) AS
(SELECT k, inst FROM tbl_ttext_inst order by k limit size / 4) UNION all
(SELECT k + size / 4, ti FROM tbl_ttext_instset order by k limit size / 4) UNION all
(SELECT k + size / 2, seq FROM tbl_ttext_seq order by k limit size / 4) UNION all
(SELECT k + size / 4 * 3, ts FROM tbl_ttext_seqset order by k limit size / 4);

------------------------------------------------------------------------------
-- Temporal Float Types with Step Interpolation
------------------------------------------------------------------------------

DROP TABLE IF EXISTS tbl_tfloat_step_seq;
CREATE TABLE tbl_tfloat_step_seq AS
/* Add perc NULL values */
SELECT k, NULL AS seq
FROM generate_series(1, perc) AS k UNION
SELECT k, random_tfloat_seq(1, 100, '2001-01-01', '2001-12-31', 10, 10, 5, 10, linear:=false) AS seq
FROM generate_series(perc+1, size) k;
/* Add perc duplicates */
UPDATE tbl_tfloat_step_seq t1
SET seq = (SELECT seq FROM tbl_tfloat_step_seq t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 2*perc, 3*perc) i);
/* Add perc tuples with the same timestamp */
UPDATE tbl_tfloat_step_seq t1
SET seq = (SELECT seq + random_int(1, 2) FROM tbl_tfloat_step_seq t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 4*perc, 5*perc) i);
/* Add perc tuples that meet */
UPDATE tbl_tfloat_step_seq t1
SET seq = (SELECT shift(seq, timespan(seq)) FROM tbl_tfloat_step_seq t2 WHERE t2.k = t1.k+perc)
WHERE t1.k in (SELECT i FROM generate_series(1 + 6*perc, 7*perc) i);
/* Add perc tuples that overlap */
UPDATE tbl_tfloat_step_seq t1
SET seq = (SELECT shift(seq, date_trunc('minute',timespan(seq)/2))
  FROM tbl_tfloat_step_seq t2 WHERE t2.k = t1.k+perc)
WHERE t1.k in (SELECT i FROM generate_series(1 + 8*perc, 9*perc) i);

DROP TABLE IF EXISTS tbl_tfloat_step_seqset;
CREATE TABLE tbl_tfloat_step_seqset AS
/* Add perc NULL values */
SELECT k, NULL AS ts
FROM generate_series(1, perc) AS k UNION
SELECT k, random_tfloat_seqset(1, 100, '2001-01-01', '2001-12-31', 10, 10, 5, 10, 5, 10, linear:=false) AS ts
FROM generate_series(perc+1, size) AS k;
/* Add perc duplicates */
UPDATE tbl_tfloat_step_seqset t1
SET ts = (SELECT ts FROM tbl_tfloat_step_seqset t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 2*perc, 3*perc) i);
/* Add perc tuples with the same timestamp */
UPDATE tbl_tfloat_step_seqset t1
SET ts = (SELECT ts + random_int(1, 2) FROM tbl_tfloat_step_seqset t2 WHERE t2.k = t1.k+perc)
WHERE k in (SELECT i FROM generate_series(1 + 4*perc, 5*perc) i);
/* Add perc tuples that meet */
UPDATE tbl_tfloat_step_seqset t1
SET ts = (SELECT shift(ts, timespan(ts)) FROM tbl_tfloat_step_seqset t2 WHERE t2.k = t1.k+perc)
WHERE t1.k in (SELECT i FROM generate_series(1 + 6*perc, 7*perc) i);
/* Add perc tuples that overlap */
UPDATE tbl_tfloat_step_seqset t1
SET ts = (SELECT shift(ts, date_trunc('minute', timespan(ts)/2))
  FROM tbl_tfloat_step_seqset t2 WHERE t2.k = t1.k+perc)
WHERE t1.k in (SELECT i FROM generate_series(1 + 8*perc, 9*perc) i);

-------------------------------------------------------------------------------
RETURN 'The End';
END;
$$ LANGUAGE 'plpgsql';

-- SELECT create_test_tables_temporal(100);

