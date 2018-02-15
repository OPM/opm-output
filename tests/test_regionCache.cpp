/*
  Copyright 2016 Statoil ASA.

  This file is part of the Open Porous Media project (OPM).

  OPM is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  OPM is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with OPM.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "config.h"

#define BOOST_TEST_MODULE RegionCache
#include <boost/test/unit_test.hpp>

#include <stdexcept>

#include <opm/parser/eclipse/Deck/Deck.hpp>
#include <opm/parser/eclipse/EclipseState/EclipseState.hpp>
#include <opm/parser/eclipse/EclipseState/Schedule/Schedule.hpp>
#include <opm/output/eclipse/RegionCache.hpp>
#include <opm/parser/eclipse/Parser/ParseContext.hpp>
#include <opm/parser/eclipse/Parser/Parser.hpp>

#include <opm/output/eclipse/RegionCache.hpp>

using namespace Opm;

const char* path = "summary_deck.DATA";


BOOST_AUTO_TEST_CASE(create) {
    ParseContext parseContext;
    Parser parser;
    Deck deck( parser.parseFile( path, parseContext ));
    EclipseState es(deck , parseContext );
    const EclipseGrid& grid = es.getInputGrid();
    Schedule schedule( deck, grid, es.get3DProperties(), es.runspec().phases(), ParseContext() );
    out::RegionCache rc(es.get3DProperties() , grid, schedule);

    {
        const auto& empty = rc.completions( 4 );
        BOOST_CHECK_EQUAL( empty.size() , 0 );
    }

    {
        const auto& top_layer = rc.completions( 1 );
        BOOST_CHECK_EQUAL( top_layer.size() , 3 );
        {
            auto pair = top_layer[0];
            BOOST_CHECK_EQUAL( pair.first , "W_1");
            BOOST_CHECK_EQUAL( pair.second , grid.activeIndex( 0,0,0));
        }
    }
}
