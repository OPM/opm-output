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

#if HAVE_DYNAMIC_BOOST_TEST
#define BOOST_TEST_DYN_LINK
#endif

#define BOOST_TEST_MODULE Wells
#include <boost/test/unit_test.hpp>

#include <stdexcept>

#include <opm/output/data/Wells.hpp>

using namespace Opm;
using rt = data::Rates::opt;

BOOST_AUTO_TEST_CASE(has) {
    data::Rates rates;

    rates.set( rt::wat, 10 );
    BOOST_CHECK( rates.has( rt::wat ) );
    BOOST_CHECK( !rates.has( rt::gas ) );
    BOOST_CHECK( !rates.has( rt::oil ) );

    rates.set( rt::gas, 0 );
    BOOST_CHECK( rates.has( rt::gas ) );
    BOOST_CHECK( !rates.has( rt::oil ) );
}

BOOST_AUTO_TEST_CASE(set_and_get) {
    data::Rates rates;

    const double wat = 10;
    const double gas = 10;

    rates.set( rt::wat, wat );
    rates.set( rt::gas, gas );

    BOOST_CHECK_EQUAL( wat, rates.get( rt::wat ) );
    BOOST_CHECK_EQUAL( gas, rates.get( rt::gas ) );
}

BOOST_AUTO_TEST_CASE(get_wrong) {
    data::Rates rates;
    const double wat = 10;
    const double gas = 10;

    rates.set( rt::wat, wat );
    rates.set( rt::gas, gas );

    const double def = 1;

    BOOST_CHECK_EQUAL( def, rates.get( rt::oil, def ) );
    BOOST_CHECK_THROW( rates.get( rt::oil ), std::invalid_argument );
}



BOOST_AUTO_TEST_CASE(get_completions) {
    data::Rates r1, r2, rc1, rc2, rc3;
    r1.set( data::Rates::opt::wat, 5.67 );
    r1.set( data::Rates::opt::oil, 6.78 );
    r1.set( data::Rates::opt::gas, 7.89 );

    r2.set( data::Rates::opt::wat, 8.90 );
    r2.set( data::Rates::opt::oil, 9.01 );
    r2.set( data::Rates::opt::gas, 10.12 );

    rc1.set( data::Rates::opt::wat, 20.41 );
    rc1.set( data::Rates::opt::oil, 21.19 );
    rc1.set( data::Rates::opt::gas, 22.41 );

    rc2.set( data::Rates::opt::wat, 23.19 );
    rc2.set( data::Rates::opt::oil, 24.41 );
    rc2.set( data::Rates::opt::gas, 25.19 );

    rc3.set( data::Rates::opt::wat, 26.41 );
    rc3.set( data::Rates::opt::oil, 27.19 );
    rc3.set( data::Rates::opt::gas, 28.41 );

    data::Well w1, w2;
    w1.rates = r1;
    w1.bhp = 1.23;
    w1.temperature = 3.45;
    w1.control = 1;

    /*
     *  the completion keys (active indices) and well names correspond to the
     *  input deck. All other entries in the well structures are arbitrary.
     */
    w1.completions.push_back( { 88, rc1, 30.45, 123.45 } );
    w1.completions.push_back( { 288, rc2, 33.19, 67.89 } );

    w2.rates = r2;
    w2.bhp = 2.34;
    w2.temperature = 4.56;
    w2.control = 2;
    w2.completions.push_back( { 188, rc3, 36.22, 19.28 } );

    data::Wells wellRates;

    wellRates["OP_1"] = w1;
    wellRates["OP_2"] = w2;

    BOOST_CHECK_EQUAL( 0.0, wellRates.get("NO_SUCH_WELL" , data::Rates::opt::wat) );
    BOOST_CHECK_EQUAL( 5.67 , wellRates.get( "OP_1" , data::Rates::opt::wat));

    BOOST_CHECK_EQUAL( 0.0, wellRates.get("OP_2" , 10000 , data::Rates::opt::wat) );
    BOOST_CHECK_EQUAL( 26.41 , wellRates.get( "OP_2" , 188 , data::Rates::opt::wat));
}
