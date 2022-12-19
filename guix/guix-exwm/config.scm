;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu))
(use-modules (gnu packages shells))
(use-modules (gnu services docker))
(use-modules (nongnu packages linux))
(use-service-modules desktop networking ssh xorg)

(operating-system
  (locale "ko_KR.utf8")
  (timezone "Asia/Seoul")
  (kernel linux)
  (firmware (append
	     (list iwlwifi-firmware ibt-hw-firmware)
	     %base-firmware))
  (keyboard-layout (keyboard-layout "kr" "kr104"))
  (host-name "ch1keen-guix")
  (users (cons* (user-account
                  (name "ch1keen")
                  (comment "Ch1keen")
                  (group "users")
		  (shell (file-append fish "/bin/fish"))
                  (home-directory "/home/ch1keen")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video" "docker" "lp")))
                %base-user-accounts))
  (packages
    (append
      (list (specification->package "emacs")
            (specification->package "emacs-exwm")
            (specification->package
             "emacs-desktop-environment")
	    (specification->package "glibc-locales")
	    (specification->package "picom")
	    (specification->package "dconf")
            (specification->package "nss-certs"))
      %base-packages))
  (services
   (append
    (list (service lxqt-desktop-service-type)
	  (service xfce-desktop-service-type)
          (service docker-service-type)
	  (bluetooth-service #:auto-enable? #t))
    %desktop-services))
  (bootloader
    (bootloader-configuration
      (bootloader grub-bootloader)
      (target "/dev/sda")
      (keyboard-layout keyboard-layout)))
  (mapped-devices
    (list (mapped-device
            (source
              (uuid "b86cc40b-5ab1-4219-a4b9-3c31e43c8561"))
            (target "cryptroot")
            (type luks-device-mapping))))
  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device "/dev/mapper/cryptroot")
             (type "ext4")
             (dependencies mapped-devices))
           %base-file-systems)))
