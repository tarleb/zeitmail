INSERT INTO domains (name, type) VALUES ('mail.test', 'NATIVE');
INSERT INTO records (domain_id, name, type, content, ttl)
  VALUES (
    (SELECT id FROM domains WHERE name = 'mail.test'),
    'mail.test',
    'SOA',
    'ns1.mail.test hostmaster.mail.test',
    86400
  );
INSERT INTO records (domain_id, name, type, content, ttl)
  VALUES (
    (SELECT id FROM domains WHERE name = 'mail.test'),
    'ns1.mail.test',
    'NS',
    '192.168.23.2',
    3600
  );
INSERT INTO records (domain_id, name, type, content, ttl)
  VALUES (
    (SELECT id FROM domains WHERE name = 'mail.test'),
    'ns2.mail.test',
    'NS',
    '192.168.23.2',
    3600
  );
INSERT INTO records (domain_id, name, type, content, ttl)
  VALUES (
    (SELECT id FROM domains WHERE name = 'mail.test'),
    'mail.test',
    'A',
    '192.168.23.2',
    3600
  );
INSERT INTO records (domain_id, name, type, content, ttl)
  VALUES (
    (SELECT id FROM domains WHERE name = 'mail.test'),
    'smtp.mail.test',
    'A',
    '192.168.23.2',
    3600
  );
INSERT INTO records (domain_id, name, type, content, ttl, prio)
  VALUES (
    (SELECT id FROM domains WHERE name = 'mail.test'),
    'mail.test',
    'MX',
    'smtp.mail.test',
    3600,
    10
  );
