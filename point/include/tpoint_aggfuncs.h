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
 * @file tpoint_aggfuncs.h
 * Aggregate functions for temporal points.
 */

#ifndef __TPOINT_AGGFUNCS_H__
#define __TPOINT_AGGFUNCS_H__

#include <postgres.h>
#include <fmgr.h>
#include <catalog/pg_type.h>

#include "temporal.h"
#include "skiplist.h"

/*****************************************************************************/

/**
 * Structure storing the SRID and the dimensionality of the temporal point
 * values for aggregation. Notice that for the moment we do not aggregate
 * temporal geographic points.
 */
struct GeoAggregateState
{
  int32_t srid;
  bool hasz;
};

extern void geoaggstate_check_t(const SkipList *state, const Temporal *t);

/*****************************************************************************/

extern Datum tpoint_extent_transfn(PG_FUNCTION_ARGS);
extern Datum tpoint_extent_combinefn(PG_FUNCTION_ARGS);

extern Datum tpoint_tcentroid_transfn(PG_FUNCTION_ARGS);
extern Datum tpoint_tcentroid_combinefn(PG_FUNCTION_ARGS);
extern Datum tpoint_tcentroid_finalfn(PG_FUNCTION_ARGS);

extern Temporal **tpoint_transform_tcentroid(const Temporal *temp, int *count);

/*****************************************************************************/

#endif
