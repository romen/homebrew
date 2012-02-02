require 'formula'

class GimpDev < Formula
  url 'ftp://ftp.gimp.org/pub/gimp/v2.7/gimp-2.7.3.tar.bz2'
  homepage 'http://www.gimp.org/'
  md5 '851b55dc4af966e62ef5c8b679bcc623'

  depends_on 'atk'
  depends_on 'gtk+'
  depends_on 'babl'
  depends_on 'gegl'
  depends_on 'glib'
  depends_on 'pango'
  depends_on 'cairo'
  depends_on 'gettext'
  depends_on 'intltool'
  depends_on 'gdk-pixbuf'
  depends_on 'pkg-config' => :build
  depends_on 'hicolor-icon-theme' => :optional

  def patches
    # Disables mac_twain in the configure,
    # changes etc/gimprc to use open instead of firefox to open URLs
    # and perform a fix on plug-ins/common/file-pdf.c
    # All patches have been found on MacPorts
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--enable-mp", "--with-pdbgen", "--with-x",
                          "--x-includes=/usr/X11R6/include", "--x-libraries=/usr/X11R6/lib",
                          "--without-hal", "--without-alsa", "--without-gvfs", "--without-webkit",
                          "--without-mng", "--disable-python"

    system "/usr/bin/make install"

    gtk_update_icon_cache_path = "#{HOMEBREW_PREFIX}/bin/gtk-update-icon-cache"
    system "test -x #{gtk_update_icon_cache_path} && #{gtk_update_icon_cache_path} -f -t #{HOMEBREW_PREFIX}/share/icons/hicolor || ! test -x #{gtk_update_icon_cache_path}"
  end
end

__END__
diff -cr gimp-2.6.11.ori/configure gimp-2.6.11/configure
*** gimp-2.6.11.ori/configure Fri Aug 12 10:12:35 2011
--- gimp-2.6.11/configure     Fri Aug 12 10:13:19 2011
***************
*** 20928,20934 ****
  
  _ACEOF
  if ac_fn_c_try_cpp "$LINENO"; then :
!   mac_twain_ok=yes
  fi
  rm -f conftest.err conftest.i conftest.$ac_ext
  { $as_echo "$as_me:${as_lineno-$LINENO}: result: $mac_twain_ok" >&5
--- 20928,20934 ----
  
  _ACEOF
  if ac_fn_c_try_cpp "$LINENO"; then :
!   mac_twain_ok=no
  fi
  rm -f conftest.err conftest.i conftest.$ac_ext
  { $as_echo "$as_me:${as_lineno-$LINENO}: result: $mac_twain_ok" >&5
