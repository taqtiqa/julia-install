#!/usr/bin/env bash

# Debian is a snowflake - where is global warming when it's needed?
__ji_detect_debian_major_version_from_codename()
{
  case $_system_version in
    buster*)  _system_version="10";;
    stretch*) _system_version="9";;
    jessie*)  _system_version="8";;
    wheezy*)  _system_version="7";;
    squeeze*) _system_version="6";;
    lenny*)   _system_version="5";;
    etch*)    _system_version="4";;
    sarge*)   _system_version="3";;
    woody*)   _system_version="3";;
    potato*)  _system_version="2";;
    slink*)   _system_version="2";;
    hamm*)    _system_version="2";;
  esac
}

__ji_detect_system_from_lsb_release()
{
  local __system_name="$( awk -F'=' '$1=="DISTRIB_ID"{print $2}' /etc/lsb-release | head -n 1 | tr '[A-Z]' '[a-z]' | tr -d \" )"

  case $__system_name in
    deepin*)        _system_name="Deepin";;
    elementary*)    _system_name="Elementary";;
    kali*)          _system_name="Kali";;
    linuxmint*)     _system_name="Mint";;
    manjarolinux*)  _system_name="Manjaro";;
    neon*)          _system_name="Ubuntu";;
    solus*)         _system_name="Solus";;
    trisquel*)      _system_name="Trisquel";;
    ubuntu*)        _system_name="Ubuntu";;
    zorin*)         _system_name="Ubuntu";;
    *)              return 1
  esac

  _system_version="$( awk -F'=' '$1=="DISTRIB_RELEASE"{print $2}' /etc/lsb-release | head -n 1 )"
  _system_arch="$( uname -m )"

  return 0
}

__ji_detect_system_from_os_release()
{
  local __system_name="$( awk -F'=' '$1=="ID"{print $2}' /etc/os-release | head -n 1 | tr '[A-Z]' '[a-z]' | tr -d \" )"

  case $__system_name in
    amzn*)
      _system_name="amazon"
      _system_version="$( awk -F'=' '$1=="VERSION_ID"{gsub(/"/,"");print $2}' /etc/os-release | head -n 1 )"
      _system_arch="$( uname -m )"
      ;;

    opensuse*)
      _system_name="opensuse"
      _system_version="$( awk -F'=' '$1=="VERSION_ID"{gsub(/"/,"");print $2}' /etc/os-release | head -n 1 )"
      _system_arch="$( uname -m )"
      ;;

    pclinuxos*)
      _system_name="pclinuxos"
      _system_version="$(GREP_OPTIONS="" \command \grep -Eo '[0-9\.]+' /etc/redhat-release  | \command \awk -F. '{print $1}' | head -n 1)"
      _system_arch="$( uname -m )"
      ;;

    void*)
      _system_name="void"
      _system_version="$(\command \lsb_release -a | \command awk -F: '/Release/{gsub(" |\t",""); print $2}')"
      _system_arch="$( uname -m )"
      ;;

    debian*)
      _system_name="debian"
      _system_version="$(awk -F'=' '$1=="VERSION_ID"{gsub(/"/,"");print $2}' /etc/os-release | \command \awk -F. '{print $1}' | head -n 1)"
      _system_arch="$( dpkg --print-architecture )"

      if
        [ -z "$_system_version" ]
      then
        _system_version="$(\command \cat /etc/debian_version | \command \awk -F. '{print $1}' | head -n 1)"
      fi

      __ji_detect_debian_major_version_from_codename
      ;;

    *)
      return 1
  esac

  return 0
}

__ji_detect_system()
{
  unset  _system_type _system_name _system_version _system_arch
  export _system_type _system_name _system_version _system_arch

  _system_info="$(command uname -a)"
  _system_type="unknown"
  _system_name="unknown"
  _system_name_lowercase="unknown"
  _system_version="unknown"
  _system_arch="$(command uname -m)"

  case "$(command uname)" in
    (Linux|GNU*)

      _system_type="Linux"

      if [[ -f /etc/lsb-release ]] && __ji_detect_system_from_lsb_release
      then
        :
      elif
        [[ -f /etc/os-release ]] && __ji_detect_system_from_os_release
      then
        :
      elif
        [[ -f /etc/altlinux-release ]]
      then
        _system_name="Arch"
        _system_version="libc-$(ldd --version  | \command \awk 'NR==1 {print $NF}' | \command \awk -F. '{print $1"."$2}' | head -n 1)"
      elif
        [[ -f /etc/SuSE-release ]]
      then
        _system_name="SuSE"
        _system_version="$( \command \awk -F'=' '{gsub(/ /,"")} $1~/VERSION/ {version=$2} $1~/PATCHLEVEL/ {patch=$2} END {print version"."patch}' < /etc/SuSE-release )"
      elif
       [[ -f /etc/devuan_version ]]
      then
        _system_name="Devuan"
        _system_version="$(\command \cat /etc/devuan_version | \command \awk -F. '{print $1}' | head -n 1)"
        _system_arch="$( dpkg --print-architecture )"
      elif
        [[ -f /etc/sabayon-release ]]
      then
        # needs to be before gentoo
        _system_name="Sabayon"
        _system_version="$(\command \cat /etc/sabayon-release | \command \awk 'NR==1 {print $NF}' | \command \awk -F. '{print $1"."$2}' | head -n 1)"
      elif
        [[ -f /etc/gentoo-release ]]
      then
        _system_name="Gentoo"
        _system_version="base-$(\command \cat /etc/gentoo-release | \command \awk 'NR==1 {print $NF}' | \command \awk -F. '{print $1"."$2}' | head -n 1)"
      elif
        [[ -f /etc/arch-release ]]
      then
        _system_name="Arch"
        _system_version="libc-$(ldd --version  | \command \awk 'NR==1 {print $NF}' | \command \awk -F. '{print $1"."$2}' | head -n 1)"
      elif
        [[ -f /etc/fedora-release ]]
      then
        _system_name="Fedora"
        _system_version="$(GREP_OPTIONS="" \command \grep -Eo '[0-9]+' /etc/fedora-release | head -n 1)"
      elif
        [[ -f /etc/oracle-release ]]
      then
        _system_name="Oracle"
        _system_version="$(GREP_OPTIONS="" \command \grep -Eo '[0-9\.]+' /etc/oracle-release  | \command \awk -F. '{print $1}' | head -n 1)"
      elif
        [[ -f /etc/redhat-release ]]
      then
        _system_name="$( GREP_OPTIONS="" \command \grep -Eo 'CentOS|PCLinuxOS|ClearOS|Mageia|Scientific|ROSA Desktop|OpenMandriva' /etc/redhat-release 2>/dev/null | \command \head -n 1 | \command \sed "s/ //" )"
        _system_name="${_system_name:-CentOS}"
        _system_version="$(GREP_OPTIONS="" \command \grep -Eo '[0-9\.]+' /etc/redhat-release  | \command \awk -F. 'NR==1{print $1}' | head -n 1)"
        _system_arch="$( uname -m )"
      elif
        [[ -f /etc/centos-release ]]
      then
        _system_name="CentOS"
        _system_version="$(GREP_OPTIONS="" \command \grep -Eo '[0-9\.]+' /etc/centos-release  | \command \awk -F. '{print $1}' | head -n 1)"
      elif
        [[ -f /etc/debian_version ]]
      then
        _system_name="Debian"
        _system_version="$(\command \cat /etc/debian_version | \command \awk -F. '{print $1}' | head -n 1)"
        _system_arch="$( dpkg --print-architecture )"
        __ji_detect_debian_major_version_from_codename
      elif
        [[ -f /proc/devices ]] &&
        GREP_OPTIONS="" \command \grep -Eo "synobios" /proc/devices >/dev/null
      then
        _system_type="BSD"
        _system_name="Synology"
        _system_version="libc-$(ldd --version  | \command \awk 'NR==1 {print $NF}' | \command \awk -F. '{print $1"."$2}' | head -n 1)"
      else
        _system_version="libc-$(ldd --version  | \command \awk 'NR==1 {print $NF}' | \command \awk -F. '{print $1"."$2}' | head -n 1)"
      fi
      ;;

    (SunOS)
      _system_type="SunOS"
      _system_name="Solaris"
      _system_version="$(command uname -v)"
      _system_arch="$(command isainfo -k)"

      if
        [[ "${_system_version}" == joyent* ]]
      then
        _system_name="SmartOS"
        _system_version="${_system_version#* }"
      elif
        [[ "${_system_version}" == omnios* ]]
      then
        _system_name="OmniOS"
        _system_version="${_system_version#* }"
      elif
        [[ "${_system_version}" == oi* || "${_system_version}" == illumos* ]]
      then
        _system_name="OpenIndiana"
        _system_version="${_system_version#* }"
      elif
        [[ "${_system_version}" == Generic* ]]
      then
        _system_version="10"
      elif
        [[ "${_system_version}" == *11* ]]
      then
        _system_version="11"
      # is else needed here?
      fi
      ;;

    (FreeBSD)
      _system_type="BSD"
      _system_name="FreeBSD"
      _system_version="$(command uname -r)"
      _system_version="${_system_version%%-*}"
      ;;

    (OpenBSD)
      _system_type="BSD"
      _system_name="OpenBSD"
      _system_version="$(command uname -r)"
      ;;

    (DragonFly)
      _system_type="BSD"
      _system_name="DragonFly"
      _system_version="$(command uname -r)"
      _system_version="${_system_version%%-*}"
      ;;

    (NetBSD)
      _system_type="BSD"
      _system_name="NetBSD"
      _system_version_full="$(command uname -r)"
      _system_version="$(echo ${_system_version_full} | \command \awk -F. '{print $1"."$2}')"
      ;;

    (Darwin)
      _system_type="Darwin"
      _system_name="OSX"
      _system_version="$(sw_vers -productVersion | \command \awk -F. '{print $1"."$2}')"
      ;;

    (CYGWIN*)
      _system_type="Windows"
      _system_name="Cygwin"
      ;;

    (MINGW*)
      _system_type="Windows"
      _system_name="Mingw"
      ;;

    (*)
      return 1
      ;;
  esac

  _system_type="${_system_type//[ \/]/_}"
  _system_name="${_system_name//[ \/]/_}"
  _system_version="${_system_version//[ \/]/_}"
  _system_arch="${_system_arch//[ \/]/_}"
  _system_arch="${_system_arch/amd64/x86_64}"
  _system_arch="${_system_arch/i[123456789]86/i386}"

  # Convert to lowercase...
  _system_type_lowercase="${_system_type,,}"
  _system_name_lowercase="${_system_name,,}"
  _system_version_lowercase="${_system_version,,}"
  _system_arch_lowercase="${_system_arch,,}"

}
