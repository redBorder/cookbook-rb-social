Name:     cookbook-rb-social
Version:  %{__version}
Release:  %{__release}%{?dist}

License:  GNU AGPLv3
URL:  https://github.com/redBorder/cookbook-rb-social
Source0: %{name}-%{version}.tar.gz

BuildRequires: maven java-devel

Summary: social  cookbook to install and configure it in redborder environments
Requires: java

%description
%{summary}

%prep
%setup -qn %{name}-%{version}

%build

%install
mkdir -p %{buildroot}/var/chef/cookbooks/rb-social
mkdir -p %{buildroot}/usr/lib64/rb-social

cp -f -r  resources/* %{buildroot}/var/chef/cookbooks/rb-social/
chmod -R 0755 %{buildroot}/var/chef/cookbooks/rb-social
install -D -m 0644 README.md %{buildroot}/var/chef/cookbooks/rb-social/README.md

%pre

%post
case "$1" in
  1)
    # This is an initial install.
    :
  ;;
  2)
    # This is an upgrade.
    su - -s /bin/bash -c 'source /etc/profile && rvm gemset use default && env knife cookbook upload rbsocial && systemctl daemon-reload'
  ;;
esac

%files
%defattr(0755,root,root)
/var/chef/cookbooks/rb-social
%defattr(0644,root,root)
/var/chef/cookbooks/rb-social/README.md

%doc

%changelog
* Thu May 25 2023 Luis J. Blanco <ljblanco@redborder.com> - 0.0.6-1
- parent_id removed from sensor info. Nodes are self aware of either manager or proxy
* Fri Jan 07 2022 David Vanhoucke <dvanhoucke@redborder.com> - 0.0.3-1
- change register to consul
* Fri Nov 26 2021 Vicente Mesa <vimesa@redborder.com> & Eduardo Reyes <eareyes@redborder.com>- 0.0.1
- first spec version
