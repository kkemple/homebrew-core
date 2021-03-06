class Optipng < Formula
  desc "PNG file optimizer"
  homepage "http://optipng.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-0.7.5/optipng-0.7.5.tar.gz"
  sha256 "74e54b798b012dff8993fb8d90185ca83f18cfa4935f4a93b0bcfc33c849619d"
  head "http://hg.code.sf.net/p/optipng/mercurial", :using => :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "d5f0a362fc4d8821b73be6767b401bced46b897ef36d56881a10070fb3c07d88" => :el_capitan
    sha256 "2622e60d2f9313b39d2b385e84727e615839d6d531e4c6c7210a53b9cb584f61" => :yosemite
    sha256 "dd532d23f812dbc28b8f32171423946ee6fcfe87eab28665e7b484c83fc55e0e" => :mavericks
  end

  # Fix compilation on 10.10
  # http://sourceforge.net/p/optipng/bugs/47/
  patch :DATA

  def install
    system "./configure", "--with-system-zlib",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/optipng", "-simulate", test_fixtures("test.png")
  end
end

__END__
diff --git a/src/optipng/osys.c b/src/optipng/osys.c
index d816ef7..610250b 100644
--- a/src/optipng/osys.c
+++ b/src/optipng/osys.c
@@ -518,7 +518,7 @@ osys_copy_attr(const char *src_path, const char *dest_path)
     if (chmod(dest_path, sbuf.st_mode) != 0)
         result = -1;
 
-#ifdef AT_FDCWD
+#if defined(AT_FDCWD) && !defined(__APPLE__) && !defined(__SVR4) && !defined(__sun)
     {
         struct timespec times[2];
 
