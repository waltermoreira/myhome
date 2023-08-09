let
  fullName = "Walter Moreira";
  mainEmail = "walter@waltermoreira.net";
in
{
  cnt = {
    inherit fullName;
    username = "waltermoreira";
    homeDirectory = "/Users/waltermoreira";
    email = "wmoreira@cnt.canon.com";
    gitEmail = mainEmail;
    system = "x86_64-darwin";
    hostname = "Walters Macbook Pro CNT";
  };
  limaVm = {
    inherit fullName;
    username = "waltermoreira";
    homeDirectory = "/home/waltermoreira.linux";
    email = mainEmail;
    gitEmail = mainEmail;
    system = "x86_64-linux";
    hostname = "lima-nix";
  };
  lima2Vm = {
    inherit fullName;
    username = "waltermoreira";
    homeDirectory = "/home/waltermoreira.linux";
    email = mainEmail;
    gitEmail = mainEmail;
    system = "x86_64-linux";
    hostname = "lima-nix2";
  };
  lima3Vm = {
    inherit fullName;
    username = "waltermoreira";
    homeDirectory = "/home/waltermoreira.linux";
    email = mainEmail;
    gitEmail = mainEmail;
    system = "x86_64-linux";
    hostname = "lima-nix3";
  };
  calvin = {
    inherit fullName;
    username = "walter";
    homeDirectory = "/Users/walter";
    email = mainEmail;
    gitEmail = mainEmail;
    system = "x86_64-darwin";
    hostname = "calvin";
  };
}
