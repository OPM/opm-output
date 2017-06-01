# -*- mode: cmake; tab-width: 2; indent-tabs-mode: t; truncate-lines: t; compile-command: "cmake -Wdev" -*-
# vim: set filetype=cmake autoindent tabstop=2 shiftwidth=2 noexpandtab softtabstop=2 nowrap:

list( APPEND MAIN_SOURCE_FILES
        opm/test_util/summaryIntegrationTest.cpp
        opm/test_util/summaryRegressionTest.cpp
        opm/test_util/summaryComparator.cpp
        opm/test_util/EclFilesComparator.cpp
        opm/output/eclipse/EclipseGridInspector.cpp
        opm/output/eclipse/EclipseIO.cpp
        opm/output/eclipse/RestartIO.cpp
        opm/output/eclipse/Summary.cpp
        opm/output/eclipse/Tables.cpp
        opm/output/eclipse/RegionCache.cpp
        opm/output/data/Solution.cpp
    )

list (APPEND PUBLIC_HEADER_FILES
        opm/output/OutputWriter.hpp
        opm/output/data/Wells.hpp
        opm/output/data/Cells.hpp
        opm/test_util/summaryRegressionTest.hpp
        opm/test_util/summaryIntegrationTest.hpp
        opm/test_util/summaryComparator.hpp
        opm/output/eclipse/EclipseGridInspector.hpp
        opm/output/eclipse/EclipseIOUtil.hpp
        opm/output/eclipse/EclipseIO.hpp
        opm/output/eclipse/RestartIO.hpp
        opm/output/eclipse/RestartValue.hpp
        opm/output/eclipse/Summary.hpp
        opm/output/eclipse/Tables.hpp        
        opm/output/eclipse/RegionCache.hpp
        opm/output/data/Solution.hpp
        opm/test_util/EclFilesComparator.hpp
        opm/test_util/summaryRegressionTest.hpp
        opm/test_util/summaryComparator.hpp
    )

list (APPEND EXAMPLE_SOURCE_FILES
        test_util/compareECL.cpp
        test_util/compareSummary.cpp
    )

# programs listed here will not only be compiled, but also marked for
# installation
list (APPEND PROGRAM_SOURCE_FILES
        test_util/compareECL.cpp
        test_util/compareSummary.cpp
    )

list (APPEND TEST_SOURCE_FILES
        tests/test_compareSummary.cpp
        tests/test_EclFilesComparator.cpp
        tests/test_EclipseIO.cpp
        tests/test_Restart.cpp
        tests/test_RFT.cpp
        tests/test_Summary.cpp
        tests/test_Tables.cpp
        tests/test_Wells.cpp
        tests/test_writenumwells.cpp
        tests/test_Solution.cpp
        tests/test_regionCache.cpp
    )

# originally generated with the command:
# find tests -name '*.xml' -a ! -wholename '*/not-unit/*' -printf '\t%p\n' | sort
list (APPEND TEST_DATA_FILES
        tests/FIRST_SIM.DATA
        tests/summary_deck.DATA
        tests/testBlackoilState3.DATA
        tests/testRFT.DATA
        tests/table_deck.DATA
        tests/summary_deck_non_constant_porosity.DATA
    )
