salt:
  clean_config_d_dir: False
  minion_remove_config: True
  master_remove_config: True
  py_ver: 'py3'
{% if grains['kernel'] == "Linux" %}
  install_packages: True
{% endif %}
  pygit2: python3-pygit2

  lookup:
    salt-master: 'salt-master'
    salt-minion: 'salt-minion'
    salt-syndic: 'salt-syndic'
    salt-cloud: 'salt-cloud'
    salt-ssh: 'salt-ssh'

  minion:
    master: salt
    backup_mode: minion
    id: {{ grains['id']|lower }}
{% if grains['id'] | regex_match('docker-(.*)', ignorecase=True) %}
    grains:
      roles:
        - docker
        - packer
{% endif %}

  master:
    default_include: master.d/*.conf
    interface: 0.0.0.0
    publish_port: 4505
    max_open_files: 100000
    auto_accept: False
    autosign_file: /etc/salt/autosign.conf
    winrepo_dir_ng: /srv/salt/states/win/repo-ng
    winrepo_dir: /srv/salt/states/win/repo
    file_roots:
      base:
        - /srv/salt/states
    pillar_roots:
      base:
       - /srv/salt/pillar

salt_formulas:
  git_opts:
    default:
      baseurl: https://github.com/saltstack-formulas
      basedir: /srv/salt/states
      update: True
      options:
        rev: master
        force_reset: True
  basedir_opts:
    makedirs: True
    user: root
    group: root
    mode: 755
  list:
    base:
      - docker-formula
      - git-formula
      - packages-formula
      - salt-formula
      - sudoers-formula
      - systemd-formula
      - users-formula
      - vim-formula
      - openssh-formula
