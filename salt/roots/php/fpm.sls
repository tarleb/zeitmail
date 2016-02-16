php-fpm:
  pkg.installed:
    - name: php5-fpm
  service.running:
    - name: php5-fpm
    - enable: True
