#include <tunables/global>

###VAR###

###PROFILEATTACH### (attach_disconnected) {
  #include <abstractions/base>
  #include <abstractions/nameservice>

  # Read-only for the install directory
  @{CLICK_DIR}/@{APP_PKGNAME}/                   r,
  @{CLICK_DIR}/@{APP_PKGNAME}/@{APP_VERSION}/    r,
  @{CLICK_DIR}/@{APP_PKGNAME}/@{APP_VERSION}/**  mrklix,

  # Writable home area
  owner @{HOMEDIRS}/apps/@{APP_PKGNAME}/   rw,
  owner @{HOMEDIRS}/apps/@{APP_PKGNAME}/** mrwklix,

  # Read-only system area for other versions
  /var/lib/apps/@{APP_PKGNAME}/   r,
  /var/lib/apps/@{APP_PKGNAME}/** mrkix,

  # Writable system area only for this version.
  /var/lib/apps/@{APP_PKGNAME}/@{APP_VERSION}/   w,
  /var/lib/apps/@{APP_PKGNAME}/@{APP_VERSION}/** wl,

  capability net_admin,
