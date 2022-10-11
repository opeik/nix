mod install;

use clap::{Parser, Subcommand};
use color_eyre::eyre::Result;

/// Nix command line interface.
#[derive(Parser)]
#[command(author, version, about, long_about = None)]
#[command(propagate_version = true)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Installs Nix and nix-darwin.
    Install {
        /// Nix configuration attribute.
        #[arg(long, default_value = "foo")]
        config: String,
        /// Should bootstrap?
        #[arg(long, default_value_t = true)]
        should_bootstrap: bool,
        /// Force bootstrap?
        #[arg(long, default_value_t = false)]
        force_bootstrap: bool,
    },
}

fn main() -> Result<()> {
    color_eyre::install()?;
    let cli = Cli::parse();

    match &cli.command {
        Commands::Install {
            config: _,
            should_bootstrap: _,
            force_bootstrap: _,
        } => {
            install::install_xcode_cli_tools()?;
        }
    }

    Ok(())
}
