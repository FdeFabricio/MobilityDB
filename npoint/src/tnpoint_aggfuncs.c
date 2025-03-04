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
 * @file tnpoint_aggfuncs.c
 * Aggregate functions for temporal network points.
 *
 * The only function currently provided is temporal centroid.
 */

#include "tnpoint_aggfuncs.h"

#include <assert.h>

#include "temporal_aggfuncs.h"
#include "tpoint.h"
#include "tpoint_spatialfuncs.h"
#include "tpoint_aggfuncs.h"
#include "tnpoint.h"

/*****************************************************************************/

PG_FUNCTION_INFO_V1(tnpoint_tcentroid_transfn);

PGDLLEXPORT Datum
tnpoint_tcentroid_transfn(PG_FUNCTION_ARGS)
{
  SkipList *state = PG_ARGISNULL(0) ? NULL : 
    (SkipList *) PG_GETARG_POINTER(0);
  if (PG_ARGISNULL(1))
  {
    if (state)
      PG_RETURN_POINTER(state);
    else
      PG_RETURN_NULL();
  }
  Temporal *temp = PG_GETARG_TEMPORAL(1);
  Temporal *temp1 = tnpoint_as_tgeompoint_internal(temp);

  geoaggstate_check_t(state, temp1);
  Datum (*func)(Datum, Datum) = MOBDB_FLAGS_GET_Z(temp1->flags) ?
    &datum_sum_double4 : &datum_sum_double3;

  int count;
  Temporal **temparr = tpoint_transform_tcentroid(temp1, &count);
  if (state)
  {
    ensure_same_temp_subtype_skiplist(state, temparr[0]->subtype, temparr[0]);
    skiplist_splice(fcinfo, state, (void **) temparr, count, func, false);
  }
  else
  {
    state = skiplist_make(fcinfo, (void **) temparr, count, TEMPORAL);
    struct GeoAggregateState extra =
    {
      .srid = tpoint_srid_internal(temp1),
      .hasz = MOBDB_FLAGS_GET_Z(temp1->flags) != 0
    };
    aggstate_set_extra(fcinfo, state, &extra, sizeof(struct GeoAggregateState));
  }

  pfree_array((void **) temparr, count);
  pfree(temp1);
  PG_FREE_IF_COPY(temp, 1);
  PG_RETURN_POINTER(state);
}

/*****************************************************************************/
