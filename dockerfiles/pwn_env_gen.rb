#! /usr/bin/ruby

require 'optparse'

# Features:
#   1. Generates Dockerfiles for:
#     - Ubuntu 18.04
#     - Ubuntu 20.04
#     - Ubuntu 22.04
#   2. Checks for dependencies
#   3. Manages dependencies and version in docker-related files
#   4. Help generating core files when you're working inside of the docker
#     - There must be a method checking about that
#
#   5. Subcommands that build and update images
#
# Script flow:
#   1. Checks for dependencies:
#     - ruby
#     - docker or podman, and it's compose
#     - buildah, if podman exists
#   2. Generates Dockerfiles and it's composes
#
#
# Options and banner:
#   Usage: argv[0] [COMMAND] [OPTION]
#
#   Commands:
#     install    Copy this file into $PATH
#     generate   Generates Dockerfiles and it's composes
#     bootstrap  Build all images using generated dockerfiles
#     clean      Remove generated dockerfiles, composes and container images
#
#   Options
#     -f --force
#     -v --verbose
#     -h --help

CONFIG_RUBY_VERSION = '3.1.3'.freeze
CONFIG_GENERATE_PATH = '/home/ch1keen/hacks'.freeze

FLAG_BOOTSTRAP = 0

def check_dependencies
  # This method checks whether dependencies are exist and available.
  # Checks for:
  #   - podman first, docker later.
  #     (I want to stick to podman)
  #   - podman-compose (docker-compose if not exists)
  puts '[+] Checking for dependencies...'

  deps = {}
  if system('which', out: :close, err: :close).nil?
    puts "[!] 'which' is not installed, but it doesn't matter.\nTrying to check without 'which'..."

    deps[:podman] = system('podman --help', out: :close, err: :close).nil?
    deps[:docker] = system('docker --help', out: :close, err: :close).nil?
    deps[:buildah] = system('buildah --version', out: :close, err: :close).nil?
  else
    puts "[+] 'which' is installed."

    deps[:podman] = system 'which podman', out: :close, err: :close
    deps[:docker] = system 'which docker', out: :close, err: :close
    deps[:buildah] = system 'which buildah', out: :close, err: :close
  end
  __check_dependencies(podman: deps[:podman], docker: deps[:docker], buildah: deps[:buildah])

  core_pattern = '/proc/sys/kernel/core_pattern'.freeze
  print "[!] This is the content of #{core_pattern}:\n    " + IO.read(core_pattern)
end

def __check_dependencies(podman:, docker:, buildah:)
  # First, check for podman. It could be good when podman is aliased to docker.
  if !podman
    # Podman is not installed
    puts '[!] podman is not installed. I highly recommend you to use podman.'

    unless docker
      puts '[!] docker is not installed. But this script will generate the scripts anyway.'
      puts '[?] Does it seem to be a bug? Are there except for podman and docker?'
      puts '    Let me know it by creating an issue! https://github.com/Ch1keen'
    end
  elsif !buildah
    # Podman is installed
    puts "[!] buildah is not installed. You won't be able to build an image"
  end
end

def generate_dockerfile(ubuntu_version:, ruby_version:)
  # This method generates `Dockerfile` with given parameters.
  # If file exists in target directory but `--force` is not flagged,
  # the methods prints an error message and raises IOError

  # if parameters are empty, raise an error.

  generated_dockerfile = <<~DOCKERFILE
    FROM ubuntu:#{ubuntu_version}
    WORKDIR /root

    RUN dpkg --add-architecture i386
    RUN apt update
    RUN apt install software-properties-common -y
    RUN apt install libc6:i386 libncurses5:i386 libstdc++6:i386 -y
    RUN apt install build-essential netcat unzip pkg-config wget git curl fish locales -y
    RUN apt install python3 python3-pip -y
    RUN apt install zlib1g-dev libssl-dev -y
    RUN add-apt-repository ppa:neovim-ppa/stable
    RUN apt update
    RUN apt install neovim -y

    # Locales
    RUN locale-gen en_US.UTF-8
    ENV LC_ALL en_US.UTF-8
    ENV LANGUAGE en_US:en
    ENV LANG en_US.UTF-8

    RUN git clone https://github.com/rbenv/rbenv.git /root/.rbenv
    ENV PATH=/root/.rbenv/bin:$PATH
    RUN wget -q https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer -O- | bash
    RUN echo "status --is-interactive; and rbenv init - fish | source" >> /etc/fish/config.fish

    RUN rbenv install #{ruby_version}
    RUN rbenv global #{ruby_version}
    RUN /root/.rbenv/shims/gem install one_gadget pwntools

    RUN python3 -m pip install --upgrade pip
    RUN python3 -m pip install --upgrade pwntools
    RUN python3 -m pip install --upgrade r2pipe

    RUN apt install gdb -y
    RUN git clone https://github.com/pwndbg/pwndbg
    WORKDIR /root/pwndbg
    RUN ./setup.sh

    WORKDIR /root
    RUN git clone https://github.com/radare/radare2 && radare2/sys/install.sh
    RUN r2pm init
    RUN r2pm -ci r2ghidra
    RUN r2pm -ci r2dec

    # Just for fish...
    WORKDIR /hacks
    RUN chsh -s /usr/bin/fish
    ENV SHELL "/usr/bin/fish"

    VOLUME /hacks
    ENTRYPOINT [ "/usr/bin/fish" ]
  DOCKERFILE

  if File.exist? "./#{ubuntu_version}/Dockerfile"
    raise "Cannot generate files: There is a file in ./#{ubuntu_version}/Dockerfile\nUse --force to ignore this error.\n(Files will be overwritten!)"
  end

  Dir.mkdir(ubuntu_version) unless Dir.exist? "./#{ubuntu_version}"
  File.write("./#{ubuntu_version}/Dockerfile", generated_dockerfile)
end

def generate_compose(ubuntu_version:, path:)
  # This method generates `docker-compose.yaml` with given parameters.
  # If file exists in target directory but `--force` is not flagged,
  # the methods prints an error message and raises FileExistsError.

  # if parameters are empty, raise an error.

  generated_compose = <<~COMPOSE
    version: '3.9'

    services:
      pwnable-#{ubuntu_version}:
        build: .
        image: #{ENV['USER']}/pwnable:#{ubuntu_version}
        container_name: pwnable-#{ubuntu_version}
        stdin_open: true
        tty: true
        priviledged: true
        cap_add:
          - SYS_PTRACE
        volumes:
          - #{path}:/hacks
  COMPOSE

  if File.exist? "./#{ubuntu_version}/docker-compose.yaml"
    raise "Cannot generate files: There are ./#{ubuntu_version}/docker-compose.yaml\nUse --force to ignore this error.\n(Files will be overwritten!)"
  end

  Dir.mkdir(ubuntu_version) unless Dir.exist? "./#{ubuntu_version}"
  File.write("./#{ubuntu_version}/docker-compose.yaml", generated_compose)
end

def generate
  # TODO: Supports for emoji
  # TODO: some fancy CLI animations
  check_dependencies

  ubuntu_versions = ['18.04', '20.04', '22.04']

  puts '[+] Generating Dockerfiles...'
  ubuntu_versions.each do |version|
    generate_dockerfile(ubuntu_version: version, ruby_version: CONFIG_RUBY_VERSION)
  end

  puts '[+] Generating docker-config.yaml...'
  ubuntu_versions.each do |version|
    generate_compose(ubuntu_version: version, path: CONFIG_GENERATE_PATH)
  end

  # TODO: build podman images
  puts '[+] All Done! Happy Hacking!!'
end

def banner
  puts 'This is a simple utils for generating and managing pwnable environment'
  puts
  puts 'Commands'
  puts '  install    Copy this file into $PATH'
  puts "  generate   Generates Dockerfiles and it's composes"
  puts '  bootstrap  Builds all images using generated dockerfiles'
  puts '  help       Prints the help banner'
  puts '  clean      Remove generated dockerfiles, composes and container images'
end

def install; end

def run
  case ARGV[0]
  when 'install'
    puts 'Not implemented'
  when 'generate'
    generate
  when 'bootstrap'
    puts 'Not implemented'
  when 'help'
    banner
  else
    banner
  end
end

run