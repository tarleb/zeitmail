INSERT INTO domains (name, type) VALUES ('mail.test', 'NATIVE');
INSERT INTO records (domain_id, name, type, content, ttl, change_date)
  VALUES (
    (SELECT id FROM domains WHERE name = 'mail.test'),
    'mail.test',
    'SOA',
    'ns1.mail.test hostmaster.mail.test',
    86400,
    2016012501
  );
INSERT INTO records (domain_id, name, type, content, ttl, change_date)
  VALUES (
    (SELECT id FROM domains WHERE name = 'mail.test'),
    'ns1.mail.test',
    'NS',
    '192.168.23.2',
    3600,
    2016012501
  );
INSERT INTO records (domain_id, name, type, content, ttl, change_date)
  VALUES (
    (SELECT id FROM domains WHERE name = 'mail.test'),
    'ns2.mail.test',
    'NS',
    '192.168.23.2',
    3600,
    2016012501
  );
INSERT INTO records (domain_id, name, type, content, ttl, change_date)
  VALUES (
    (SELECT id FROM domains WHERE name = 'mail.test'),
    'mail.test',
    'A',
    '192.168.23.2',
    3600,
    2016012501
  );
INSERT INTO records (domain_id, name, type, content, ttl, change_date)
  VALUES (
    (SELECT id FROM domains WHERE name = 'mail.test'),
    'smtp.mail.test',
    'A',
    '192.168.23.2',
    3600,
    2016012501
  );
INSERT INTO records (domain_id, name, type, content, ttl, prio, change_date)
  VALUES (
    (SELECT id FROM domains WHERE name = 'mail.test'),
    'mail.test',
    'MX',
    'smtp.mail.test',
    3600,
    10,
    2016012501
  );

-- Testing server
INSERT INTO domains (name, type) VALUES ('testing.test', 'NATIVE');
INSERT INTO records (domain_id, name, type, content, ttl, change_date)
  VALUES (
    (SELECT id FROM domains WHERE name = 'testing.test'),
    'testing.test',
    'SOA',
    'ns1.mail.test hostmaster.mail.test',
    86400,
    2016012501
  );
INSERT INTO records (domain_id, name, type, content, ttl, change_date)
  VALUES (
    (SELECT id FROM domains WHERE name = 'testing.test'),
    'testing.test',
    'NS',
    'ns1.mail.test',
    86400,
    2016012501
  );
INSERT INTO records (domain_id, name, type, content, ttl, change_date)
  VALUES (
    (SELECT id FROM domains WHERE name = 'testing.test'),
    'testing.test',
    'A',
    '192.168.23.42',
    3600,
    2016012501
  );

-- Setup reverse DNS
INSERT INTO domains (name, type) VALUES ('23.168.192.in-addr.arpa', 'NATIVE');
INSERT INTO records (domain_id, name, type, content, ttl, change_date)
  VALUES (
    (SELECT id FROM domains WHERE name = '23.168.192.in-addr.arpa'),
    '23.168.192.in-addr.arpa',
    'SOA',
    'ns1.mail.test hostmaster.mail.test',
    86400,
    2016012501
  );
INSERT INTO records (domain_id, name, type, content, ttl, change_date)
  VALUES (
    (SELECT id FROM domains WHERE name = '23.168.192.in-addr.arpa'),
    '23.168.192.in-addr.arpa',
    'NS',
    'ns1.mail.test',
    86400,
    2016012501
  );
INSERT INTO records (domain_id, name, type, content, ttl, change_date)
  VALUES (
    (SELECT id FROM domains WHERE name = '23.168.192.in-addr.arpa'),
    '2.23.168.192.in-addr.arpa',
    'PTR',
    'mail.test',
    86400,
    2016012501
  );
INSERT INTO records (domain_id, name, type, content, ttl, change_date)
  VALUES (
    (SELECT id FROM domains WHERE name = '23.168.192.in-addr.arpa'),
    '42.23.168.192.in-addr.arpa',
    'PTR',
    'testing.test',
    86400,
    2016012501
  );
