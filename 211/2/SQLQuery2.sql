use BsAll;
go
create master key encryption by password = 'passwOrd123'
open master key decryption by password = 'passwOrd123';
create certificate UserCertificate with subject = 'UserCertificate';
create symmetric key UserSymmetricKey with algorithm = aes_256 encryption by certificate UserCertificate;
close master key;
go

--Шифрует пароли 

use BsAll;
GO
open symmetric key UserSymmetricKey 
decryption by certificate UserCertificate;
update Users 
set pswd = ENCRYPTBYKEY(KEY_GUID('UserSymmetricKey'), CONVERT(varbinary(MAX), pswd))
close symmetric key UserSymmetricKey;
go

--Показывает, как расшифровать пароли
use BsAll;
go
open symmetric key UserSymmetricKey decryption by certificate UserCertificate;
select userID, pswd, CONVERT(varchar(50), DECRYPTBYKEY(convert(varbinary(max), pswd))) as decrypted_pswd
from Users;
close symmetric key UserSymmetricKey;
go
