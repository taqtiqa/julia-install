%define name julia-install
%define version 0.7.0
%define release 1

%define buildroot %{_topdir}/BUILDROOT

BuildRoot: %{buildroot}
Source0: https://github.com/jlenv/%{name}/archive/v%{version}.tar.gz
Summary: Installs Julia
Name: %{name}
Version: %{version}
Release: %{release}
License: MIT
URL: https://github.com/jlenv/julia-install#readme
AutoReqProv: no
BuildArch: noarch
Requires: bash, wget > 1.12, tar, bzip2, patch

%description
Installs Julia

%prep
%setup -q

%build

%install
make install PREFIX=%{buildroot}/usr

%files
%defattr(-,root,root)
%{_bindir}/julia-install
%{_datadir}/%{name}/*
%{_mandir}/man1/*
%doc
%{_defaultdocdir}/%{name}-%{version}/*

%changelog
* Wed 31 October 2019 Mark Van de Vyver <mark@taqtiqa.com> - 0.1.0-1
- Rebuilt for version 0.1.0.