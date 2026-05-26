use BsAll;
GO
open symmetric key UserSymmetricKey 
decryption by certificate UserCertificate;
update Users 
set pswd = ENCRYPTBYKEY(KEY_GUID('UserSymmetricKey'), CONVERT(varbinary(MAX), pswd))
close symmetric key UserSymmetricKey;
go
