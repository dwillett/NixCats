# Package definitions
# Each value in this attribute set should be a set function with pkgs
{
  inputs,
  nixpkgs,
  utils,
  ...
}: {
  # <category>
  # ├─ coding
  # ├─ debug
  # ├─ editor
  # ├─ formatting
  # ├─ lsp
  # ├─ markdown
  # ├─ treesitter
  # ├─ ui
  # └─ util
  nixCats = {pkgs, ...} @ misc: {
    # Full neovim instance

    # they contain a settings set defined above
    # see :help nixCats.flake.outputs.settings
    settings = {
      suffix-path = true;
      suffix-LD = true;
      wrapRc = true;
      configDirName = "neovim-nixCats";
      neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
      hosts = {
        python3.enable = true;
        node.enable = true;
      };
      # Extra aliases
      aliases = ["nc-full"];
    };

    # and a set of categories that you want
    categories = {
      coding = true;
      debug = true;
      editor = true;
      formatting = true;
      lsp = true;
      markdown = true;
      testing = true;
      treesitter = true;
      ui = true;
      util = true;
    };

    # Extra arguments ta be made available to nixCats
    extra = {
      colorscheme = {
        name = "catppuccin";
        style = "mocha";
        translucent = true;
      };
      # Override this in a home-manager config
      nix = {
        flake = "";
        host = "";
        user = "";
      };
    };
  };

  # An empty installation of neovim, to use with the system
  nixCats-none = {pkgs, ...} @ misc: {
    settings = {
      suffix-path = true;
      suffix-LD = true;
      wrapRc = true;
      configDirName = "neovim-nixCats-none";
      neovim-unwrapped = pkgs.neovim-unwrapped;
      hosts = {
        python3.enable = false;
        node.enable = false;
      };
      # Extra aliases
      aliases = ["nc-none"];
    };
    categories = {
      coding = false;
      debug = false;
      editor = false;
      formatting = false;
      lsp = false;
      markdown = false;
      testing = false;
      treesitter = false;
      ui = false;
      util = false;
    };
    extra = {
      # Just a marker to make sure some behavior is disabled
      weAreOld = true;
      colorscheme = {
        name = "";
      };
    };
  };
}
