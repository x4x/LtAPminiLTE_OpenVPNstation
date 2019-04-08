#!rsc
# RouterOS script: setup
# 2019 gle  <georg.la8585@gmx.at>

{
  / tool fetch "https://raw.githubusercontent.com/x4x/LtAPminiLTE_OpenVPNstation/master/station_conf/station1.rsc" dst-path="station1.rsc";
  :delay 1s;

  # downlaod certivicates


  # setings:
  :global EmailTo "mail@example.com";
  :global EmailFrom "mail@example.com";
  :global EmailPW "123456";

  :global OvpnUser "abc";
  :global OvpnPW "1234567";
  
  :global user "kron";
  :global pw "1234";
}