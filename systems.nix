let
  fullName = "Walter Moreira";
in
{
  cnt = {
    inherit fullName;
    username = "waltermoreira";
    homeDirectory = "/Users/waltermoreira";
    email = "wmoreira@cnt.canon.com";
    system = "x86_64-darwin";
    hostname = "Walters Macbook Pro CNT";
  };
  limaVm = {
    inherit fullName;
    username = "waltermoreira";
    homeDirectory = "/home/waltermoreira.linux";
    email = "walter@waltermoreira.net";
    system = "x86_64-linux";
    hostname = "lima-nix";
  };
  calvin = {
    inherit fullName;
    username = "walter";
    homeDirectory = "/Users/walter";
    email = "walter@waltermoreira.net";
    system = "x86_64-darwin";
    hostname = "calvin";
  };
}
