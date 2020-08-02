#include <stdio.h>
#include <string.h>
#include <signal.h>
#include <poll.h>
#include <X11/Xlib.h>
#include <X11/extensions/Xrandr.h>

int count = 0;

void
finish(int signal)
{
	count++;
}

int
main(int argc, char **argv)
{
	Display *dpy;
	struct pollfd fds[1];
	struct sigaction action;

	memset(&action, 0, sizeof(struct sigaction));
	action.sa_handler = finish;
	sigaction(SIGINT, &action, NULL);
	sigaction(SIGTERM, &action, NULL);

	if (!(dpy = XOpenDisplay(NULL))) {
		fprintf(stderr, "Failed to open display.\n");
		return 1;
	}

	XRRSelectInput(dpy, DefaultRootWindow(dpy), RROutputChangeNotifyMask);
	XSync(dpy, False);

	fds[0].fd = ConnectionNumber(dpy);
	fds[0].events = POLLIN;
	if (!count)
		poll(fds, 1, -1);

	XCloseDisplay(dpy);

	return count;
}
