;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu))
(use-modules (gnu packages xorg))
(use-modules (gnu packages shells))
(use-modules (gnu services docker))
(use-service-modules desktop networking ssh xorg)

(operating-system
  (locale "ko_KR.utf8")
  (timezone "Asia/Seoul")
  (keyboard-layout (keyboard-layout "kr" "kr104"))
  (host-name "ch1keen-guix")
  (users (cons* (user-account
                  (name "ch1keen")
                  (comment "Ch1Keen")
                  (group "users")
		  (shell (file-append fish "/bin/fish"))
                  (home-directory "/home/ch1keen")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video" "docker")))
                %base-user-accounts))
  (packages
    (append
      (list (specification->package "emacs")
            (specification->package "emacs-exwm")
            (specification->package
             "emacs-desktop-environment")
	    (specification->package "icecat")
	    (specification->package "perl")
	    (specification->package "gcc")
	    (specification->package "gcc-toolchain")
	    (specification->package "glibc-locales")
	    (specification->package "alacritty")
	    (specification->package "git")
	    (specification->package "picom")
	    (specification->package "xrandr")
	    (specification->package "docker-compose")
            (specification->package "nss-certs"))
      %base-packages))
  (services
    (append
      (list (service tor-service-type)
	    (service docker-service-type)
            (set-xorg-configuration
              (xorg-configuration
	        (modules
		  (append
		    (list xf86-video-vmware)
		    %default-xorg-modules))
	        (resolutions '((1600 1200)))
                (keyboard-layout keyboard-layout))))
      %desktop-services))
  (bootloader
    (bootloader-configuration
      (bootloader grub-bootloader)
      (targets '("/dev/sda"))
      (keyboard-layout keyboard-layout)))
  (initrd-modules
    (append '("mptspi") %base-initrd-modules))
  (swap-devices
    (list (uuid "e202baff-4a5c-419b-a0e8-c534511db7ea")))
  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device
               (uuid "c1ec5beb-3260-4564-9d28-4bc86b2ddd8f"
                     'ext4))
             (type "ext4"))
           %base-file-systems)))
