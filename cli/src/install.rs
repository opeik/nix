use color_eyre::eyre::{eyre, Context, Result};
use std::process::Command;

/// Installs XCode CLI tools.
pub fn install_xcode_cli_tools() -> Result<()> {
    let xcode_cli_tools_installed = Command::new("xcode-select")
        .arg("-p")
        .stdout(std::process::Stdio::null())
        .status()?
        .success();

    if xcode_cli_tools_installed {
        return Ok(());
    }

    let updates = Command::new("softwareupdate")
        .arg("--list")
        .output()
        .wrap_err("failed to execute cmd")
        .and_then(|output| {
            output
                .status
                .success()
                .then_some(output.stdout)
                .ok_or_else(|| eyre!("failed to get updates"))
        })
        .and_then(|stdout| String::from_utf8(stdout).wrap_err("failed to convert to utf8"))?;

    let update_id = updates
        .lines()
        .nth(3)
        .ok_or_else(|| eyre!("unable to find xcode cli tools update id"))?;

    let update_status = Command::new("softwareupdate")
        .args(["--install", update_id])
        .output()
        .wrap_err("failed to execute cmd")
        .and_then(|output| {
            String::from_utf8(output.stdout).wrap_err("failed to convert to utf8")
        })?;

    dbg!(update_status);
    Ok(())
}
