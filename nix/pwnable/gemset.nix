{
  bindata = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06lqi4svq5qls9f7nnvd2zmjdqmi2sf82sq78ci5d78fq0z5x2vr";
      type = "gem";
    };
    version = "2.4.10";
  };
  elftools = {
    dependencies = ["bindata"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0p96wj4sz3sfv9yxyl8z530554bkbf82vj24w6x7yf91qa1p8z6i";
      type = "gem";
    };
    version = "1.1.3";
  };
  one_gadget = {
    dependencies = ["elftools"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v079xkzzr1bjff5z2wlzs0k11nk4b04kgy1p63lwhbl12jl7qz1";
      type = "gem";
    };
    version = "1.7.4";
  };
}
