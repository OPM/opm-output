# -*- mode: cmake; tab-width: 2; indent-tabs-mode: t; truncate-lines: t; compile-command: "cmake -Wdev" -*-
# vim: set filetype=cmake autoindent tabstop=2 shiftwidth=2 noexpandtab softtabstop=2 nowrap:

list( APPEND MAIN_SOURCE_FILES
    opm/output/Output.cpp
    )

list (APPEND PUBLIC_HEADER_FILES
    opm/output/Output.hpp
    )
