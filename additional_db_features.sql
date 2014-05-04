CREATE EXTENSION "uuid-ossp";
alter table member alter memberid set default uuid_generate_v4();
alter table member alter paymentstatus set default true;
alter table member alter fiftyfivemember set default true;
alter table member ADD inserttime timestamp without time zone NOT NULL DEFAULT now();
INSERT INTO member(
            firstname, lastname, ppassword, gender, address, city, 
            country, email, phonenumber, 
            postalcode, birthday)
    VALUES ('dafault', 'default', 'default', 'default', 'default', 'default', 
            'default', 'default@default', '00123456789', 
            '12345', now());