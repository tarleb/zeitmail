/etc/apt/preferences.d/10-roundcube.pref:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
        Package: roundcube*
        Pin: release n=jessie-backports
        Pin-Priority: 850
