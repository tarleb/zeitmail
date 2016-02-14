include:
  - .fpm

php:
  pkg.installed:
    - name: php5
    - require:
      - pkg: php-fpm
