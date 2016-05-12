# -*- mode: cmake; tab-width: 2; indent-tabs-mode: t; truncate-lines: t; compile-command: "cmake -Wdev" -*-
# vim: set filetype=cmake autoindent tabstop=2 shiftwidth=2 noexpandtab softtabstop=2 nowrap:

list( APPEND MAIN_SOURCE_FILES
        opm/output/eclipse/EclipseGridInspector.cpp
        opm/output/eclipse/EclipseReader.cpp
        opm/output/eclipse/EclipseWriter.cpp
        opm/output/eclipse/Summary.cpp
        opm/output/eclipse/writeECLData.cpp
        opm/output/vag/vag.cpp
        opm/output/vtk/writeVtkData.cpp
    )

list (APPEND PUBLIC_HEADER_FILES
        opm/output/OutputWriter.hpp
        opm/output/Wells.hpp
        opm/output/Cells.hpp
        opm/output/eclipse/CornerpointChopper.hpp
        opm/output/eclipse/EclipseGridInspector.hpp
        opm/output/eclipse/EclipseIOUtil.hpp
        opm/output/eclipse/EclipseReader.hpp
        opm/output/eclipse/EclipseUnits.hpp
        opm/output/eclipse/EclipseWriter.hpp
        opm/output/eclipse/Summary.hpp
        opm/output/eclipse/writeECLData.hpp
        opm/output/vag/vag.hpp
        opm/output/vtk/writeVtkData.hpp
    )

list (APPEND TEST_SOURCE_FILES
        tests/test_EclipseWriter.cpp
        tests/test_EclipseWriteRFTHandler.cpp
        tests/test_writenumwells.cpp
        tests/test_writeReadRestartFile.cpp
        tests/test_Wells.cpp
        tests/test_Summary.cpp
)

# originally generated with the command:
# find tests -name '*.xml' -a ! -wholename '*/not-unit/*' -printf '\t%p\n' | sort
list (APPEND TEST_DATA_FILES
        tests/testBlackoilState3.DATA
        tests/summary_deck.DATA
        tests/FIRST_SIM.DATA
        tests/testRFT.DATA
)
