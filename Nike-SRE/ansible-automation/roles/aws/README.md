Role Name 
=========

This role is for provide infrastructure and services in the aws

Requirements
------------

This service needs:

pre-load vault's of AK and SK from aws accounts


Role Variables
--------------
all tasks need of account variable for to load environment variable to connect a account
all tasks need defined a --vault-password-file


Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

BSD

Author Information
------------------

Name: Alessandro Bahia
email: alessandro.bahia@br.experian.com
