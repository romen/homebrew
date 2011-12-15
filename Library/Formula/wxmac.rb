require 'formula'

def build_python?; ARGV.include? "--python"; end

def which_python
  if ARGV.include? '--system-python'
    '/usr/bin/python'
  else
    'python'
  end
end

class Wxpython < Formula
  url 'http://downloads.sourceforge.net/project/wxpython/wxPython/2.9.2.4/wxPython-src-2.9.2.4.tar.bz2'
  md5 '8dae829b3bb3ccfe279d5d3948562c5f'
end

class Wxmac < Formula
  url 'http://downloads.sourceforge.net/project/wxwindows/2.9.3/wxWidgets-2.9.3.tar.bz2'
  md5 '6b6003713289ea4d3cd9b49c5db5b721'
  homepage 'http://www.wxwidgets.org'

  def options
    [
      ['--python', 'Build Python bindings'],
      ['--system-python', 'Build against the OS X Python instead of whatever is in the path.']
    ]
  end

  def install_wx_python
    opts = [
      # Reference our wx-config
      "WX_CONFIG=#{bin}/wx-config",
      # At this time Wxmac is installed ANSI only
      "UNICODE=0",
      # And thus we have no need for multiversion support
      "INSTALL_MULTIVERSION=0",
      # TODO: see if --with-opengl can work on the wxmac build
      "BUILD_GLCANVAS=0",
      # Contribs that I'm not sure anyone cares about, but
      # wxPython tries to build them by default
      "BUILD_STC=0",
      "BUILD_GIZMOS=0"
    ]
    Dir.chdir "wxPython" do
      system which_python,
          "setup.py",
          "build_ext",
          *opts

      system which_python,
          "setup.py",
          "install",
          "--prefix=#{prefix}",
          *opts
    end
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-osx-cocoa",
                            "--enable-unicode",
                            "--with-macosx-sdk=/Developer/SDKs/MacOSX10.6.sdk",
                            "--with-macosx-version-min=10.6"

    system "make install"

    if build_python?
      ENV['WXWIN'] = Dir.getwd
      Wxpython.new.brew { install_wx_python }
    end
  end

  def caveats
    s = ""

    if build_python?
      s += <<-EOS.undent
        Python bindings require that Python be built as a Framework; this is the
        default for Mac OS provided Python but not for Homebrew python (compile
        using the --framework option).

      EOS
    end

    return s
  end
end
