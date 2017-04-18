#
# spec file for package opm-output
#

%define tag rc1

Name:           opm-output
Version:        2017.04
Release:        0
Summary:        Data output management module for OPM
License:        GPL-3.0
Group:          Development/Libraries/C and C++
Url:            http://www.opm-project.org/
Source0:        https://github.com/OPM/%{name}/archive/release/%{version}/%{tag}.tar.gz#/%{name}-%{version}.tar.gz
BuildRequires:  blas-devel lapack-devel dune-common-devel
BuildRequires:  git suitesparse-devel doxygen bc ert.ecl-devel opm-common-devel
BuildRequires:  tinyxml-devel dune-istl-devel dune-grid-devel
%{?el6:BuildRequires: cmake28 devtoolset-3-toolchain boost148-devel}
%{!?el6:BuildRequires: cmake gcc gcc-c++ boost-devel}
BuildRequires:  opm-parser-devel
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
Requires:       libopm-output1 = %{version}

%description
This module enables data output.

%package -n libopm-output1
Summary:        Data output management module for OPM
Group:          System/Libraries

%description -n libopm-output1
This module enables data output.

%package devel
Summary:        Development and header files for opm-grid
Group:          Development/Libraries/C and C++
Requires:       %{name} = %{version}
Requires:       libopm-output1 = %{version}

%description devel
This package contains the development and header files for opm-output

%package doc
Summary:        Documentation files for opm-output
Group:          Documentation
BuildArch:	noarch

%description doc
This package contains the documentation files for opm-output

%package bin
Summary:        Applications in opm-output
Group:          Scientific
Requires:       %{name} = %{version}
Requires:       libopm-output1 = %{version}

%description bin
This package contains the applications for opm-output

%prep
%setup -q -n %{name}-release-%{version}-%{tag}

# consider using -DUSE_VERSIONED_DIR=ON if backporting
%build
%{?el6:scl enable devtoolset-3 bash}
%{?el6:cmake28} %{!?el6:cmake} -DBUILD_SHARED_LIBS=1 -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=%{_prefix} -DCMAKE_INSTALL_DOCDIR=share/doc/%{name}-%{version} -DUSE_RUNPATH=OFF %{?el6:-DCMAKE_CXX_COMPILER=/opt/rh/devtoolset-3/root/usr/bin/g++ -DCMAKE_C_COMPILER=/opt/rh/devtoolset-3/root/usr/bin/gcc -DCMAKE_Fortran_COMPILER=/opt/rh/devtoolset-3/root/usr/bin/gfortran -DBOOST_LIBRARYDIR=%{_libdir}/boost148 -DBOOST_INCLUDEDIR=%{_includedir}/boost148}
make

%install
make install DESTDIR=${RPM_BUILD_ROOT}
make install-html DESTDIR=${RPM_BUILD_ROOT}

%clean
rm -rf %{buildroot}

%post -n libopm-output1 -p /sbin/ldconfig

%postun -n libopm-output1 -p /sbin/ldconfig

%files
%doc COPYING README.md

%files doc
%{_docdir}/*

%files -n libopm-output1
%defattr(-,root,root,-)
%{_libdir}/*.so.*

%files devel
%defattr(-,root,root,-)
%{_libdir}/*.so
%{_libdir}/dunecontrol/*
%{_libdir}/pkgconfig/*
%{_includedir}/*
%{_datadir}/cmake/*

%files bin
%{_bindir}/*
