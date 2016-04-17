ALTER TABLE aliases OWNER TO {{vmail_user}};
ALTER TABLE domains OWNER TO {{vmail_user}};
ALTER TABLE users OWNER TO {{vmail_user}};
ALTER SEQUENCE seq_vmail_alias_id OWNER TO {{vmail_user}};
ALTER SEQUENCE seq_vmail_domain_id OWNER TO {{vmail_user}};
ALTER SEQUENCE seq_vmail_user_id OWNER TO {{vmail_user}};
