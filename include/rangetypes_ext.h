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
 * @file rangetypes_ext.h
 * Extended operators for range types.
 */

#ifndef __RANGETYPES_EXT_H__
#define __RANGETYPES_EXT_H__

#include <postgres.h>
#include <catalog/pg_type.h>
#include <utils/rangetypes.h>

#include "temporaltypes.h"

/*****************************************************************************/

extern const char *range_to_string(const RangeType *range);
extern Datum lower_datum(const RangeType *range);
extern Datum upper_datum(const RangeType *range);

#if MOBDB_PGSQL_VERSION < 130000
extern bool lower_inc(RangeType *range);
extern bool upper_inc(RangeType *range);
#else
extern bool lower_inc(const RangeType *range);
extern bool upper_inc(const RangeType *range);
#endif

extern void range_bounds(const RangeType *range, double *xmin, double *xmax);
extern RangeType *range_make(Datum from, Datum to, bool lower_inc,
  bool upper_inc, Oid basetypid);
extern RangeType **rangearr_normalize(RangeType **ranges, int count,
  int *newcount);

extern Datum intrange_canonical(PG_FUNCTION_ARGS);

extern Datum range_left_elem(PG_FUNCTION_ARGS);
extern Datum range_overleft_elem(PG_FUNCTION_ARGS);
extern Datum range_right_elem(PG_FUNCTION_ARGS);
extern Datum range_overright_elem(PG_FUNCTION_ARGS);
extern Datum range_adjacent_elem(PG_FUNCTION_ARGS);

extern Datum elem_left_range(PG_FUNCTION_ARGS);
extern Datum elem_overleft_range(PG_FUNCTION_ARGS);
extern Datum elem_right_range(PG_FUNCTION_ARGS);
extern Datum elem_overright_range(PG_FUNCTION_ARGS);
extern Datum elem_adjacent_range(PG_FUNCTION_ARGS);

/*****************************************************************************/

#endif
