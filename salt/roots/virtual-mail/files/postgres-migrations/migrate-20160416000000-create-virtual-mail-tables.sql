CREATE SEQUENCE seq_vmail_domain_id START 1;
CREATE SEQUENCE seq_vmail_alias_id START 1;
CREATE SEQUENCE seq_vmail_user_id START 1;

-- Virtual mail domains
CREATE TABLE domains (
	id INTEGER NOT NULL DEFAULT nextval('seq_vmail_domain_id'),
	name VARCHAR(255) NOT NULL,
	PRIMARY KEY (id)
);

-- Virtual mail users
CREATE TABLE users (
	id	INTEGER NOT NULL DEFAULT nextval('seq_vmail_user_id'),
	domain_id INTEGER NOT NULL,
	-- technically, 64 octets would be acceptable.  However, this would leave
	-- no space for subaddresses and is unlikely to be necessary.  The current
	-- value seems large enough and leaves plenty of space for subaddresses.
	username VARCHAR(32) NOT NULL,
	password VARCHAR(255) NOT NULL,
	UNIQUE (domain_id, username),
	PRIMARY KEY (id),
	FOREIGN KEY (domain_id) REFERENCES domains(id) ON DELETE CASCADE
);

-- Virtual mail aliases
CREATE TABLE aliases (
	id INTEGER NOT NULL DEFAULT nextval('seq_vmail_alias_id'),
	domain_id INTEGER NOT NULL,
	source VARCHAR(255) NOT NULL,
	destination VARCHAR(255) NOT NULL,
	FOREIGN KEY (domain_id) REFERENCES domains(id) ON DELETE CASCADE
);
