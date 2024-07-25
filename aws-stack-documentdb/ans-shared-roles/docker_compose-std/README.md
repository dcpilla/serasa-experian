# Ansible Role: docker-compose

With docker-compose you can use ansible's 'docker_service' module.


Works with with:

* CentOS 7
* Debian 7, 8
* Fedora 20-24
* Ubuntu 14.04, 16.04

## Example Playbook

    ---
    - hosts: docker-hosts
      become: true
      roles:
        - { role: pauvos.docker-engine }
        - { role: pauvos.docker-compose }

## Role Variables

Available variables are listed below, along with default values:

    docker_compose_cache_valid_time: 84600  # cache_valid_time for apt
    docker_compose_version: 1.8.0           # docker-compose version, don't forget to update the checksum if you change this
    docker_compose_sha256sum: ebc6ab9ed9c971af7efec074cff7752593559496d0d5f7afb6bfd0e0310961ff
