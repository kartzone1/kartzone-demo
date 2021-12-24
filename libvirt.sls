libvirt:
{% if grains['os'] == "Debian" %}
  lookup:
    qemu_pkg: qemu-system-x86
{% endif %}
  extra_pkgs:
    - virt-manager
{% if grains['os'] == "Debian" %}
    - ovmf
    - qemu-efi
    - xauth
{% elif grains['os'] == "Fedora" %}
    - edk2-ovmf
    - python3-libvirt
    - xorg-x11-xauth
    - libguestfs-tools
{% endif %}
