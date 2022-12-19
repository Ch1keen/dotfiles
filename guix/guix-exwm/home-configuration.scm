;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules
  (gnu home)
  (gnu packages)
  (gnu services)
  (guix gexp)
  (gnu home services shells))

(home-environment
 (packages (specifications->packages
	    (list
	     "neovim"
	     "git"
	     "rust-alacritty-terminal"
	     "network-manager")))
  (services
    (list (service
            home-bash-service-type
            (home-bash-configuration
              (aliases '())
              (bashrc (list (local-file "./.bashrc" "bashrc")))
              (bash-profile
                (list (local-file "./.bash_profile" "bash_profile"))))))))
