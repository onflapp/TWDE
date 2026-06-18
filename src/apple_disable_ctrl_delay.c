/* 
gcc -o /usr/local/bin/apple-disable-ctrl-delay ./apple-disable-ctrl-delay.c 
/usr/local/bin/apple-disable-ctrl-delay /dev/hidraw1
*/

#include <linux/hidraw.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>

int main(int argc, char **argv) {
  char *devpath = getenv("DEVPATH");
  char *devname = getenv("DEVNAME");
  char *device = NULL;

  if (devname) {
    device = devname;
    fprintf(stderr, "use device: %s\n", device);
  }
  else if (devpath) {
    char dbuf[1024];
    snprintf(dbuf, sizeof(dbuf), "/sys%s/hidraw", devpath);

    DIR *d;
    struct dirent *dir;
    d = opendir(dbuf);
    if (d) {
      while((dir = readdir(d)) != NULL) {
        snprintf(dbuf, sizeof(dbuf), "/dev/%s", dir->d_name);
        device = dbuf;
      }
      closedir(d);
    }

    if (device) {
      fprintf(stderr, "use device: %s\n", device);
    }
    else {
      fprintf(stderr, "unable to find hidraw in %s\n", dbuf);
      return 10;
    }
  }
  else if (argc != 2 || strcmp(argv[1], "-h") == 0) {
    fprintf(stderr, "Pass a hidraw device as the first and only parameter!\n");
    fprintf(stderr, "You may find the right device with:\n");
    fprintf(stderr, "  dmesg | grep Apple | grep Keyboard | grep input0 | tail -1 | "
           "sed -e 's/.hidraw\\([[:digit:]]\\+\\)./\\/dev\\/hidraw\\1/'\n");
    return 1;
  }
  else {
    device = argv[1];
  }

  int fd, i, res, desc_size = 0;
  char buf[256];
  struct hidraw_devinfo info;
  
  fd = open(device, O_RDWR | O_NONBLOCK);
  if (fd < 0) {
    perror("Unable to open device");
    return 20;
  }
  memset(&info, 0, sizeof(info));
  memset(buf, 0, sizeof(buf));
  // Get Report Descriptor Size
  res = ioctl(fd, HIDIOCGRDESCSIZE, &desc_size);
  if (res < 0) {
    perror("HIDIOCGRDESCSIZE");
  }
  if (desc_size != 75) {
    fprintf(stderr, "Error: unexpected descriptor size %d; you've probably got "
           "the wrong hidraw device!\n", desc_size);
    return 30;
  }
  // Get Raw Info
  res = ioctl(fd, HIDIOCGRAWINFO, &info);
  if (res < 0) {
    perror("HIDIOCGRAWINFO");
  } else {
    if (info.vendor != 0x05ac) {
      fprintf(stderr, "Error: Wrong vendor ID, make sure you got the right "
             "hidraw device!\n");
      return 40;
    }
    if (info.product != 0x0250) {
      fprintf(stderr, "Warning: Unknown product ID 0x%x!\n", info.product);
    }
  }
  // Get Feature
  buf[0] = 0x09;  // Report Number
  res = ioctl(fd, HIDIOCGFEATURE(256), buf);
  if (res < 0) {
    perror("HIDIOCGFEATURE");
  } else {
    fprintf(stderr, "HID Feature Report (before change):\n\t");
    for (i = 0; i < res; i++) printf("%hhx ", buf[i]);
    puts("\n");
  }
  // Set Feature
  buf[0] = 0x09;  // Report Number
  buf[1] = 0x00;  // Report data
  buf[2] = 0x00;  // padding
  buf[3] = 0x00;  // padding
  res = ioctl(fd, HIDIOCSFEATURE(4), buf);
  if (res < 0) {
    perror("HIDIOCSFEATURE");
  } else {
    fprintf(stderr, "Caps lock delay disabled.\n");
  }
  // Get Feature
  buf[0] = 0x09;  // Report Number
  res = ioctl(fd, HIDIOCGFEATURE(256), buf);
  if (res < 0) {
    perror("HIDIOCGFEATURE");
  } else {
    fprintf(stderr, "HID Feature Report (after change):\n\t");
    for (i = 0; i < res; i++) printf("%hhx ", buf[i]);
    puts("\n");
  }
  close(fd);
  return 0;
}
