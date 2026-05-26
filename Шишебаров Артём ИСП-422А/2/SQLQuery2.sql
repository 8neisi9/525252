use BsAll;
go
create master key encryption by password = 'passwOrd123'
open master key decryption by password = 'passwOrd123';
create certificate UserCertificate with subject = 'UserCertificate';
create symmetric key UserSymmetricKey with algorithm = aes_256 encryption by certificate UserCertificate;
close master key;
go
