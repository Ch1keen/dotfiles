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
	     ;; Life without those tools may be
	     ;; HORRIBLE
	     "git"
	     "curl"
	     "wget"
	     "neovim"
	     "ncurses"  ;; `clear` command
	     "unzip"

	     ;; Sound
	     "pavucontrol"

	     ;; Networking & Bluetooth
	     "network-manager"
	     "blueman"

	     ;; Web Browser
	     "ungoogled-chromium"
	     "nyxt"

	     ;; Some Programming Languages
	     "ruby"
	     "python"

	     ;; NONFREE
	     "flatpak"
	     
	     ;; Korean Language
	     "nimf"

	     ;; Ricing
	     "kitty"
	     "feh"
	     "polybar"
	     "dunst"
	     "rofi"

	     ;; Fonts
	     "emacs-highlight-indent-guides"
	     "fontconfig"
	     "font-google-noto"
	     "font-un"
	     "font-jetbrains-mono")))
  (services
    (list (service
            home-fish-service-type
            (home-fish-configuration
	      (config
	       (list
		(plain-file "config" "nimf")))
	      (environment-variables
	       '(("GTK_IM_MODULE" . "nimf")
		 ("QT_IM_MODULE"  . "nimf")
		 ("QT4_IM_MODULE" . "nimf")
		 ("XMODIFIERS" . "@im=nimf")
		 ("XDG_DATA_DIRS" . "$XDG_DATA_DIRS:/var/lib/flatpak/exports/share")
		 ("XDG_DATA_DIRS" . "$XDG_DATA_DIRS:/home/ch1keen/.local/share/flatpak/exports/share")
		 
		 ))
              (aliases
                '(("grep" . "grep --color=auto")
                  ("ll" . "ls -l")
                  ("ls" . "ls -p --color=auto")))
              ))))
)
