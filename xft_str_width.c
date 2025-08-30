/* https://superuser.com/questions/628194/shell-command-to-find-width-of-a-text-rendered-with-some-font */

/* cc xft_str_width.c -o xft_str_width `pkg-config --cflags x11 xft freetype2` `pkg-config --libs x11 xft freetype2` */

#include <err.h>
#include <X11/Xft/Xft.h>

int main(int argc, char **argv) {
  Display *dpy = XOpenDisplay(getenv("DISPLAY"));
  if (!dpy) errx(1, "failed to open display %s", getenv("DISPLAY"));
  if (argc != 3) errx(1, "usage: xft_str_width font text-string");

  XftFont *font = XftFontOpenName(dpy, DefaultScreen(dpy), argv[1]);
  if (!font) errx(1, "no font match");

  XGlyphInfo info;
  XftTextExtentsUtf8(dpy, font, (FcChar8*)argv[2], strlen(argv[2]), &info);
  printf("%d\n", info.xOff);
}
