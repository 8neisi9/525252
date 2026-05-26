use BsAll;
go
open symmetric key UserSymmetricKey decryption by certificate UserCertificate;
select userID, pswd, CONVERT(varchar(50), DECRYPTBYKEY(convert(varbinary(max), pswd))) as decrypted_pswd
from Users;
close symmetric key UserSymmetricKey;
go