include:
  - apt

/etc/apt/preferences.d/10-python-cryptography.pref:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
        Package: python-cryptography python-cffi* python-pyasn1 python-openssl
        Pin: release n=stretch
        Pin-Priority: 850
    - require:
      - pkgrepo: stretch

letsencrypt:
  pkg.installed:
    - require:
      - file: /etc/apt/preferences.d/10-python-cryptography.pref
